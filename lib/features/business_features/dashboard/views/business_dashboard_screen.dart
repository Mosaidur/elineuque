import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/theme.dart';
import '../controllers/business_dashboard_controller.dart';
import 'widgets/animated_kpi_card.dart';
import 'widgets/business_bottom_nav.dart';
import 'widgets/business_quick_action_cards.dart';
import 'widgets/public_listing_card.dart';
import 'widgets/recent_activity_section.dart';
import 'widgets/weekly_referrals_chart.dart';

class BusinessDashboardScreen extends GetView<BusinessDashboardController> {
  const BusinessDashboardScreen({super.key});

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
                      Obx(
                        () => Text(
                          controller.businessName.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Notification Bell Button with Badge Dot
                  GestureDetector(
                    onTap: controller.onNotifications,
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
              Obx(
                () => Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AnimatedKpiCard(
                            label: 'Total Referrals',
                            targetValue: controller.totalReferrals.value,
                            subtitle: controller.referralsSubtitle,
                            valueColor: const Color(0xFF5365F5),
                            startAnimation: controller.animateCounters.value,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AnimatedKpiCard(
                            label: 'Conversions',
                            targetValue: controller.conversionsCount.value,
                            subtitle: controller.conversionsSubtitle,
                            valueColor: AppColors.businessPrimary,
                            startAnimation: controller.animateCounters.value,
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
                            targetValue: controller.revenueDrivenK.value,
                            prefix: '\$',
                            suffix: 'K',
                            isDecimal: true,
                            subtitle: controller.revenueSubtitle,
                            valueColor: Colors.white,
                            startAnimation: controller.animateCounters.value,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AnimatedKpiCard(
                            label: 'Rewards Paid',
                            targetValue: controller.rewardsPaidAmount.value,
                            prefix: '\$',
                            subtitle: controller.rewardsPaidSubtitle,
                            valueColor: const Color(0xFFAB47BC),
                            startAnimation: controller.animateCounters.value,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ─────────────────────────────
              // 3. WEEKLY REFERRALS ANIMATED BAR CHART
              // ─────────────────────────────
              Obx(
                () => WeeklyReferralsChart(
                  data: controller.weeklyData.toList(),
                  growthRate: controller.weeklyGrowth.value,
                  startAnimation: controller.animateCounters.value,
                ),
              ),

              const SizedBox(height: 16),

              // ─────────────────────────────
              // 4. QUICK ACTION CARDS (Scan & Verify + Manage Referrals)
              // ─────────────────────────────
              BusinessQuickActionCards(
                onScanAndVerify: controller.onScanAndVerify,
                onManageReferrals: controller.onManageReferrals,
              ),

              const SizedBox(height: 18),

              // ─────────────────────────────
              // 5. PUBLIC LISTING CARD
              // ─────────────────────────────
              Obx(
                () => PublicListingCard(
                  title: controller.listingName.value,
                  category: controller.listingCategory.value,
                  rating: controller.listingRating.value,
                  hours: controller.listingHours.value,
                  description: controller.listingDescription.value,
                  rewardAmount: controller.rewardPerReferral.value,
                  activePromoters: controller.activePromotersCount.value,
                  onEdit: controller.onEditPublicListing,
                ),
              ),

              const SizedBox(height: 18),

              // ─────────────────────────────
              // 6. RECENT ACTIVITY SECTION
              // ─────────────────────────────
              Obx(
                () => RecentActivitySection(
                  activities: controller.recentActivities.toList(),
                  onViewAll: controller.onViewAllActivity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
