import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/theme.dart';
import '../controllers/business_dashboard_controller.dart';
import 'widgets/animated_kpi_card.dart';
import 'widgets/business_bottom_nav.dart';
import 'widgets/business_quick_action_cards.dart';
import 'widgets/public_listing_card.dart';
import 'widgets/recent_activity_section.dart';
import 'widgets/weekly_referrals_chart.dart';

class BusinessDashboardScreen extends StatefulWidget {
  const BusinessDashboardScreen({super.key});

  @override
  State<BusinessDashboardScreen> createState() => _BusinessDashboardScreenState();
}

class _BusinessDashboardScreenState extends State<BusinessDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BusinessDashboardController>().fetchDashboardOverview();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BusinessDashboardController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: BusinessBottomNav(
        selectedIndex: 0,
        onItemSelected: (index) => controller.onNavTap(context, index),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.fetchDashboardOverview,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─────────────────────────────
                // 1. TOP HEADER (TITLE & NOTIFICATIONS)
                // ─────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Business Dashboard',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          controller.businessName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),

                    // Notification Bell Button with Badge Dot
                    GestureDetector(
                      onTap: () => controller.onNotifications(context),
                      child: Stack(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF092942),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF1B4968),
                                width: 0.8,
                              ),
                            ),
                            child: const Icon(
                              Icons.notifications_none_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            right: 3,
                            top: 3,
                            child: Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                color: AppColors.businessPrimary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.background,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ─────────────────────────────
                // 2. 4 ANIMATED KPI SUMMARY CARDS (2x2)
                // ─────────────────────────────
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AnimatedKpiCard(
                            label: 'Total Referrals',
                            targetValue: controller.totalReferrals,
                            subtitle: controller.referralsSubtitle,
                            valueColor: const Color(0xFF5365F5),
                            startAnimation: controller.animateCounters,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AnimatedKpiCard(
                            label: 'Conversions',
                            targetValue: controller.conversionsCount,
                            subtitle: controller.conversionsSubtitle,
                            valueColor: AppColors.businessPrimary,
                            startAnimation: controller.animateCounters,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AnimatedKpiCard(
                            label: 'Revenue Driven',
                            targetValue: controller.revenueDrivenK,
                            prefix: '\$',
                            suffix: 'K',
                            isDecimal: true,
                            subtitle: controller.revenueSubtitle,
                            valueColor: Colors.white,
                            startAnimation: controller.animateCounters,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AnimatedKpiCard(
                            label: 'Rewards Paid',
                            targetValue: controller.rewardsPaidAmount,
                            prefix: '\$',
                            subtitle: controller.rewardsPaidSubtitle,
                            valueColor: const Color(0xFFAB47BC),
                            startAnimation: controller.animateCounters,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ─────────────────────────────
                // 3. WEEKLY REFERRALS ANIMATED BAR CHART
                // ─────────────────────────────
                WeeklyReferralsChart(
                  data: controller.weeklyData,
                  growthRate: controller.weeklyGrowth,
                  startAnimation: controller.animateCounters,
                ),

                const SizedBox(height: 16),

                // ─────────────────────────────
                // 4. QUICK ACTION CARDS (Scan & Verify + Manage Referrals)
                // ─────────────────────────────
                BusinessQuickActionCards(
                  onScanAndVerify: () => controller.onScanAndVerify(context),
                  onManageReferrals: () => controller.onManageReferrals(context),
                ),

                const SizedBox(height: 18),

                // ─────────────────────────────
                // 5. PUBLIC LISTING CARD
                // ─────────────────────────────
                PublicListingCard(
                  title: controller.listingName,
                  category: controller.listingCategory,
                  rating: controller.listingRating,
                  hours: controller.listingHours,
                  description: controller.listingDescription,
                  rewardAmount: controller.rewardPerReferral,
                  activePromoters: controller.activePromotersCount,
                  onEdit: () => controller.onEditPublicListing(context),
                ),

                const SizedBox(height: 18),

                // ─────────────────────────────
                // 6. RECENT ACTIVITY SECTION
                // ─────────────────────────────
                RecentActivitySection(
                  activities: controller.recentActivities,
                  onViewAll: () => controller.onViewAllActivity(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
