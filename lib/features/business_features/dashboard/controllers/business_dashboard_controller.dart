import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../models/business_recent_activity_model.dart';
import '../models/weekly_referral_model.dart';

class BusinessDashboardController extends GetxController {
  final selectedNavIndex = 0.obs;

  final businessName = 'FitZone Gym'.obs;
  final unreadNotificationsCount = 2.obs;

  // Key KPI Summary Metrics
  final totalReferrals = 128.obs;
  final referralsSubtitle = '+22 this week';

  final conversionsCount = 94.obs;
  final conversionsSubtitle = '73% rate';

  final revenueDrivenK = 12.4.obs; // $12.4K
  final revenueSubtitle = 'This month';

  final rewardsPaidAmount = 3760.obs; // $3,760
  final rewardsPaidSubtitle = '94 payouts';

  // Animation trigger boolean
  final animateCounters = false.obs;

  // Weekly Referrals chart data
  final weeklyGrowth = '+31% ↑'.obs;
  final weeklyData = <WeeklyReferralModel>[
    const WeeklyReferralModel(day: 'Tue', count: 18),
    const WeeklyReferralModel(day: 'Wed', count: 32),
    const WeeklyReferralModel(day: 'Thu', count: 24),
    const WeeklyReferralModel(day: 'Fri', count: 50),
    const WeeklyReferralModel(day: 'Sat', count: 36),
    const WeeklyReferralModel(day: 'Sun', count: 68),
    const WeeklyReferralModel(day: 'Mon', count: 58),
  ].obs;

  // Public Listing data (Reactive)
  final listingName = 'FitZone Gym'.obs;
  final listingCategory = 'Fitness'.obs;
  final listingRating = '4.9★'.obs;
  final listingHours = 'Open until 10pm'.obs;
  final listingDescription =
      "San Francisco's premium functional fitness gym. State-of-the-art equipment, expert coaches, and a community that shows".obs;
  final rewardPerReferral = '\$40'.obs;
  final activePromotersCount = 128.obs;

  // Recent Activity List
  final recentActivities = <BusinessRecentActivityModel>[
    const BusinessRecentActivityModel(
      id: 'a1',
      customerName: 'Sarah K.',
      actionDetail: 'visited via Devon R. - 1h ago',
      timeAgo: '1h ago',
      status: BusinessActivityStatus.verified,
      avatarEmoji: '👩',
    ),
    const BusinessRecentActivityModel(
      id: 'a2',
      customerName: 'Tom M.',
      actionDetail: 'referred by Alicia M. - 3h ago',
      timeAgo: '3h ago',
      status: BusinessActivityStatus.pending,
      avatarEmoji: '🧔',
    ),
    const BusinessRecentActivityModel(
      id: 'a3',
      customerName: 'Jen P.',
      actionDetail: 'visited via Jordan T. - 5h ago',
      timeAgo: '5h ago',
      status: BusinessActivityStatus.paid,
      avatarEmoji: '👩‍🦰',
    ),
  ].obs;

  @override
  void onReady() {
    super.onReady();
    // Trigger animation smoothly on page load
    Future.delayed(const Duration(milliseconds: 100), () {
      animateCounters.value = true;
    });
  }

  void onScanAndVerify() {
    if (Get.key.currentState != null) {
      Get.toNamed(AppRoutes.businessScan);
    }
  }

  void onManageReferrals() {
    if (Get.key.currentState != null) {
      Get.toNamed(AppRoutes.businessReferrals);
    }
  }

  void onEditPublicListing() {
    if (Get.key.currentState != null) {
      Get.toNamed(AppRoutes.editListing);
    }
  }

  void updateListing({
    required String name,
    required String category,
    required String hours,
    required String description,
    required String rewardPerReferral,
  }) {
    listingName.value = name;
    businessName.value = name;
    listingCategory.value = category;
    listingHours.value = hours;
    listingDescription.value = description;
    this.rewardPerReferral.value = rewardPerReferral;
  }

  void onViewAllActivity() {
    if (Get.key.currentState != null) {
      Get.toNamed(AppRoutes.businessReferrals);
    }
  }

  void onNotifications() {
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Notifications',
        'You have ${unreadNotificationsCount.value} new business alerts.',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void onNavTap(int index) {
    if (index == selectedNavIndex.value) return;
    selectedNavIndex.value = index;
    if (index == 1) {
      if (Get.key.currentState != null) {
        Get.toNamed(AppRoutes.businessReferrals);
      }
    } else if (index == 2) {
      if (Get.key.currentState != null) {
        Get.toNamed(AppRoutes.businessScan);
      }
    } else if (index == 3) {
      if (Get.key.currentState != null) {
        Get.toNamed(AppRoutes.businessCampaigns);
      }
    } else if (index == 4) {
      if (Get.key.currentState != null) {
        Get.toNamed(AppRoutes.businessProfile);
      }
    }
  }
}
