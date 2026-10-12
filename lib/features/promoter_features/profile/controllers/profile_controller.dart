import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/routes/routes.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../models/leaderboard_user_model.dart';
import '../models/profile_badge_model.dart';
import '../views/widgets/withdrawal_modal.dart';

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
  final profilePictureUrl = ''.obs;
  final localImagePath = ''.obs;
  final isUploadingPhoto = false.obs;
  final rawAvailableBalance = 0.0.obs;

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

        final pic = d['profilePicture']?.toString() ?? d['avatar']?.toString() ?? '';
        if (pic.isNotEmpty) {
          profilePictureUrl.value = pic;
        }

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
          rawAvailableBalance.value = released;
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

  Future<void> onChangePhoto() async {
    final ctx = Get.context;
    if (ctx == null) return;

    final source = await showModalBottomSheet<ImageSource>(
      context: ctx,
      backgroundColor: const Color(0xFF061B2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Update Profile Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_camera_rounded, color: Color(0xFF7E9EFF)),
                title: const Text('Take a Photo', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(bCtx, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded, color: Color(0xFFC7F556)),
                title: const Text('Choose from Gallery', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(bCtx, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      localImagePath.value = pickedFile.path;
      isUploadingPhoto.value = true;

      final res = await ApiClient.patchMultipart(
        ApiConstants.userProfile,
        fileField: 'profilePicture',
        filePath: pickedFile.path,
        withAuth: true,
      );

      isUploadingPhoto.value = false;

      if (res.success) {
        if (res.data is Map && res.data['profilePicture'] != null) {
          profilePictureUrl.value = res.data['profilePicture'].toString();
        }
        if (Get.context != null && Get.key.currentState?.overlay != null) {
          Get.snackbar(
            'Photo Updated',
            'Your profile avatar has been saved successfully.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF163E24),
            colorText: const Color(0xFF52E385),
          );
        }
      } else {
        if (Get.context != null && Get.key.currentState?.overlay != null) {
          Get.snackbar(
            'Upload Notice',
            res.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF3B151E),
            colorText: const Color(0xFFFF8B9C),
          );
        }
      }
    } catch (e) {
      isUploadingPhoto.value = false;
      debugPrint('Error picking or uploading profile photo: $e');
    }
  }

  void onWithdraw() {
    final ctx = Get.context;
    if (ctx != null) {
      WithdrawalModal.show(
        context: ctx,
        availableBalance: rawAvailableBalance.value,
        onSuccess: () {
          fetchProfileData();
        },
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
