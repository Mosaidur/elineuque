import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:elineuque/features/business_features/dashboard/controllers/business_dashboard_controller.dart';
import 'package:elineuque/features/business_features/dashboard/models/business_recent_activity_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  group('BusinessDashboardController Tests', () {
    test('BusinessDashboardController initializes default stats and lists', () {
      final controller = BusinessDashboardController();
      Get.put(controller);

      expect(controller.selectedNavIndex.value, 0);
      expect(controller.businessName.value, 'FitZone Gym');
      expect(controller.totalReferrals.value, 128);
      expect(controller.conversionsCount.value, 94);
      expect(controller.revenueDrivenK.value, 12.4);
      expect(controller.rewardsPaidAmount.value, 3760);

      expect(controller.weeklyData.length, 7);
      expect(controller.recentActivities.length, 3);
    });

    test('BusinessDashboardController updates bottom navigation index', () {
      final controller = BusinessDashboardController();
      Get.put(controller);

      controller.onNavTap(1);
      expect(controller.selectedNavIndex.value, 1);

      controller.onNavTap(3);
      expect(controller.selectedNavIndex.value, 3);
    });

    test('BusinessDashboardController activity items have correct status properties', () {
      final controller = BusinessDashboardController();
      Get.put(controller);

      final first = controller.recentActivities.first;
      expect(first.customerName, 'Sarah K.');
      expect(first.status, BusinessActivityStatus.verified);
      expect(first.statusLabel, 'verified');

      final second = controller.recentActivities[1];
      expect(second.customerName, 'Tom M.');
      expect(second.status, BusinessActivityStatus.pending);

      final third = controller.recentActivities[2];
      expect(third.customerName, 'Jen P.');
      expect(third.status, BusinessActivityStatus.paid);
    });
  });
}
