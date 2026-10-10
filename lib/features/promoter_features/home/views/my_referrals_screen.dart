import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/theme.dart';
import '../controllers/my_referrals_controller.dart';
import 'widgets/activity_timeline_card.dart';
import 'widgets/earned_summary_card.dart';
import 'widgets/promoter_bottom_nav.dart';
import 'widgets/referral_journey_guide.dart';
import 'widgets/referral_stat_cards.dart';

class MyReferralsScreen extends GetView<MyReferralsController> {
  const MyReferralsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: Obx(
        () => PromoterBottomNav(
          selectedIndex: controller.selectedNavIndex.value,
          onItemSelected: controller.onNavTap,
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.fetchReferralActivities,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─────────────────────────────
              // 1. TOP HEADER
              // ─────────────────────────────
              const Text(
                'My Referrals',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Track earnings across all your campaigns',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 16),

              // ─────────────────────────────
              // 2. STATS ROW (SHARED, PENDING, CONVERTED)
              // ─────────────────────────────
              Obx(
                () => ReferralStatCards(
                  shared: controller.sharedCount.value,
                  pending: controller.pendingCount.value,
                  converted: controller.convertedCount.value,
                ),
              ),

              const SizedBox(height: 12),

              // ─────────────────────────────
              // 3. TOTAL EARNED & MONTHLY SUMMARY WITH WITHDRAW
              // ─────────────────────────────
              Obx(
                () => EarnedSummaryCard(
                  totalEarned: controller.totalEarned.value,
                  thisMonth: controller.thisMonthEarned.value,
                  onWithdraw: controller.onWithdraw,
                ),
              ),

              const SizedBox(height: 16),

              // ─────────────────────────────
              // 4. REFERRAL JOURNEY GUIDE
              // ─────────────────────────────
              const ReferralJourneyGuide(),

              const SizedBox(height: 22),

              // ─────────────────────────────
              // 5. RECENT ACTIVITY HEADER
              // ─────────────────────────────
              const Text(
                'RECENT ACTIVITY',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),

              const SizedBox(height: 12),

              // ─────────────────────────────
              // 6. ACTIVITY TIMELINE CARDS
              // ─────────────────────────────
              Obx(() {
                if (controller.activities.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, width: 0.8),
                    ),
                    child: const Center(
                      child: Text(
                        'No tracked referrals yet. Share campaigns to see progress!',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ),
                  );
                }
                return Column(
                  children: controller.activities.map((item) {
                    return ActivityTimelineCard(
                      item: item,
                      onShareAgain: () => controller.onShareLinkAgain(item),
                    );
                  }).toList(),
                );
              }),

              const SizedBox(height: 10),

              // ─────────────────────────────
              // 7. FIND MORE BUSINESSES BUTTON
              // ─────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: controller.onFindMoreBusinesses,
                  icon: const Icon(
                    Icons.explore_outlined,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Find More Businesses to Promote',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
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
            ],
          ),
        ),
      ),
    ),
  );
}
}
