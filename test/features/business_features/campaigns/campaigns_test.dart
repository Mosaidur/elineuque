import 'package:elineuque/features/business_features/campaigns/controllers/campaigns_controller.dart';
import 'package:elineuque/features/business_features/campaigns/models/business_campaign_item_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CampaignsController Tests', () {
    late CampaignsController controller;

    setUp(() {
      Get.testMode = true;
      Get.reset();
      controller = CampaignsController();
    });

    tearDown(() {
      controller.onClose();
    });

    test('CampaignsController initializes with default campaigns and nav index', () {
      expect(controller.selectedNavIndex.value, 3);
      expect(controller.campaigns.length, 2);

      final first = controller.campaigns.first;
      expect(first.title, 'Summer Membership Drive');
      expect(first.rewardPerPurchase, 40);
      expect(first.status, BusinessCampaignStatus.active);
    });

    test('CampaignsController creates a new campaign successfully', () {
      controller.clearForm();
      controller.titleController.text = 'Holiday Flash Sale';
      controller.rewardController.text = '60';
      controller.offerController.text = 'Get 25% off personal training';
      controller.endDateController.text = 'Dec 31';

      controller.saveCampaign();

      expect(controller.campaigns.length, 3);
      final newCamp = controller.campaigns.first;
      expect(newCamp.title, 'Holiday Flash Sale');
      expect(newCamp.rewardPerPurchase, 60);
      expect(newCamp.customerOffer, 'Get 25% off personal training');
      expect(newCamp.endDate, 'Ends Dec 31');
      expect(newCamp.status, BusinessCampaignStatus.active);
    });

    test('CampaignsController edits an existing campaign successfully', () {
      final target = controller.campaigns.first;
      controller.populateFormForEdit(target);

      expect(controller.editingCampaignId.value, target.id);
      expect(controller.titleController.text, target.title);

      controller.titleController.text = 'Updated Summer Drive';
      controller.rewardController.text = '55';
      controller.saveCampaign();

      final updated = controller.campaigns.firstWhere((c) => c.id == target.id);
      expect(updated.title, 'Updated Summer Drive');
      expect(updated.rewardPerPurchase, 55);
    });

    test('CampaignsController toggles pause and resume status', () {
      final target = controller.campaigns.first;
      expect(target.status, BusinessCampaignStatus.active);

      controller.togglePauseResume(target.id);
      expect(controller.campaigns.first.status, BusinessCampaignStatus.paused);

      controller.togglePauseResume(target.id);
      expect(controller.campaigns.first.status, BusinessCampaignStatus.active);
    });

    test('CampaignsController deletes campaign', () {
      final initialCount = controller.campaigns.length;
      final targetId = controller.campaigns.first.id;

      controller.deleteCampaign(targetId);
      expect(controller.campaigns.length, initialCount - 1);
      expect(controller.campaigns.any((c) => c.id == targetId), false);
    });

    test('CampaignsController copies referral link', () {
      controller.copyReferralLink('eliv.app/b/fitzone-gym/c/21');
      // No exception thrown
    });

    test('CampaignsController updates nav index', () {
      controller.onNavTap(0);
      expect(controller.selectedNavIndex.value, 0);
    });
  });
}
