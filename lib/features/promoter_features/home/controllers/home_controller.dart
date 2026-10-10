import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/recent_referral_model.dart';
import '../models/spotlight_deal_model.dart';

class HomeController extends GetxController {
  final userName = 'Promoter'.obs;
  final greeting = 'Good morning 👋'.obs;
  final hasUnreadNotifications = false.obs;
  final isLoading = false.obs;

  // Earnings stats
  final totalEarnings = '\$0.00'.obs;
  final thisMonthEarnings = '+\$0'.obs;
  final totalReferrals = '0'.obs;
  final convertedCount = '0'.obs;

  // Spotlight active index
  final activeSpotlightIndex = 0.obs;
  final selectedNavIndex = 0.obs;

  // Featured spotlight deals
  final featuredDeals = <SpotlightDeal>[].obs;

  // Mini business cards
  final miniBusinesses = <SpotlightDeal>[].obs;

  // Recent referrals
  final recentReferrals = <RecentReferral>[].obs;

  @override
  void onInit() {
    super.onInit();
    _updateGreeting();
    if (!Get.testMode) {
      fetchHomeData();
    }
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting.value = 'Good morning 👋';
    } else if (hour < 17) {
      greeting.value = 'Good afternoon 👋';
    } else {
      greeting.value = 'Good evening 👋';
    }
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;
    try {
      // 1. Fetch Profile for Name
      final profileRes = await ApiClient.get(ApiConstants.userProfile, withAuth: true);
      if (profileRes.success && profileRes.data is Map) {
        final data = profileRes.data as Map<String, dynamic>;
        userName.value = data['name']?.toString() ?? 'Promoter';
      }

      // 2. Fetch Reward Stats
      final rewardsRes = await ApiClient.get(ApiConstants.myRewards, withAuth: true);
      if (rewardsRes.success && rewardsRes.data is Map) {
        final data = rewardsRes.data as Map<String, dynamic>;
        final summary = data['summary'] as Map<String, dynamic>?;
        if (summary != null) {
          final total = (summary['totalEarned'] as num?)?.toDouble() ?? 0.0;
          final released = (summary['releasedRewards'] as num?)?.toDouble() ?? 0.0;
          totalEarnings.value = '\$${total.toStringAsFixed(2)}';
          thisMonthEarnings.value = '+\$${released.toStringAsFixed(0)}';
        }
      }

      // 3. Fetch Referrals
      final referralsRes = await ApiClient.get(ApiConstants.myReferrals, withAuth: true);
      if (referralsRes.success) {
        final rawData = referralsRes.data;
        final list = (rawData is List
                ? rawData
                : (rawData is Map ? (rawData['data'] as List?) : null)) ??
            [];
        totalReferrals.value = '${list.length}';

        int converted = 0;
        final List<RecentReferral> items = [];
        for (final item in list) {
          if (item is Map<String, dynamic>) {
            final statusStr = item['status']?.toString() ?? '';
            final isPaid = statusStr == 'COMPLETED' || statusStr == 'RELEASED';
            if (isPaid) converted++;

            final custName = item['customerIdentifier']?.toString() ?? 'Customer';
            final initials = custName.isNotEmpty ? custName[0].toUpperCase() : 'C';
            final businessObj = item['businessId'];
            final business = businessObj is Map
                ? (businessObj['businessName'] ?? businessObj['name'] ?? 'Business')
                : 'Business';
            final reward = item['promoterReward'] != null
                ? '\$${item['promoterReward']}'
                : '\$0';

            items.add(RecentReferral(
              name: custName,
              initials: initials,
              avatarColor: const Color(0xFF4A68FF),
              businessName: business.toString(),
              timeAgo: 'Recent',
              amount: reward,
              status: isPaid ? ReferralStatus.paid : ReferralStatus.pending,
            ));
          }
        }
        convertedCount.value = '$converted';
        recentReferrals.assignAll(items);
      }

      // 4. Fetch Active Campaigns from real businesses
      final campaignsRes = await ApiClient.get(ApiConstants.campaigns, withAuth: true);
      if (campaignsRes.success && campaignsRes.data is List) {
        final list = campaignsRes.data as List;
        final deals = list.map((item) {
          final c = item as Map<String, dynamic>;
          final id = c['_id']?.toString() ?? c['id']?.toString() ?? '';
          final title = c['title']?.toString() ?? 'Special Deal';
          final offer = c['offer']?.toString() ?? 'Exclusive Referral Offer';
          final reward = c['reward']?.toString() ?? '\$20';
          final count = c['sharedCount']?.toString() ?? '0';

          return SpotlightDeal(
            id: id,
            title: title,
            description: offer,
            category: 'Offers',
            rewardAmount: reward,
            rewardDescription: 'Earn $reward on verified customer checkout',
            promotersActive: '$count promoters active',
            isHot: true,
          );
        }).toList();

        if (deals.isNotEmpty) {
          featuredDeals.assignAll(deals);
          miniBusinesses.assignAll(deals.take(3).toList());
        }
      }
    } catch (e) {
      debugPrint('Error fetching promoter home data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onNotificationTap() {
    hasUnreadNotifications.value = false;
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Notifications',
        'All caught up! No unread notifications.',
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

  Future<void> onGetLink(SpotlightDeal deal) async {
    if (deal.id.isEmpty) {
      Clipboard.setData(ClipboardData(text: 'https://eliv.app/r/${deal.title.toLowerCase().replaceAll(' ', '')}'));
      if (Get.context != null && Get.key.currentState?.overlay != null) {
        Get.snackbar(
          'Link Copied!',
          'Referral link for ${deal.title} copied to clipboard.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return;
    }

    // Call join campaign API to obtain real promoter referral code
    final res = await ApiClient.post(ApiConstants.joinCampaign(deal.id), withAuth: true);
    String code = deal.id.substring(0, deal.id.length > 6 ? 6 : deal.id.length).toUpperCase();
    if (res.success && res.data is Map && (res.data as Map)['referralCode'] != null) {
      code = (res.data as Map)['referralCode'].toString();
    }

    final link = 'https://eliv.app/r/$code';
    Clipboard.setData(ClipboardData(text: link));

    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Referral Code Generated! ($code)',
        '$link copied to clipboard. Share with friends to earn ${deal.rewardAmount}!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1B4968),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
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
