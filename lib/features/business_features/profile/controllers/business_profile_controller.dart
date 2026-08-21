import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../../dashboard/controllers/business_dashboard_controller.dart';
import '../models/business_top_promoter_model.dart';

class BusinessProfileController extends GetxController {
  final selectedNavIndex = 4.obs; // Profile tab is index 4

  // Business Details (Reactive, can sync with Dashboard)
  final businessName = 'FitZone Gym'.obs;
  final category = 'Fitness'.obs;
  final location = 'SF'.obs;
  final rewardPerReferral = '\$40'.obs;
  final activePromotersCount = 128.obs;
  final listingHours = 'Open until 10pm'.obs;

  // KPI Metrics
  final totalReferrals = 128.obs;
  final totalConverted = 94.obs;
  final totalRevenue = '\$12.4K'.obs;

  // Campaign QR details
  final qrReferralLink = 'eliv.app/b/fitzone-gym';

  // Active Promoters List
  final activePromoters = <BusinessTopPromoterModel>[
    const BusinessTopPromoterModel(
      rank: 1,
      name: 'Devon Rivera',
      handle: '@devon_sfams',
      referralsCount: 34,
      totalEarnings: 700,
      conversionsCount: 28,
      initials: 'DR',
      avatarEmoji: '👨',
    ),
    const BusinessTopPromoterModel(
      rank: 2,
      name: 'Mia Torres',
      handle: '@mia_promo',
      referralsCount: 22,
      totalEarnings: 475,
      conversionsCount: 19,
      initials: 'MT',
      avatarEmoji: '👩',
    ),
    const BusinessTopPromoterModel(
      rank: 3,
      name: 'Kwame Asante',
      handle: '@kwame_ref',
      referralsCount: 18,
      totalEarnings: 350,
      conversionsCount: 14,
      initials: 'KA',
      avatarEmoji: '🧔',
    ),
    const BusinessTopPromoterModel(
      rank: 4,
      name: 'Sakura Ito',
      handle: '@sakura_links',
      referralsCount: 12,
      totalEarnings: 200,
      conversionsCount: 8,
      initials: 'SI',
      avatarEmoji: '👩‍🦰',
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Sync with BusinessDashboardController if available
    if (Get.isRegistered<BusinessDashboardController>()) {
      final dashboard = Get.find<BusinessDashboardController>();
      businessName.value = dashboard.businessName.value;
      category.value = dashboard.listingCategory.value;
      listingHours.value = dashboard.listingHours.value;
      rewardPerReferral.value = dashboard.rewardPerReferral.value;
      activePromotersCount.value = dashboard.activePromotersCount.value;
    }
  }

  void onEditListing() {
    if (Get.key.currentState != null) {
      Get.toNamed(AppRoutes.editListing);
    }
  }

  void copyQrLink() {
    Clipboard.setData(ClipboardData(text: 'https://$qrReferralLink'));
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Link Copied',
        '$qrReferralLink copied to clipboard.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void downloadQr() {
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Download QR',
        'Campaign QR code saved to gallery.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onNotificationPreferences() {
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Notification Preferences',
        'Email and push alerts are currently enabled.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onPaymentAndPayouts() {
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Payment & Payouts',
        'Connected Stripe Account: **** 4821 (Active)',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onHelpAndSupport() {
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Help & Support',
        'Support team is available 24/7 at support@elivapp.com',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void signOut() {
    if (Get.key.currentState != null) {
      Get.offAllNamed(AppRoutes.roleSelection);
    }
  }

  void onNavTap(int index) {
    if (index == selectedNavIndex.value) return;
    selectedNavIndex.value = index;

    switch (index) {
      case 0:
        if (Get.key.currentState != null) {
          Get.offNamed(AppRoutes.businessDashboard);
        }
        break;
      case 1:
        if (Get.key.currentState != null) {
          Get.toNamed(AppRoutes.businessReferrals);
        }
        break;
      case 2:
        if (Get.key.currentState != null) {
          Get.toNamed(AppRoutes.businessScan);
        }
        break;
      case 3:
        if (Get.key.currentState != null) {
          Get.toNamed(AppRoutes.businessCampaigns);
        }
        break;
      case 4:
        // Already on Profile
        break;
      default:
        break;
    }
  }
}
