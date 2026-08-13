import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../models/recent_referral_model.dart';
import '../models/spotlight_deal_model.dart';

class HomeController extends GetxController {
  final userName = 'Devon Rivera'.obs;
  final greeting = 'Good morning 👋'.obs;
  final hasUnreadNotifications = true.obs;

  // Earnings stats
  final totalEarnings = '\$1,840.00'.obs;
  final thisMonthEarnings = '+\$420'.obs;
  final totalReferrals = '92'.obs;
  final convertedCount = '78'.obs;

  // Spotlight active index
  final activeSpotlightIndex = 0.obs;
  final selectedNavIndex = 0.obs;

  // Featured spotlight deals
  final featuredDeals = <SpotlightDeal>[
    const SpotlightDeal(
      title: 'Kava Brew',
      description: 'Earn on every oat latte referral',
      category: 'Café',
      rewardAmount: '\$25',
      rewardDescription: 'When they buy any item, you earn \$25',
      promotersActive: '47 promoters active',
      isHot: true,
    ),
    const SpotlightDeal(
      title: 'FitZone Gym',
      description: 'Earn on every annual gym membership',
      category: 'Fitness',
      rewardAmount: '\$40',
      rewardDescription: 'When they sign up for membership, you earn \$40',
      promotersActive: '32 promoters active',
      isHot: true,
    ),
    const SpotlightDeal(
      title: 'Luna Spa',
      description: 'Earn on every massage & spa booking',
      category: 'Wellness',
      rewardAmount: '\$30',
      rewardDescription: 'When they book a session, you earn \$30',
      promotersActive: '19 promoters active',
      isHot: false,
    ),
  ].obs;

  // Mini business cards
  final miniBusinesses = <SpotlightDeal>[
    const SpotlightDeal(
      title: 'Kava Brew',
      description: 'Café',
      category: 'Café',
      rewardAmount: '\$25',
      rewardDescription: '\$25 / ref',
      promotersActive: '47',
    ),
    const SpotlightDeal(
      title: 'FitZone Gym',
      description: 'Fitness',
      category: 'Fitness',
      rewardAmount: '\$40',
      rewardDescription: '\$40 / ref',
      promotersActive: '32',
    ),
    const SpotlightDeal(
      title: 'Luna Spa',
      description: 'Wellness',
      category: 'Wellness',
      rewardAmount: '\$30',
      rewardDescription: '\$30 / ref',
      promotersActive: '19',
    ),
  ].obs;

  // Recent referrals
  final recentReferrals = <RecentReferral>[
    const RecentReferral(
      name: 'Marcus J.',
      initials: 'MJ',
      avatarColor: Color(0xFF4A68FF),
      businessName: 'Kava Brew',
      timeAgo: '2h ago',
      amount: '\$25',
      status: ReferralStatus.paid,
    ),
    const RecentReferral(
      name: 'Priya K.',
      initials: 'PK',
      avatarColor: Color(0xFFFFA000),
      businessName: 'FitZone Gym',
      timeAgo: '5h ago',
      amount: 'Pending',
      status: ReferralStatus.pending,
    ),
    const RecentReferral(
      name: 'Devon R.',
      initials: 'DR',
      avatarColor: Color(0xFF7E57C2),
      businessName: 'Luna Spa',
      timeAgo: '1d ago',
      amount: '\$30',
      status: ReferralStatus.paid,
    ),
  ].obs;

  void onNotificationTap() {
    hasUnreadNotifications.value = false;
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Notifications',
        'You have 2 new referral rewards pending review.',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void onBrowseDeals() {
    if (Get.key.currentState != null) {
      Get.toNamed(AppRoutes.discover);
    }
  }

  void onMyEarnings() {
    if (Get.key.currentState != null) {
      Get.toNamed(AppRoutes.myReferrals);
    }
  }

  void onWithdraw() {
    if (Get.key.currentState != null) {
      Get.toNamed(AppRoutes.myReferrals);
    }
  }

  void onGetLink(SpotlightDeal deal) {
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Link Generated!',
        'Referral link for ${deal.title} copied to clipboard.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onNavTap(int index) {
    selectedNavIndex.value = index;
    if (index == 1 && Get.key.currentState != null) {
      Get.toNamed(AppRoutes.discover);
    } else if (index == 2 && Get.key.currentState != null) {
      Get.toNamed(AppRoutes.myReferrals);
    } else if (index == 3 && Get.key.currentState != null) {
      Get.toNamed(AppRoutes.communityFeed);
    } else if (index == 4 && Get.key.currentState != null) {
      Get.toNamed(AppRoutes.profile);
    }
  }
}
