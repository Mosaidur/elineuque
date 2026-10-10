import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:elineuque/features/promoter_features/discover/controllers/business_detail_controller.dart';
import 'package:elineuque/features/promoter_features/discover/controllers/discover_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.reset();
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  group('DiscoverController Tests', () {
    test('DiscoverController initializes default businesses and categories', () {
      final controller = DiscoverController();
      Get.put(controller);

      expect(controller.selectedNavIndex.value, 1);
      expect(controller.categories.length, 6);
      expect(controller.businesses.length, 5);
      expect(controller.filteredBusinesses.length, 5);
    });

    test('DiscoverController filters by category', () {
      final controller = DiscoverController();
      Get.put(controller);

      controller.onSelectCategory('Fitness');
      expect(controller.selectedCategory.value, 'Fitness');
      expect(controller.filteredBusinesses.length, 1);
      expect(controller.filteredBusinesses.first.name, 'FitZone Gym');

      controller.onSelectCategory('Café');
      expect(controller.filteredBusinesses.length, 1);
      expect(controller.filteredBusinesses.first.name, 'Kava Brew');

      controller.onSelectCategory('All');
      expect(controller.filteredBusinesses.length, 5);
    });

    test('DiscoverController searches by query', () {
      final controller = DiscoverController();
      Get.put(controller);

      controller.onSearchChanged('luna');
      expect(controller.filteredBusinesses.length, 1);
      expect(controller.filteredBusinesses.first.name, 'Luna Spa');

      controller.onSearchChanged('');
      expect(controller.filteredBusinesses.length, 5);
    });
  });

  group('BusinessDetailController Tests', () {
    test('BusinessDetailController initializes and switches campaigns', () {
      final controller = BusinessDetailController();
      Get.put(controller);

      expect(controller.business.name, 'FitZone Gym');
      expect(controller.selectedCampaignIndex.value, 0);
      expect(controller.activeCampaign.title, 'Summer Membership Drive');
      expect(controller.activeCampaign.rewardAmount, '\$40');

      controller.selectCampaign(1);
      expect(controller.selectedCampaignIndex.value, 1);
      expect(controller.activeCampaign.title, 'Double Reward Week');
      expect(controller.activeCampaign.rewardAmount, '\$80');
    });

    test('BusinessDetailController generates referral link correctly', () {
      final controller = BusinessDetailController();
      Get.put(controller);

      expect(controller.business.referralLink, 'eliv.app/r/rifat354798/fitzone-gym');
    });
  });
}
