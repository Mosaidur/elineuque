import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../models/leaderboard_user_model.dart';
import '../models/profile_badge_model.dart';

class ProfileController extends GetxController {
  final selectedNavIndex = 4.obs; // Profile tab is index 4

  // Edit Mode toggle
  final isEditing = false.obs;

  // Profile Data
  final fullName = 'rifat15-4798'.obs;
  final handle = '@rifat15_4798'.obs;
  final rankText = 'Rank #4'.obs;
  final email = 'rifat15-4798@diu.edu.bd'.obs;
  final phone = ''.obs;
  final bio = ''.obs;

  // Stats
  final earnedAmount = '\$1,840'.obs;
  final totalReferrals = 92.obs;
  final convertedCount = 78.obs;
  final availableWallet = '\$620.00'.obs;
  final badgesEarnedText = '4 / 6 earned'.obs;

  // Text Controllers for Edit Mode
  late final TextEditingController fullNameCtrl;
  late final TextEditingController handleCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController phoneCtrl;
  late final TextEditingController bioCtrl;

  // Leaderboard period
  final selectedPeriod = 'Monthly'.obs;
  final leaderboardPeriods = <String>['Weekly', 'Monthly', 'All Time'];

  // Badges list
  final badges = <ProfileBadgeModel>[
    const ProfileBadgeModel(
      id: 'b1',
      title: 'First Referral',
      icon: Icons.flash_on_rounded,
      iconColor: Color(0xFFFFD54F),
      isEarned: true,
    ),
    const ProfileBadgeModel(
      id: 'b2',
      title: 'Top 10%',
      icon: Icons.emoji_events_rounded,
      iconColor: Color(0xFFFFB74D),
      isEarned: true,
    ),
    const ProfileBadgeModel(
      id: 'b3',
      title: '10 Conversions',
      icon: Icons.gps_fixed_rounded,
      iconColor: Color(0xFFFF5252),
      isEarned: true,
    ),
    const ProfileBadgeModel(
      id: 'b4',
      title: 'Community Star',
      icon: Icons.star_rounded,
      iconColor: Color(0xFFFFD54F),
      isEarned: true,
    ),
    const ProfileBadgeModel(
      id: 'b5',
      title: '50 Referrals',
      icon: Icons.local_fire_department_rounded,
      iconColor: Color(0xFFFF7043),
      isEarned: false,
    ),
    const ProfileBadgeModel(
      id: 'b6',
      title: 'Power User',
      icon: Icons.diamond_rounded,
      iconColor: Color(0xFF42A5F5),
      isEarned: false,
    ),
  ].obs;

  // Leaderboard list
  final leaderboard = <LeaderboardUserModel>[
    const LeaderboardUserModel(
      rank: 1,
      name: 'Alicia M.',
      initials: 'AM',
      avatarColor: Color(0xFF5365F5),
      referralsCount: 162,
      earnings: '\$3,240',
    ),
    const LeaderboardUserModel(
      rank: 2,
      name: 'Jordan T.',
      initials: 'JT',
      avatarColor: Color(0xFFAB47BC),
      referralsCount: 144,
      earnings: '\$2,890',
    ),
    const LeaderboardUserModel(
      rank: 3,
      name: 'Marcus B.',
      initials: 'MB',
      avatarColor: Color(0xFF26A69A),
      referralsCount: 122,
      earnings: '\$2,450',
    ),
    const LeaderboardUserModel(
      rank: 4,
      name: 'You',
      initials: 'YO',
      avatarColor: Color(0xFF5365F5),
      referralsCount: 92,
      earnings: '\$1,840',
      isCurrentUser: true,
    ),
    const LeaderboardUserModel(
      rank: 5,
      name: 'Priya K.',
      initials: 'PK',
      avatarColor: Color(0xFFFFA726),
      referralsCount: 81,
      earnings: '\$1,620',
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    fullNameCtrl = TextEditingController(text: fullName.value);
    handleCtrl = TextEditingController(text: handle.value);
    emailCtrl = TextEditingController(text: email.value);
    phoneCtrl = TextEditingController(text: phone.value);
    bioCtrl = TextEditingController(text: bio.value);
  }

  void openEdit() {
    fullNameCtrl.text = fullName.value;
    handleCtrl.text = handle.value;
    emailCtrl.text = email.value;
    phoneCtrl.text = phone.value;
    bioCtrl.text = bio.value;
    isEditing.value = true;
  }

  void cancelEdit() {
    isEditing.value = false;
  }

  void saveProfile() {
    if (fullNameCtrl.text.trim().isNotEmpty) {
      fullName.value = fullNameCtrl.text.trim();
    }
    if (handleCtrl.text.trim().isNotEmpty) {
      handle.value = handleCtrl.text.trim().startsWith('@')
          ? handleCtrl.text.trim()
          : '@${handleCtrl.text.trim()}';
    }
    if (emailCtrl.text.trim().isNotEmpty) {
      email.value = emailCtrl.text.trim();
    }
    phone.value = phoneCtrl.text.trim();
    bio.value = bioCtrl.text.trim();

    isEditing.value = false;

    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Profile Updated',
        'Your profile details have been successfully saved.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onChangePhoto() {
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Change Photo',
        'Select a new avatar photo from gallery or camera.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onWithdraw() {
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Withdraw Balance',
        '${availableWallet.value} is being processed to your bank account.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onSelectPeriod(String period) {
    selectedPeriod.value = period;
  }

  void onSignOut() {
    if (Get.key.currentState != null) {
      Get.offAllNamed(AppRoutes.roleSelection);
    }
  }

  void onNavTap(int index) {
    if (index == selectedNavIndex.value) return;

    selectedNavIndex.value = index;
    if (index == 0 && Get.key.currentState != null) {
      Get.offNamed(AppRoutes.home);
    } else if (index == 1 && Get.key.currentState != null) {
      Get.offNamed(AppRoutes.discover);
    } else if (index == 2 && Get.key.currentState != null) {
      Get.offNamed(AppRoutes.myReferrals);
    } else if (index == 3 && Get.key.currentState != null) {
      Get.offNamed(AppRoutes.communityFeed);
    }
  }

  @override
  void onClose() {
    fullNameCtrl.dispose();
    handleCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    bioCtrl.dispose();
    super.onClose();
  }
}
