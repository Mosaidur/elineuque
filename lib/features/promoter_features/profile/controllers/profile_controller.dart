import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../models/leaderboard_user_model.dart';
import '../models/profile_badge_model.dart';

class ProfileController extends GetxController {
  final selectedNavIndex = 4.obs; // Profile tab is index 4
  final isLoading = false.obs;

  // Edit Mode toggle
  final isEditing = false.obs;

  // Profile Data
  final fullName = 'Promoter'.obs;
  final handle = '@promoter'.obs;
  final rankText = 'Rank #1'.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final bio = ''.obs;

  // Stats
  final earnedAmount = '\$0'.obs;
  final totalReferrals = 0.obs;
  final convertedCount = 0.obs;
  final availableWallet = '\$0.00'.obs;
  final badgesEarnedText = '1 / 6 earned'.obs;

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
      isEarned: false,
    ),
    const ProfileBadgeModel(
      id: 'b3',
      title: '10 Conversions',
      icon: Icons.gps_fixed_rounded,
      iconColor: Color(0xFFFF5252),
      isEarned: false,
    ),
    const ProfileBadgeModel(
      id: 'b4',
      title: 'Community Star',
      icon: Icons.star_rounded,
      iconColor: Color(0xFFFFD54F),
      isEarned: false,
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
  final leaderboard = <LeaderboardUserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fullNameCtrl = TextEditingController(text: fullName.value);
    handleCtrl = TextEditingController(text: handle.value);
    emailCtrl = TextEditingController(text: email.value);
    phoneCtrl = TextEditingController(text: phone.value);
    bioCtrl = TextEditingController(text: bio.value);

    if (!Get.testMode) {
      fetchProfileData();
    }
  }

  Future<void> fetchProfileData() async {
    isLoading.value = true;
    try {
      // 1. Fetch User Profile
      final profileRes = await ApiClient.get(ApiConstants.userProfile, withAuth: true);
      if (profileRes.success && profileRes.data is Map) {
        final d = profileRes.data as Map<String, dynamic>;
        fullName.value = d['name']?.toString() ?? 'Promoter';
        email.value = d['email']?.toString() ?? '';
        phone.value = d['phone']?.toString() ?? '';
        bio.value = d['bio']?.toString() ?? '';
        final h = d['handle']?.toString();
        handle.value = (h != null && h.isNotEmpty)
            ? (h.startsWith('@') ? h : '@$h')
            : '@${fullName.value.toLowerCase().replaceAll(' ', '_')}';

        fullNameCtrl.text = fullName.value;
        emailCtrl.text = email.value;
        phoneCtrl.text = phone.value;
        bioCtrl.text = bio.value;
        handleCtrl.text = handle.value;
      }

      // 2. Fetch Rewards Summary
      final rewardsRes = await ApiClient.get(ApiConstants.myRewards, withAuth: true);
      if (rewardsRes.success && rewardsRes.data is Map) {
        final d = rewardsRes.data as Map<String, dynamic>;
        final summary = d['summary'] as Map<String, dynamic>?;
        if (summary != null) {
          final total = (summary['totalEarned'] as num?)?.toDouble() ?? 0.0;
          final released = (summary['releasedRewards'] as num?)?.toDouble() ?? 0.0;
          earnedAmount.value = '\$${total.toStringAsFixed(0)}';
          availableWallet.value = '\$${released.toStringAsFixed(2)}';
        }
      }

      // 3. Fetch Referrals Count
      final referralsRes = await ApiClient.get(ApiConstants.myReferrals, withAuth: true);
      if (referralsRes.success) {
        final rawData = referralsRes.data;
        final list = (rawData is List
                ? rawData
                : (rawData is Map ? (rawData['data'] as List?) : null)) ??
            [];
        totalReferrals.value = list.length;
        int converted = 0;
        for (final item in list) {
          if (item is Map) {
            final st = item['status']?.toString();
            if (st == 'COMPLETED' || st == 'RELEASED' || st == 'VERIFIED') converted++;
          }
        }
        convertedCount.value = converted;
      }

      // 4. Fetch Leaderboard
      final leaderRes = await ApiClient.get(ApiConstants.leaderboard, withAuth: true);
      if (leaderRes.success && leaderRes.data is Map) {
        final d = leaderRes.data as Map<String, dynamic>;
        final cur = d['currentUser'] as Map<String, dynamic>?;
        if (cur != null && cur['rank'] != null) {
          rankText.value = cur['rank'].toString();
        }

        final list = d['leaderboard'] as List?;
        if (list != null && list.isNotEmpty) {
          final mapped = list.asMap().entries.map((entry) {
            final u = entry.value as Map<String, dynamic>;
            final rank = (u['rank'] as num?)?.toInt() ?? (entry.key + 1);
            final name = u['name']?.toString() ?? 'Promoter';
            final initials = name.isNotEmpty ? name[0].toUpperCase() : 'P';
            final earnings = u['earnings'] != null ? '\$${u['earnings']}' : '\$0';
            final count = (u['referralsCount'] as num?)?.toInt() ?? 0;

            return LeaderboardUserModel(
              rank: rank,
              name: name,
              initials: initials,
              avatarColor: const Color(0xFF5365F5),
              referralsCount: count,
              earnings: earnings,
            );
          }).toList();
          leaderboard.assignAll(mapped);
        }
      }
    } catch (e) {
      debugPrint('Error fetching promoter profile: $e');
    } finally {
      isLoading.value = false;
    }
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

  Future<void> saveProfile() async {
    final newName = fullNameCtrl.text.trim();
    final newPhone = phoneCtrl.text.trim();
    final newBio = bioCtrl.text.trim();
    final newHandle = handleCtrl.text.trim().replaceAll('@', '');

    final res = await ApiClient.patch(
      ApiConstants.userProfile,
      body: {
        if (newName.isNotEmpty) 'name': newName,
        if (newPhone.isNotEmpty) 'phone': newPhone,
        if (newBio.isNotEmpty) 'bio': newBio,
        if (newHandle.isNotEmpty) 'handle': newHandle,
      },
      withAuth: true,
    );

    if (newName.isNotEmpty) fullName.value = newName;
    if (newPhone.isNotEmpty) phone.value = newPhone;
    bio.value = newBio;
    if (newHandle.isNotEmpty) handle.value = '@$newHandle';

    isEditing.value = false;

    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        res.success ? 'Profile Updated' : 'Notice',
        res.success
            ? 'Your profile details have been saved to the server.'
            : res.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onChangePhoto() {
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Change Photo',
        'Profile avatar update will be available in future release.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onWithdraw() {
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Withdraw Balance',
        '${availableWallet.value} is being processed to your payout account.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onSelectPeriod(String period) {
    selectedPeriod.value = period;
  }

  Future<void> onSignOut() async {
    await StorageService.clearAuth();
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
