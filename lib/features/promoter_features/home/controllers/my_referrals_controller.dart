import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../models/referral_activity_model.dart';

class MyReferralsController extends GetxController {
  // Navigation
  final selectedNavIndex = 2.obs; // Track tab is index 2

  // Summary Metrics
  final sharedCount = '92'.obs;
  final pendingCount = '14'.obs;
  final convertedCount = '78'.obs;

  final totalEarned = '\$1,840'.obs;
  final thisMonthEarned = '+\$420'.obs;

  // Recent Activity Items matching the design
  final activities = <ReferralActivityItem>[
    const ReferralActivityItem(
      businessName: 'FitZone Gym',
      friendName: 'Sarah K.',
      timeAgo: '2h ago',
      amount: '\$40',
      status: ActivityStatus.paid,
      currentStep: 4,
      icon: Icons.fitness_center_outlined,
      iconColor: Color(0xFF42A5F5),
    ),
    const ReferralActivityItem(
      businessName: 'Kava Brew',
      friendName: 'Marcus J.',
      timeAgo: '5h ago',
      amount: '\$25',
      status: ActivityStatus.verified,
      currentStep: 3,
      icon: Icons.coffee_outlined,
      iconColor: Color(0xFFFFA726),
    ),
    const ReferralActivityItem(
      businessName: 'Luna Spa',
      friendName: 'Tom W.',
      timeAgo: '1d ago',
      amount: '\$30',
      status: ActivityStatus.pending,
      currentStep: 2,
      icon: Icons.spa_outlined,
      iconColor: Color(0xFFAB47BC),
    ),
    const ReferralActivityItem(
      businessName: 'TacoFusion',
      friendName: 'Jen P.',
      timeAgo: '2d ago',
      amount: '\$20',
      status: ActivityStatus.shared,
      currentStep: 1,
      canShareAgain: true,
      icon: Icons.restaurant_outlined,
      iconColor: Color(0xFFFF7043),
    ),
    const ReferralActivityItem(
      businessName: 'CloudCuts',
      friendName: 'Amy L.',
      timeAgo: '3d ago',
      amount: '\$15',
      status: ActivityStatus.paid,
      currentStep: 4,
      icon: Icons.content_cut_outlined,
      iconColor: Color(0xFF26A69A),
    ),
  ].obs;

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
        'Withdrawal',
        'Available balance: \$1,840.00 will be transferred to your account.',
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
