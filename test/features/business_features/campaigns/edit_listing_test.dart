import 'package:elineuque/features/business_features/campaigns/controllers/edit_listing_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EditListingController Tests', () {
    late EditListingController controller;

    setUp(() {
      controller = EditListingController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('EditListingController initializes with default values', () {
      expect(controller.selectedTab, 0);
      expect(controller.businessNameController.text, 'FitZone Gym');
      expect(controller.selectedCategory, 'Fitness');
      expect(controller.selectedHours, 'Open until 10pm');
      expect(controller.selectedReward, 40);
      expect(controller.customRewardController.text, '40');
      expect(controller.isLogoUploaded, true);
    });

    test('EditListingController switches tabs correctly', () {
      controller.switchTab(1);
      expect(controller.selectedTab, 1);

      controller.switchTab(2);
      expect(controller.selectedTab, 2);

      controller.switchTab(0);
      expect(controller.selectedTab, 0);
    });

    test('EditListingController updates category and hours', () {
      controller.selectCategory('Wellness');
      expect(controller.selectedCategory, 'Wellness');

      controller.selectHours('Open 24 hours');
      expect(controller.selectedHours, 'Open 24 hours');
    });

    test('EditListingController updates preset and custom rewards', () {
      controller.selectPresetReward(75);
      expect(controller.selectedReward, 75);
      expect(controller.customRewardController.text, '75');

      controller.onCustomRewardChanged('100');
      expect(controller.selectedReward, 100);
    });

    test('EditListingController creates valid CampaignListingModel', () {
      controller.businessNameController.text = 'Apex Fitness';
      controller.selectCategory('Fitness');
      final model = controller.getCurrentListingModel();

      expect(model.businessName, 'Apex Fitness');
      expect(model.category, 'Fitness');
      expect(model.rewardAmount, 40);
    });
  });
}
