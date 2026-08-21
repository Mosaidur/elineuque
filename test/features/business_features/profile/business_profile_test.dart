import 'package:elineuque/features/business_features/dashboard/controllers/business_dashboard_controller.dart';
import 'package:elineuque/features/business_features/profile/controllers/business_profile_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BusinessProfileController Tests', () {
    late BusinessProfileController controller;

    setUp(() {
      Get.testMode = true;
      Get.reset();
      controller = BusinessProfileController();
      controller.onInit();
    });

    tearDown(() {
      controller.onClose();
    });

    test('BusinessProfileController initializes default stats, listing details, and promoters', () {
      expect(controller.selectedNavIndex.value, 4);
      expect(controller.businessName.value, 'FitZone Gym');
      expect(controller.category.value, 'Fitness');
      expect(controller.location.value, 'SF');
      expect(controller.totalReferrals.value, 128);
      expect(controller.totalConverted.value, 94);
      expect(controller.totalRevenue.value, '\$12.4K');
      expect(controller.activePromoters.length, 4);
      expect(controller.activePromoters.first.name, 'Devon Rivera');
      expect(controller.activePromoters.first.totalEarnings, 700);
    });

    test('BusinessProfileController synchronizes with BusinessDashboardController if registered', () {
      final dashboard = BusinessDashboardController();
      dashboard.updateListing(
        name: 'Iron Peak Crossfit',
        category: 'Crossfit',
        hours: 'Open 24 hours',
        description: 'Elite training facility',
        rewardPerReferral: '\$60',
      );
      Get.put<BusinessDashboardController>(dashboard);

      final profileCtrl = BusinessProfileController();
      profileCtrl.onInit();

      expect(profileCtrl.businessName.value, 'Iron Peak Crossfit');
      expect(profileCtrl.category.value, 'Crossfit');
      expect(profileCtrl.listingHours.value, 'Open 24 hours');
      expect(profileCtrl.rewardPerReferral.value, '\$60');
    });

    test('BusinessProfileController executes QR and settings actions without errors', () {
      controller.copyQrLink();
      controller.downloadQr();
      controller.onNotificationPreferences();
      controller.onPaymentAndPayouts();
      controller.onHelpAndSupport();
      controller.onEditListing();
      // Verifies no unhandled exceptions
    });

    test('BusinessProfileController updates navigation index', () {
      controller.onNavTap(0);
      expect(controller.selectedNavIndex.value, 0);
    });
  });
}
