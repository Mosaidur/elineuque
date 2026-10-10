import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/theme.dart';
import '../controllers/home_controller.dart';
import 'widgets/earnings_hero_card.dart';
import 'widgets/mini_business_card.dart';
import 'widgets/promoter_bottom_nav.dart';
import 'widgets/quick_action_cards.dart';
import 'widgets/recent_referral_tile.dart';
import 'widgets/spotlight_featured_card.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

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
          onRefresh: controller.fetchHomeData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─────────────────────────────
              // 1. TOP HEADER (GREETING & NOTIFICATIONS)
              // ─────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          controller.greeting.value,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Obx(
                        () => Text(
                          controller.userName.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Notification Button with Unread Dot
                  GestureDetector(
                    onTap: controller.onNotificationTap,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.border,
                              width: 0.8,
                            ),
                          ),
                          child: const Icon(
                            Icons.notifications_none_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        Obx(
                          () => controller.hasUnreadNotifications.value
                              ? Positioned(
                                  top: 3,
                                  right: 4,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.businessPrimary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ─────────────────────────────
              // 2. TOTAL EARNINGS HERO GRADIENT CARD
              // ─────────────────────────────
              Obx(
                () => EarningsHeroCard(
                  totalEarnings: controller.totalEarnings.value,
                  thisMonth: controller.thisMonthEarnings.value,
                  referrals: controller.totalReferrals.value,
                  converted: controller.convertedCount.value,
                ),
              ),

              const SizedBox(height: 16),

              // ─────────────────────────────
              // 3. QUICK ACTION BUTTONS
              // ─────────────────────────────
              QuickActionCards(
                onBrowseDeals: controller.onBrowseDeals,
                onMyEarnings: controller.onMyEarnings,
                onWithdraw: controller.onWithdraw,
              ),

              const SizedBox(height: 22),

              // ─────────────────────────────
              // 4. BUSINESS SPOTLIGHT HEADER
              // ─────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Business Spotlight',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Pick a campaign → share the link → earn per purchase',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: controller.onBrowseDeals,
                    child: const Text(
                      'All →',
                      style: TextStyle(
                        color: Color(0xFF6B87FF),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ─────────────────────────────
              // 5. FEATURED SPOTLIGHT CARD
              // ─────────────────────────────
              Obx(() {
                if (controller.featuredDeals.isEmpty) {
                  return const SizedBox.shrink();
                }
                final deal = controller.featuredDeals[controller.activeSpotlightIndex.value];
                return SpotlightFeaturedCard(
                  deal: deal,
                  activeIndex: controller.activeSpotlightIndex.value,
                  totalCount: 4,
                  onGetLink: () => controller.onGetLink(deal),
                );
              }),

              const SizedBox(height: 14),

              // ─────────────────────────────
              // 6. MINI BUSINESS CARDS ROW
              // ─────────────────────────────
              Obx(
                () => Row(
                  children: controller.miniBusinesses.map((deal) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: MiniBusinessCard(
                          deal: deal,
                          onTap: () => controller.onGetLink(deal),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // ─────────────────────────────
              // 7. RECENT REFERRALS
              // ─────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Referrals',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.onMyEarnings,
                    child: const Text(
                      'View all →',
                      style: TextStyle(
                        color: Color(0xFF6B87FF),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Obx(() {
                if (controller.recentReferrals.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, width: 0.8),
                    ),
                    child: const Center(
                      child: Text(
                        'No referrals yet. Share a deal to earn rewards!',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ),
                  );
                }
                return Column(
                  children: controller.recentReferrals.map((referral) {
                    return RecentReferralTile(
                      referral: referral,
                      onTap: () {
                        Get.snackbar(
                          referral.name,
                          '${referral.businessName} referral status: ${referral.status.name.toUpperCase()}',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    ),
  );
}
}
