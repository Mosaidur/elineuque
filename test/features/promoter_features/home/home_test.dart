import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:elineuque/features/promoter_features/home/controllers/home_controller.dart';
import 'package:elineuque/features/promoter_features/home/models/recent_referral_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  group('HomeController Tests', () {
    test('HomeController initializes default user stats and lists', () {
      final controller = HomeController();
      Get.put(controller);

      expect(controller.userName.value, 'Devon Rivera');
      expect(controller.greeting.value, 'Good morning 👋');
      expect(controller.totalEarnings.value, '\$1,840.00');
      expect(controller.thisMonthEarnings.value, '+\$420');
      expect(controller.totalReferrals.value, '92');
      expect(controller.convertedCount.value, '78');
      expect(controller.hasUnreadNotifications.value, true);

      expect(controller.featuredDeals.length, 3);
      expect(controller.miniBusinesses.length, 3);
      expect(controller.recentReferrals.length, 3);

      final firstReferral = controller.recentReferrals.first;
      expect(firstReferral.name, 'Marcus J.');
      expect(firstReferral.status, ReferralStatus.paid);
    });

    test('HomeController updates bottom navigation index', () {
      final controller = HomeController();
      Get.put(controller);

      expect(controller.selectedNavIndex.value, 0);
      controller.onNavTap(2);
      expect(controller.selectedNavIndex.value, 2);
    });

    test('HomeController clears unread notifications on tap', () {
      final controller = HomeController();
      Get.put(controller);

      expect(controller.hasUnreadNotifications.value, true);
      controller.onNotificationTap();
      expect(controller.hasUnreadNotifications.value, false);
    });
  });
}
