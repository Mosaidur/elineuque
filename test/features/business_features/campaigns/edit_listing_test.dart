import 'package:elineuque/features/business_features/campaigns/controllers/edit_listing_controller.dart';
import 'package:elineuque/features/business_features/dashboard/controllers/business_dashboard_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  group('EditListingController Tests', () {
    late EditListingController controller;

    setUp(() {
      Get.testMode = true;
      Get.reset();
      controller = EditListingController();
      controller.onInit();
    });

    tearDown(() {
      controller.onClose();
    });

    test('EditListingController initializes with default values', () {
      expect(controller.selectedTab.value, 0);
      expect(controller.businessNameController.text, 'FitZone Gym');
      expect(controller.selectedCategory.value, 'Fitness');
      expect(controller.selectedHours.value, 'Open until 10pm');
      expect(controller.selectedReward.value, 40);
      expect(controller.customRewardController.text, '40');
      expect(controller.isLogoUploaded.value, true);
    });

    test('EditListingController switches tabs correctly', () {
      controller.switchTab(1);
      expect(controller.selectedTab.value, 1);

      controller.switchTab(2);
      expect(controller.selectedTab.value, 2);

      controller.switchTab(0);
      expect(controller.selectedTab.value, 0);
    });

    test('EditListingController updates category and hours', () {
      controller.selectCategory('Wellness');
      expect(controller.selectedCategory.value, 'Wellness');

      controller.selectHours('Open 24 hours');
      expect(controller.selectedHours.value, 'Open 24 hours');
    });

    test('EditListingController updates preset and custom rewards', () {
      controller.selectPresetReward(75);
      expect(controller.selectedReward.value, 75);
      expect(controller.customRewardController.text, '75');

      controller.onCustomRewardChanged('100');
      expect(controller.selectedReward.value, 100);
    });

    test('EditListingController toggles logo upload state', () {
      controller.removeLogo();
      expect(controller.isLogoUploaded.value, false);

      controller.uploadLogo();
      expect(controller.isLogoUploaded.value, true);
    });

    test('EditListingController synchronizes changes to BusinessDashboardController', () {
      final dashboardController = BusinessDashboardController();
      Get.put<BusinessDashboardController>(dashboardController);

      controller.businessNameController.text = 'Apex Fitness Club';
      controller.selectCategory('Wellness');
      controller.selectHours('Open 24 hours');
      controller.descriptionController.text = 'New updated description';
      controller.selectPresetReward(50);

      controller.saveListing();

      expect(dashboardController.businessName.value, 'Apex Fitness Club');
      expect(dashboardController.listingCategory.value, 'Wellness');
      expect(dashboardController.listingHours.value, 'Open 24 hours');
      expect(dashboardController.listingDescription.value, 'New updated description');
      expect(dashboardController.rewardPerReferral.value, '\$50');
    });
  });
}
