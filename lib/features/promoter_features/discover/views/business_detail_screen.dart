import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/theme.dart';
import '../controllers/business_detail_controller.dart';
import 'widgets/campaign_summary_card.dart';
import 'widgets/contact_location_card.dart';
import 'widgets/share_buttons_row.dart';

class BusinessDetailScreen extends GetView<BusinessDetailController> {
  const BusinessDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────
            // 1. HERO COVER HEADER
            // ─────────────────────────────
            _buildHeroHeader(context),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─────────────────────────────
                  // 2. ACTIVE CAMPAIGNS HEADER & CHIPS
                  // ─────────────────────────────
                  const Text(
                    'ACTIVE CAMPAIGNS',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Campaign Switcher Chips
                  Obx(
                    () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          controller.business.campaigns.length,
                          (index) {
                            final c = controller.business.campaigns[index];
                            final isSelected = controller.selectedCampaignIndex.value == index;

                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () => controller.selectCampaign(index),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF4C5FF5)
                                        : const Color(0xFF133652),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF4C5FF5)
                                          : AppColors.border,
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Text(
                                    c.title,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : AppColors.textSecondary,
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ─────────────────────────────
                  // 3. SELECTED CAMPAIGN SUMMARY CARD
                  // ─────────────────────────────
                  Obx(
                    () => CampaignSummaryCard(
                      campaign: controller.activeCampaign,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─────────────────────────────
                  // 4. HOW YOU EARN SECTION
                  // ─────────────────────────────
                  Obx(
                    () => Text(
                      'HOW YOU EARN ${controller.activeCampaign.rewardAmount}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildHowYouEarnFlow(),

                  const SizedBox(height: 22),

                  // ─────────────────────────────
                  // 5. STEP 1: YOUR UNIQUE REFERRAL LINK
                  // ─────────────────────────────
                  const Text(
                    'STEP 1 — YOUR UNIQUE REFERRAL LINK',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF092942),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF1B4968),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.link,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.business.referralLink,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFD0DDEB),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 32,
                          child: ElevatedButton.icon(
                            onPressed: controller.copyReferralLink,
                            icon: const Icon(
                              Icons.copy_rounded,
                              size: 13,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Copy',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4C5FF5),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // ─────────────────────────────
                  // 6. STEP 2: SHARE THIS LINK WITH FRIENDS
                  // ─────────────────────────────
                  const Text(
                    'STEP 2 — SHARE THIS LINK WITH FRIENDS',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ShareButtonsRow(
                    onShare: controller.shareVia,
                  ),

                  const SizedBox(height: 22),

                  // ─────────────────────────────
                  // 7. STEP 3: FRIEND OPENS LINK & SHOWS QR
                  // ─────────────────────────────
                  Text(
                    'STEP 3 — FRIEND OPENS LINK & SHOWS QR AT ${controller.business.name.toUpperCase()}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      onPressed: controller.previewFriendView,
                      icon: const Icon(
                        Icons.qr_code_2_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Preview What Your Friend Sees →',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4C5FF5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Center(
                    child: Text(
                      'Customer shows the QR code at ${controller.business.name} counter',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // ─────────────────────────────
                  // 8. STEP 4: BUSINESS SCANS QR → YOU GET PAID
                  // ─────────────────────────────
                  const Text(
                    'STEP 4 — BUSINESS SCANS QR → YOU GET PAID',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF092942),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF1B4968),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF15385C),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 20,
                            color: Color(0xFF7E9EFF),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => Text(
                                  '${controller.activeCampaign.rewardAmount} credited to your wallet',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Only when the customer actually makes a purchase',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─────────────────────────────
                  // 9. CONTACT & LOCATION CARD
                  // ─────────────────────────────
                  ContactLocationCard(
                    location: controller.business.location,
                    hours: controller.business.hours,
                    website: controller.business.website,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1D3E64),
            Color(0xFF0D2845),
            AppColors.background,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Business Avatar
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: controller.business.iconColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: controller.business.iconColor.withValues(alpha: 0.4),
                    width: 1.2,
                  ),
                ),
                child: Icon(
                  controller.business.icon,
                  size: 30,
                  color: controller.business.iconColor,
                ),
              ),

              const SizedBox(height: 12),

              // Verified Badge
              if (controller.business.isVerified)
                const Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 6,
                      color: AppColors.businessPrimary,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'VERIFIED BUSINESS',
                      style: TextStyle(
                        color: AppColors.businessPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 6),

              // Business Title
              Text(
                controller.business.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 4),

              // Subtitle (Category · Distance · Rating)
              Row(
                children: [
                  Text(
                    controller.business.category,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('·', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.location_on_outlined,
                    size: 12,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    controller.business.distanceText,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('·', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.star_rounded,
                    size: 14,
                    color: Color(0xFFFFB74D),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    controller.business.ratingText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHowYouEarnFlow() {
    const steps = [
      {'num': '1', 'label': 'Get Link', 'active': true},
      {'num': '2', 'label': 'Share\nLink', 'active': false},
      {'num': '3', 'label': 'Customer\nBuys', 'active': false},
      {'num': '4', 'label': 'Get Paid', 'active': false},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF092942),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1B4968),
          width: 0.8,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            SizedBox(
              width: 62,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: (steps[i]['active'] as bool)
                          ? const Color(0xFF4C5FF5)
                          : const Color(0xFF17354D),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        steps[i]['num'] as String,
                        style: TextStyle(
                          color: (steps[i]['active'] as bool)
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    steps[i]['label'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 9.5,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            if (i < steps.length - 1)
              Expanded(
                child: Container(
                  height: 1.5,
                  margin: const EdgeInsets.only(top: 12),
                  color: const Color(0xFF264764),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
