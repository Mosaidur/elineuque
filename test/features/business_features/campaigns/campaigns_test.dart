import 'package:elineuque/features/business_features/campaigns/controllers/campaigns_controller.dart';
import 'package:elineuque/features/business_features/campaigns/models/business_campaign_item_model.dart';
import 'package:elineuque/features/business_features/campaigns/views/widgets/campaign_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CampaignsController Tests', () {
    late CampaignsController controller;

    setUp(() {
      controller = CampaignsController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('CampaignsController initializes with empty campaigns and nav index 3', () {
      expect(controller.selectedNavIndex, 3);
      expect(controller.campaigns.length, 0);
    });

    test('CampaignsController populates form for edit and clears form', () {
      const sample = BusinessCampaignItemModel(
        id: 'c-1',
        title: 'Summer Drive',
        rewardPerPurchase: 40,
        referralLink: 'eliv.app/b/c/1',
        sharedCount: 10,
        purchasedCount: 4,
        conversionRate: 40,
        status: BusinessCampaignStatus.active,
      );
      controller.campaigns = [sample];

      controller.populateFormForEdit(sample);

      expect(controller.editingCampaignId, 'c-1');
      expect(controller.titleController.text, 'Summer Drive');
      expect(controller.rewardController.text, '40');

      controller.clearForm();
      expect(controller.titleController.text, '');
      expect(controller.editingCampaignId, isNull);
    });

    test('CampaignsController toggles pause and resume status', () {
      const sample = BusinessCampaignItemModel(
        id: 'c-1',
        title: 'Summer Drive',
        rewardPerPurchase: 40,
        referralLink: 'eliv.app/b/c/1',
        sharedCount: 10,
        purchasedCount: 4,
        conversionRate: 40,
        status: BusinessCampaignStatus.active,
      );
      controller.campaigns = [sample];

      controller.togglePauseResume('c-1');
      expect(controller.campaigns.first.status, BusinessCampaignStatus.paused);

      controller.togglePauseResume('c-1');
      expect(controller.campaigns.first.status, BusinessCampaignStatus.active);
    });

    test('CampaignsController deletes campaign', () {
      const sample = BusinessCampaignItemModel(
        id: 'c-1',
        title: 'Summer Drive',
        rewardPerPurchase: 40,
        referralLink: 'eliv.app/b/c/1',
        sharedCount: 10,
        purchasedCount: 4,
        conversionRate: 40,
        status: BusinessCampaignStatus.active,
      );
      controller.campaigns = [sample];

      controller.deleteCampaign('c-1');
      expect(controller.campaigns.length, 0);
    });

    testWidgets('CampaignCardWidget renders compact overview with badges and triggers onTap', (tester) async {
      bool tapped = false;
      const sample = BusinessCampaignItemModel(
        id: 'c-1',
        title: 'Summer Drive',
        rewardPerPurchase: 40,
        customerOffer: '15% Discount',
        minimumSpend: 50,
        referralLink: 'eliv.app/b/c/1',
        sharedCount: 10,
        purchasedCount: 4,
        conversionRate: 40,
        status: BusinessCampaignStatus.active,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CampaignCardWidget(
              campaign: sample,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Summer Drive'), findsOneWidget);
      expect(find.text('\$40 / referral'), findsOneWidget);
      expect(find.text('15% Discount'), findsOneWidget);
      expect(find.text('Min: \$50'), findsOneWidget);
      expect(find.text('Details'), findsOneWidget);

      await tester.tap(find.byType(CampaignCardWidget));
      expect(tapped, isTrue);
    });
  });
}
