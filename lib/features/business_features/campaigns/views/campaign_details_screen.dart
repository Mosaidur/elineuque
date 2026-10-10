import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/theme.dart';
import '../controllers/campaigns_controller.dart';
import '../models/business_campaign_item_model.dart';
import 'widgets/new_campaign_modal.dart';

class CampaignDetailsScreen extends StatelessWidget {
  final String campaignId;

  const CampaignDetailsScreen({
    super.key,
    required this.campaignId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CampaignsController>();
    final campaignIndex = controller.campaigns.indexWhere((c) => c.id == campaignId);

    if (campaignIndex == -1) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Campaign Details',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        body: const Center(
          child: Text(
            'Campaign not found or has been deleted.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ),
      );
    }

    final campaign = controller.campaigns[campaignIndex];
    final isActive = campaign.status == BusinessCampaignStatus.active;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Campaign Details',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.businessPrimary, size: 22),
            tooltip: 'Edit Campaign',
            onPressed: () {
              controller.populateFormForEdit(campaign);
              _showEditModal(context, controller);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF5350), size: 22),
            tooltip: 'Delete Campaign',
            onPressed: () => _confirmDelete(context, controller, campaign),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Top Header Card: Title, Status, Pause/Resume ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF092942),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF1B4968), width: 0.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          campaign.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.businessPrimary.withValues(alpha: 0.15)
                              : const Color(0xFF223547),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isActive
                                ? AppColors.businessPrimary.withValues(alpha: 0.4)
                                : const Color(0xFF3B5672),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          isActive ? '● ACTIVE' : '❚❚ PAUSED',
                          style: TextStyle(
                            color: isActive ? AppColors.businessPrimary : const Color(0xFF8BB5DA),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        campaign.endDate != null ? campaign.endDate! : 'No expiry set',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── 2. Dual Incentive Section (Promoter Commission vs Customer Offer) ──
            _buildSectionHeader('OFFER BREAKDOWN'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF071F34),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF184160), width: 0.8),
              ),
              child: Column(
                children: [
                  // Promoter Commission
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.businessPrimary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.payments_outlined,
                          size: 20,
                          color: AppColors.businessPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PROMOTER COMMISSION',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '\$${campaign.rewardPerPurchase} per customer referral',
                              style: const TextStyle(
                                color: AppColors.businessPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Paid out automatically upon verified customer checkout',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: Color(0xFF184160), height: 1),
                  ),

                  // Customer Offer
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5365F5).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.card_giftcard_rounded,
                          size: 20,
                          color: Color(0xFF5365F5),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'CUSTOMER RECEIVES',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              campaign.customerOffer?.isNotEmpty == true
                                  ? campaign.customerOffer!
                                  : 'Special Referral Discount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Discount applied when customer redeems referral code',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── 3. Rules & Eligibility Conditions ──
            _buildSectionHeader('RULES & CONDITIONS'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF071F34),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF184160), width: 0.8),
              ),
              child: Column(
                children: [
                  _buildRuleRow(
                    icon: Icons.rule_folder_outlined,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'MINIMUM PURCHASE REQUIREMENT',
                    value: campaign.minimumSpend > 0
                        ? '\$${campaign.minimumSpend} minimum spend per bill'
                        : 'No minimum spend (valid on any purchase)',
                    subtitle: 'Customer bill must meet or exceed this amount to qualify for the referral reward.',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(color: Color(0xFF184160), height: 1),
                  ),
                  _buildRuleRow(
                    icon: Icons.qr_code_scanner_rounded,
                    iconColor: AppColors.businessPrimary,
                    title: 'REDEMPTION METHOD',
                    value: 'Cashier In-Store QR Scan',
                    subtitle: 'Promoter referral QR must be scanned via business terminal/app at checkout.',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(color: Color(0xFF184160), height: 1),
                  ),
                  _buildRuleRow(
                    icon: Icons.timer_outlined,
                    iconColor: const Color(0xFF64B5F6),
                    title: 'CAMPAIGN DURATION',
                    value: campaign.endDate ?? 'Ongoing / Indefinite',
                    subtitle: 'Active promoters can share and earn until this campaign expires.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── 4. Promoter Referral Link ──
            _buildSectionHeader('REFERRAL LINK'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF071F34),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF184160), width: 0.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CAMPAIGN SHARING LINK',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          campaign.referralLink,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller.copyReferralLink(campaign.referralLink, context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5365F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.copy_rounded, size: 14, color: Colors.white),
                              SizedBox(width: 5),
                              Text(
                                'Copy',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── 5. Analytics & Performance ──
            _buildSectionHeader('PERFORMANCE METRICS'),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildAnalyticsCard(
                  title: 'Shares',
                  value: '${campaign.sharedCount}',
                  icon: Icons.share_outlined,
                  color: const Color(0xFF64B5F6),
                ),
                const SizedBox(width: 10),
                _buildAnalyticsCard(
                  title: 'Purchases',
                  value: '${campaign.purchasedCount}',
                  icon: Icons.shopping_bag_outlined,
                  color: AppColors.businessPrimary,
                ),
                const SizedBox(width: 10),
                _buildAnalyticsCard(
                  title: 'Conversion',
                  value: '${campaign.conversionRate}%',
                  icon: Icons.trending_up_rounded,
                  color: const Color(0xFFFFA726),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── 6. Bottom Action Controls (Pause/Resume & Edit) ──
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () => controller.togglePauseResume(campaign.id, context),
                      icon: Icon(
                        isActive ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: Text(
                        isActive ? 'Pause Campaign' : 'Resume Campaign',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF265275), width: 1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        backgroundColor: const Color(0xFF0C2B47),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.populateFormForEdit(campaign);
                        _showEditModal(context, controller);
                      },
                      icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.black),
                      label: const Text(
                        'Edit Campaign',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.businessPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildRuleRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF071F34),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF184160), width: 0.8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditModal(BuildContext context, CampaignsController controller) {
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
        isEditing: true,
        onSave: () => controller.saveCampaign(context),
      ),
    );
  }

  void _confirmDelete(BuildContext context, CampaignsController controller, BusinessCampaignItemModel campaign) {
    showDialog(
      context: context,
      builder: (dlgContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E2228),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Delete Campaign?', style: TextStyle(color: Colors.white, fontSize: 16)),
        content: Text(
          'Are you sure you want to delete "${campaign.title}"? This action cannot be undone.',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgContext),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF5350),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(dlgContext);
              controller.deleteCampaign(campaign.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
