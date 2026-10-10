import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:elineuque/features/promoter_features/home/controllers/home_controller.dart';
import 'package:elineuque/features/promoter_features/home/models/recent_referral_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.reset();
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  group('HomeController Tests', () {
    test('HomeController initializes dynamic user stats and lists', () {
      final controller = HomeController();
      Get.put(controller);

      expect(controller.userName.value, 'Promoter');
      expect(controller.greeting.value.startsWith('Good '), true);
      expect(controller.totalEarnings.value, '\$0.00');
      expect(controller.thisMonthEarnings.value, '+\$0');
      expect(controller.totalReferrals.value, '0');
      expect(controller.convertedCount.value, '0');
      expect(controller.hasUnreadNotifications.value, false);

      expect(controller.featuredDeals.isEmpty, true);
      expect(controller.miniBusinesses.isEmpty, true);
      expect(controller.recentReferrals.isEmpty, true);

      controller.recentReferrals.add(const RecentReferral(
        name: 'Marcus J.',
        initials: 'M',
        avatarColor: Color(0xFF4A68FF),
        businessName: 'FitZone Gym',
        timeAgo: '2h ago',
        amount: '\$40',
        status: ReferralStatus.paid,
      ));
      expect(controller.recentReferrals.length, 1);
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

      controller.hasUnreadNotifications.value = true;
      expect(controller.hasUnreadNotifications.value, true);
      controller.onNotificationTap();
      expect(controller.hasUnreadNotifications.value, false);
    });
  });
}
