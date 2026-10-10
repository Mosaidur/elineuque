import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/theme.dart';
import '../../dashboard/views/widgets/business_bottom_nav.dart';
import '../controllers/campaigns_controller.dart';
import 'campaign_details_screen.dart';
import 'widgets/campaign_card_widget.dart';
import 'widgets/new_campaign_modal.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CampaignsController>().fetchCampaigns();
      }
    });
  }

  void _showCampaignModal(BuildContext context, CampaignsController controller, {bool isEditing = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => NewCampaignModal(
        titleController: controller.titleController,
        rewardController: controller.rewardController,
        offerController: controller.offerController,
        minimumSpendController: controller.minimumSpendController,
        endDateController: controller.endDateController,
        isEditing: isEditing,
        onSave: () => controller.saveCampaign(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CampaignsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: BusinessBottomNav(
        selectedIndex: 3,
        onItemSelected: (index) => controller.onNavTap(context, index),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.fetchCampaigns,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                        _showCampaignModal(context, controller, isEditing: false);
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
                if (controller.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                else if (controller.campaigns.isEmpty)
                  Container(
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
                  )
                else
                  Column(
                    children: controller.campaigns.map((campaign) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: CampaignCardWidget(
                          campaign: campaign,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CampaignDetailsScreen(campaignId: campaign.id),
                              ),
                            );
                          },
                          onTogglePause: () => controller.togglePauseResume(campaign.id, context),
                          onEdit: () {
                            controller.populateFormForEdit(campaign);
                            _showCampaignModal(context, controller, isEditing: true);
                          },
                          onDelete: () => controller.deleteCampaign(campaign.id),
                          onCopyLink: () => controller.copyReferralLink(campaign.referralLink, context),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
