import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/theme.dart';
import '../../dashboard/views/widgets/business_bottom_nav.dart';
import '../controllers/business_profile_controller.dart';
import 'widgets/active_listing_banner.dart';
import 'widgets/active_promoters_section.dart';
import 'widgets/business_profile_header.dart';
import 'widgets/business_profile_kpi_row.dart';
import 'widgets/business_settings_menu.dart';
import 'widgets/business_sign_out_button.dart';
import 'widgets/campaign_qr_card.dart';

class BusinessProfileScreen extends GetView<BusinessProfileController> {
  const BusinessProfileScreen({super.key});

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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Header (Avatar, Name, Location, Edit) ──
              Obx(
                () => BusinessProfileHeader(
                  name: controller.businessName.value,
                  category: controller.category.value,
                  location: controller.location.value,
                  onEdit: controller.onEditListing,
                ),
              ),

              const SizedBox(height: 18),

              // ── 2. 3 KPI Stat Cards (Referrals | Converted | Revenue) ──
              Obx(
                () => BusinessProfileKpiRow(
                  referrals: controller.totalReferrals.value,
                  converted: controller.totalConverted.value,
                  revenue: controller.totalRevenue.value,
                ),
              ),

              const SizedBox(height: 16),

              // ── 3. Active Listing Banner Card ──
              Obx(
                () => ActiveListingBanner(
                  rewardAmount: controller.rewardPerReferral.value,
                  activePromoters: controller.activePromotersCount.value,
                  hours: controller.listingHours.value,
                  onEditListing: controller.onEditListing,
                ),
              ),

              const SizedBox(height: 18),

              // ── 4. Campaign QR Code Section ──
              Obx(
                () => CampaignQrCard(
                  referralLink: controller.qrReferralLink,
                  rewardAmount: controller.rewardPerReferral.value,
                  onCopy: controller.copyQrLink,
                  onDownload: controller.downloadQr,
                ),
              ),

              const SizedBox(height: 20),

              // ── 5. Active Promoters Section ──
              Obx(
                () => ActivePromotersSection(
                  promoters: controller.activePromoters.toList(),
                ),
              ),

              const SizedBox(height: 20),

              // ── 6. Business Settings Menu Options ──
              BusinessSettingsMenu(
                onEditListing: controller.onEditListing,
                onNotificationPreferences:
                    controller.onNotificationPreferences,
                onPaymentAndPayouts: controller.onPaymentAndPayouts,
                onHelpAndSupport: controller.onHelpAndSupport,
              ),

              const SizedBox(height: 16),

              // ── 7. Sign Out Button ──
              BusinessSignOutButton(
                onSignOut: controller.signOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
