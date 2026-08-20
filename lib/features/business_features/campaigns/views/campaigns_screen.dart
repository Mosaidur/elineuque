import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/theme.dart';
import '../../dashboard/views/widgets/business_bottom_nav.dart';
import '../controllers/campaigns_controller.dart';
import 'widgets/campaign_card_widget.dart';
import 'widgets/new_campaign_modal.dart';

class CampaignsScreen extends GetView<CampaignsController> {
  const CampaignsScreen({super.key});

  void _showCampaignModal(BuildContext context, {bool isEditing = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewCampaignModal(
        titleController: controller.titleController,
        rewardController: controller.rewardController,
        offerController: controller.offerController,
        endDateController: controller.endDateController,
        isEditing: isEditing,
        onSave: controller.saveCampaign,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: Obx(
        () => BusinessBottomNav(
          selectedIndex: controller.selectedNavIndex.value,
          onItemSelected: controller.onNavTap,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header (Title & Add (+) Button) ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Campaigns',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  // Yellow/Lime Add (+) Button
                  GestureDetector(
                    onTap: () {
                      controller.clearForm();
                      _showCampaignModal(context, isEditing: false);
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.businessPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 22,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // ── Campaigns List ──
              Obx(() {
                final list = controller.campaigns.toList();

                if (list.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: const Center(
                      child: Text(
                        'No campaigns found. Tap + to create one.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  children: list.map((campaign) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: CampaignCardWidget(
                        campaign: campaign,
                        onTogglePause: () =>
                            controller.togglePauseResume(campaign.id),
                        onEdit: () {
                          controller.populateFormForEdit(campaign);
                          _showCampaignModal(context, isEditing: true);
                        },
                        onDelete: () => controller.deleteCampaign(campaign.id),
                        onCopyLink: () =>
                            controller.copyReferralLink(campaign.referralLink),
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
