import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/theme.dart';
import '../../home/views/widgets/promoter_bottom_nav.dart';
import '../controllers/profile_controller.dart';
import 'widgets/badges_grid.dart';
import 'widgets/edit_profile_card.dart';
import 'widgets/leaderboard_section.dart';
import 'widgets/profile_email_bar.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_stat_cards.dart';
import 'widgets/profile_wallet_card.dart';
import 'widgets/sign_out_button.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

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
          onRefresh: controller.fetchProfileData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─────────────────────────────
              // 1. PROFILE HEADER
              // ─────────────────────────────
              Obx(
                () => ProfileHeader(
                  name: controller.fullName.value,
                  handle: controller.handle.value,
                  rank: controller.rankText.value,
                  avatarUrl: controller.profilePictureUrl.value,
                  localImagePath: controller.localImagePath.value,
                  isEditing: controller.isEditing.value,
                  onEditTap: controller.openEdit,
                  onCancelTap: controller.cancelEdit,
                  onSaveTap: controller.saveProfile,
                  onChangePhoto: controller.onChangePhoto,
                ),
              ),

              const SizedBox(height: 14),

              // ─────────────────────────────
              // 2. EDIT PROFILE CARD (Dynamic Expand/Collapse)
              // ─────────────────────────────
              Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, anim) => SizeTransition(
                    sizeFactor: anim,
                    alignment: Alignment.topCenter,
                    child: child,
                  ),
                  child: controller.isEditing.value
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: EditProfileCard(
                            fullNameCtrl: controller.fullNameCtrl,
                            handleCtrl: controller.handleCtrl,
                            emailCtrl: controller.emailCtrl,
                            phoneCtrl: controller.phoneCtrl,
                            bioCtrl: controller.bioCtrl,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),

              // ─────────────────────────────
              // 3. EMAIL PILL BAR
              // ─────────────────────────────
              Obx(
                () => ProfileEmailBar(
                  email: controller.email.value,
                ),
              ),

              const SizedBox(height: 14),

              // ─────────────────────────────
              // 4. STAT CARDS (EARNED, REFERRALS, CONVERTED)
              // ─────────────────────────────
              Obx(
                () => ProfileStatCards(
                  earned: controller.earnedAmount.value,
                  referrals: controller.totalReferrals.value,
                  converted: controller.convertedCount.value,
                ),
              ),

              const SizedBox(height: 14),

              // ─────────────────────────────
              // 5. AVAILABLE WALLET / WITHDRAW CARD
              // ─────────────────────────────
              Obx(
                () => ProfileWalletCard(
                  availableBalance: controller.availableWallet.value,
                  onWithdraw: controller.onWithdraw,
                ),
              ),

              const SizedBox(height: 20),

              // ─────────────────────────────
              // 6. BADGES SECTION (GRID 2x3)
              // ─────────────────────────────
              Obx(
                () => BadgesGrid(
                  badges: controller.badges,
                  earnedText: controller.badgesEarnedText.value,
                ),
              ),

              const SizedBox(height: 20),

              // ─────────────────────────────
              // 7. LEADERBOARD SECTION
              // ─────────────────────────────
              Obx(
                () => LeaderboardSection(
                  users: controller.leaderboard,
                  selectedPeriod: controller.selectedPeriod.value,
                  periods: controller.leaderboardPeriods,
                  onSelectPeriod: controller.onSelectPeriod,
                ),
              ),

              const SizedBox(height: 24),

              // ─────────────────────────────
              // 8. SIGN OUT BUTTON
              // ─────────────────────────────
              SignOutButton(
                onSignOut: controller.onSignOut,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
