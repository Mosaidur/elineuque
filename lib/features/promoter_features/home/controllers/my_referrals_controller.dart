import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/referral_activity_model.dart';

class MyReferralsController extends GetxController {
  // Navigation
  final selectedNavIndex = 2.obs; // Track tab is index 2
  final isLoading = false.obs;

  // Summary Metrics
  final sharedCount = '0'.obs;
  final pendingCount = '0'.obs;
  final convertedCount = '0'.obs;

  final totalEarned = '\$0'.obs;
  final thisMonthEarned = '+\$0'.obs;

  // Activity Items
  final activities = <ReferralActivityItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (!Get.testMode) {
      fetchReferralActivities();
    }
  }

  Future<void> fetchReferralActivities() async {
    isLoading.value = true;
    try {
      // 1. Fetch rewards summary
      final rewardsRes = await ApiClient.get(ApiConstants.myRewards, withAuth: true);
      if (rewardsRes.success && rewardsRes.data is Map) {
        final data = rewardsRes.data as Map<String, dynamic>;
        final summary = data['summary'] as Map<String, dynamic>?;
        if (summary != null) {
          final total = (summary['totalEarned'] as num?)?.toDouble() ?? 0.0;
          final released = (summary['releasedRewards'] as num?)?.toDouble() ?? 0.0;
          totalEarned.value = '\$${total.toStringAsFixed(0)}';
          thisMonthEarned.value = '+\$${released.toStringAsFixed(0)}';
        }
      }

      // 2. Fetch referrals list
      final referralsRes = await ApiClient.get(ApiConstants.myReferrals, withAuth: true);
      if (referralsRes.success) {
        final rawData = referralsRes.data;
        final list = (rawData is List
                ? rawData
                : (rawData is Map ? (rawData['data'] as List?) : null)) ??
            [];

        sharedCount.value = '${list.length}';
        int conv = 0;
        int pend = 0;

        final List<ReferralActivityItem> items = [];
        for (final item in list) {
          if (item is Map<String, dynamic>) {
            final statusStr = item['status']?.toString() ?? 'PENDING';
            final isPaid = statusStr == 'COMPLETED' || statusStr == 'RELEASED';
            final isVerified = statusStr == 'VERIFIED';

            ActivityStatus actStatus = ActivityStatus.pending;
            int step = 2;
            if (isPaid) {
              actStatus = ActivityStatus.paid;
              step = 4;
              conv++;
            } else if (isVerified) {
              actStatus = ActivityStatus.verified;
              step = 3;
              conv++;
            } else {
              pend++;
            }

            final custName = item['customerIdentifier']?.toString() ?? 'Customer';
            final businessObj = item['businessId'];
            final businessName = businessObj is Map
                ? (businessObj['businessName'] ?? businessObj['name'] ?? 'Store')
                : 'Partner Store';
            final reward = item['promoterReward'] != null
                ? '\$${item['promoterReward']}'
                : '\$0';

            items.add(ReferralActivityItem(
              businessName: businessName.toString(),
              friendName: custName,
              timeAgo: 'Recent',
              amount: reward,
              status: actStatus,
              currentStep: step,
              icon: Icons.storefront_outlined,
              iconColor: const Color(0xFFC8FF5A),
            ));
          }
        }

        convertedCount.value = '$conv';
        pendingCount.value = '$pend';
        activities.assignAll(items);
      }
    } catch (e) {
      debugPrint('Error fetching referral activities: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onNavTap(int index) {
    if (index == selectedNavIndex.value) return;

    selectedNavIndex.value = index;
    if (index == 0 && Get.key.currentState != null) {
      Get.offNamed(AppRoutes.home);
    } else if (index == 1 && Get.key.currentState != null) {
      Get.offNamed(AppRoutes.discover);
    } else if (index == 3 && Get.key.currentState != null) {
      Get.offNamed(AppRoutes.communityFeed);
    } else if (index == 4 && Get.key.currentState != null) {
      Get.offNamed(AppRoutes.profile);
    }
  }

  void onWithdraw() {
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Withdrawal Request',
        'Available balance: ${totalEarned.value} will be processed to your payout account.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onShareLinkAgain(ReferralActivityItem item) {
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Link Copied!',
        'Referral link for ${item.businessName} has been copied to your clipboard.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onFindMoreBusinesses() {
    if (Get.key.currentState != null) {
      Get.toNamed(AppRoutes.discover);
    }
  }
}
