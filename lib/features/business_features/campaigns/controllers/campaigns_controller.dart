import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../models/business_campaign_item_model.dart';

class CampaignsController extends GetxController {
  final selectedNavIndex = 3.obs; // Campaigns tab is index 3

  final campaigns = <BusinessCampaignItemModel>[
    const BusinessCampaignItemModel(
      id: 'c-1',
      title: 'Summer Membership Drive',
      rewardPerPurchase: 40,
      customerOffer:
          'Refer someone who buys a membership. You earn \$40. They get their first month 50% off.',
      endDate: 'Ends Aug 15',
      referralLink: 'eliv.app/b/fitzone-gym/c/21',
      sharedCount: 128,
      purchasedCount: 94,
      conversionRate: 73,
      status: BusinessCampaignStatus.active,
    ),
    const BusinessCampaignItemModel(
      id: 'c-2',
      title: 'Double Reward Week',
      rewardPerPurchase: 80,
      customerOffer:
          'Limited time: earn double (\$80) per converted referral during promo week.',
      endDate: 'Ends May 15',
      referralLink: 'eliv.app/b/fitzone-gym/c/22',
      sharedCount: 22,
      purchasedCount: 18,
      conversionRate: 82,
      status: BusinessCampaignStatus.paused,
    ),
  ].obs;

  // Form controllers for create/edit modal
  final titleController = TextEditingController();
  final rewardController = TextEditingController();
  final offerController = TextEditingController();
  final endDateController = TextEditingController();
  final editingCampaignId = RxnString();

  void clearForm() {
    titleController.clear();
    rewardController.clear();
    offerController.clear();
    endDateController.clear();
    editingCampaignId.value = null;
  }

  void populateFormForEdit(BusinessCampaignItemModel item) {
    editingCampaignId.value = item.id;
    titleController.text = item.title;
    rewardController.text = '${item.rewardPerPurchase}';
    offerController.text = item.customerOffer ?? '';
    endDateController.text = item.endDate?.replaceAll('Ends ', '') ?? '';
  }

  void saveCampaign() {
    final title = titleController.text.trim();
    final rewardText = rewardController.text.trim();
    final offer = offerController.text.trim();
    final endDateText = endDateController.text.trim();

    if (title.isEmpty) {
      if (Get.context != null && Get.key.currentState?.overlay != null) {
        Get.snackbar(
          'Validation Error',
          'Campaign title cannot be empty.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return;
    }

    final reward = int.tryParse(rewardText) ?? 40;
    final endDateFormatted =
        endDateText.isNotEmpty ? 'Ends $endDateText' : null;

    if (editingCampaignId.value != null) {
      // Update existing campaign
      final index =
          campaigns.indexWhere((c) => c.id == editingCampaignId.value);
      if (index != -1) {
        campaigns[index] = campaigns[index].copyWith(
          title: title,
          rewardPerPurchase: reward,
          customerOffer: offer.isNotEmpty ? offer : null,
          endDate: endDateFormatted,
        );

        if (Get.context != null && Get.key.currentState?.overlay != null) {
          Get.snackbar(
            'Campaign Updated',
            '$title has been updated successfully.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } else {
      // Create new campaign
      final newId = 'c-${campaigns.length + 1}';
      final newCampaign = BusinessCampaignItemModel(
        id: newId,
        title: title,
        rewardPerPurchase: reward,
        customerOffer: offer.isNotEmpty ? offer : null,
        endDate: endDateFormatted,
        referralLink: 'eliv.app/b/fitzone-gym/c/${20 + campaigns.length + 1}',
        sharedCount: 0,
        purchasedCount: 0,
        conversionRate: 0,
        status: BusinessCampaignStatus.active,
      );

      campaigns.insert(0, newCampaign);

      if (Get.context != null && Get.key.currentState?.overlay != null) {
        Get.snackbar(
          'Campaign Created',
          '$title created and active!',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }

    clearForm();
    if (Get.key.currentState != null) {
      Get.back();
    }
  }

  void togglePauseResume(String id) {
    final index = campaigns.indexWhere((c) => c.id == id);
    if (index != -1) {
      final current = campaigns[index];
      final isCurrentlyActive = current.status == BusinessCampaignStatus.active;
      final newStatus = isCurrentlyActive
          ? BusinessCampaignStatus.paused
          : BusinessCampaignStatus.active;

      campaigns[index] = current.copyWith(status: newStatus);

      if (Get.context != null && Get.key.currentState?.overlay != null) {
        Get.snackbar(
          isCurrentlyActive ? 'Campaign Paused' : 'Campaign Resumed',
          '${current.title} is now ${isCurrentlyActive ? 'paused' : 'active'}.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void deleteCampaign(String id) {
    final index = campaigns.indexWhere((c) => c.id == id);
    if (index != -1) {
      final removed = campaigns.removeAt(index);
      if (Get.context != null && Get.key.currentState?.overlay != null) {
        Get.snackbar(
          'Campaign Deleted',
          '${removed.title} has been removed.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void copyReferralLink(String link) {
    Clipboard.setData(ClipboardData(text: 'https://$link'));
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Link Copied',
        '$link copied to clipboard.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onNavTap(int index) {
    if (index == selectedNavIndex.value) return;
    selectedNavIndex.value = index;

    switch (index) {
      case 0:
        if (Get.key.currentState != null) {
          Get.offNamed(AppRoutes.businessDashboard);
        }
        break;
      case 1:
        if (Get.key.currentState != null) {
          Get.toNamed(AppRoutes.businessReferrals);
        }
        break;
      case 2:
        if (Get.key.currentState != null) {
          Get.toNamed(AppRoutes.businessScan);
        }
        break;
      case 3:
        // Already on campaigns
        break;
      case 4:
        if (Get.key.currentState != null) {
          Get.toNamed(AppRoutes.businessProfile);
        }
        break;
      default:
        break;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    rewardController.dispose();
    offerController.dispose();
    endDateController.dispose();
    super.onClose();
  }
}
