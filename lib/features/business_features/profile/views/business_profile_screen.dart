import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/theme.dart';
import '../../dashboard/controllers/business_dashboard_controller.dart';
import '../../dashboard/views/widgets/business_bottom_nav.dart';
import '../controllers/business_profile_controller.dart';
import 'widgets/active_listing_banner.dart';
import 'widgets/active_promoters_section.dart';
import 'widgets/business_profile_header.dart';
import 'widgets/business_profile_kpi_row.dart';
import 'widgets/business_settings_menu.dart';
import 'widgets/business_sign_out_button.dart';
import 'widgets/campaign_qr_card.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final dashboard = context.read<BusinessDashboardController>();
        context.read<BusinessProfileController>().fetchProfile(dashboard);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BusinessProfileController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: BusinessBottomNav(
        selectedIndex: 4,
        onItemSelected: (index) => controller.onNavTap(context, index),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            final dashboard = context.read<BusinessDashboardController>();
            await controller.fetchProfile(dashboard);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 1. Header (Avatar, Name, Location, Edit) ──
                BusinessProfileHeader(
                  name: controller.businessName,
                  category: controller.category,
                  location: controller.location,
                  onEdit: controller.onEditListing,
                ),

                const SizedBox(height: 18),

                // ── 2. 3 KPI Stat Cards (Referrals | Converted | Revenue) ──
                BusinessProfileKpiRow(
                  referrals: controller.totalReferrals,
                  converted: controller.totalConverted,
                  revenue: controller.totalRevenue,
                ),

                const SizedBox(height: 16),

                // ── 3. Active Listing Banner Card ──
                ActiveListingBanner(
                  rewardAmount: controller.rewardPerReferral,
                  activePromoters: controller.activePromotersCount,
                  hours: controller.listingHours,
                  onEditListing: controller.onEditListing,
                ),

                const SizedBox(height: 18),

                // ── 4. Campaign QR Code Section ──
                CampaignQrCard(
                  referralLink: controller.qrReferralLink,
                  rewardAmount: controller.rewardPerReferral,
                  onCopy: () => controller.copyQrLink(context),
                  onDownload: () => controller.downloadQr(context),
                ),

                const SizedBox(height: 20),

                // ── 5. Active Promoters Section ──
                ActivePromotersSection(
                  promoters: controller.activePromoters.toList(),
                ),

                const SizedBox(height: 20),

                // ── 6. Business Settings Menu Options ──
                BusinessSettingsMenu(
                  onEditListing: controller.onEditListing,
                  onNotificationPreferences: () => controller.onNotificationPreferences(context),
                  onPaymentAndPayouts: () => controller.onPaymentAndPayouts(context),
                  onHelpAndSupport: () => controller.onHelpAndSupport(context),
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
      ),
    );
  }
}
