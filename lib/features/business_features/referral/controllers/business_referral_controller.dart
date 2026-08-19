import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../models/business_referral_model.dart';

class BusinessReferralController extends GetxController {
  final selectedNavIndex = 1.obs; // Referrals tab is index 1

  // Filter: 'all', 'pending', 'verified', 'paid'
  final selectedFilter = 'all'.obs;

  final referrals = <BusinessReferralModel>[
    const BusinessReferralModel(
      id: 'ref-1',
      promoterName: 'Devon R.',
      customerName: 'Sarah K.',
      timeAgo: '1h ago',
      rewardAmount: 40,
      status: BusinessReferralStatus.verified,
      promoterInitials: 'DR',
      avatarEmoji: '👩',
    ),
    const BusinessReferralModel(
      id: 'ref-2',
      promoterName: 'Alicia M.',
      customerName: 'Tom M.',
      timeAgo: '3h ago',
      rewardAmount: 40,
      status: BusinessReferralStatus.pending,
      promoterInitials: 'AM',
      avatarEmoji: '🧔',
    ),
    const BusinessReferralModel(
      id: 'ref-3',
      promoterName: 'Jordan T.',
      customerName: 'Jen P.',
      timeAgo: '5h ago',
      rewardAmount: 40,
      status: BusinessReferralStatus.verified,
      promoterInitials: 'JT',
      avatarEmoji: '👱‍♀️',
    ),
    const BusinessReferralModel(
      id: 'ref-4',
      promoterName: 'Devon R.',
      customerName: 'Carlos S.',
      timeAgo: '1d ago',
      rewardAmount: 40,
      status: BusinessReferralStatus.paid,
      promoterInitials: 'DR',
      avatarEmoji: '👱',
    ),
    const BusinessReferralModel(
      id: 'ref-5',
      promoterName: 'Simone V.',
      customerName: 'Amy L.',
      timeAgo: '2d ago',
      rewardAmount: 40,
      status: BusinessReferralStatus.rejected,
      promoterInitials: 'SV',
      avatarEmoji: '👨',
    ),
  ].obs;

  // Filtered List
  List<BusinessReferralModel> get filteredReferrals {
    switch (selectedFilter.value) {
      case 'pending':
        return referrals
            .where((r) => r.status == BusinessReferralStatus.pending)
            .toList();
      case 'verified':
        return referrals
            .where((r) => r.status == BusinessReferralStatus.verified)
            .toList();
      case 'paid':
        return referrals
            .where((r) => r.status == BusinessReferralStatus.paid)
            .toList();
      case 'all':
      default:
        return referrals.toList();
    }
  }

  int get allCount => referrals.length;

  int get pendingCount =>
      referrals.where((r) => r.status == BusinessReferralStatus.pending).length;

  int get verifiedCount => referrals
      .where((r) => r.status == BusinessReferralStatus.verified)
      .length;

  int get paidCount =>
      referrals.where((r) => r.status == BusinessReferralStatus.paid).length;

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void verifyReferral(String id) {
    final index = referrals.indexWhere((r) => r.id == id);
    if (index != -1) {
      final updated =
          referrals[index].copyWith(status: BusinessReferralStatus.verified);
      referrals[index] = updated;

      if (Get.context != null && Get.key.currentState?.overlay != null) {
        Get.snackbar(
          'Referral Verified',
          '${updated.promoterName} → ${updated.customerName} verified successfully.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void rejectReferral(String id) {
    final index = referrals.indexWhere((r) => r.id == id);
    if (index != -1) {
      final updated =
          referrals[index].copyWith(status: BusinessReferralStatus.rejected);
      referrals[index] = updated;

      if (Get.context != null && Get.key.currentState?.overlay != null) {
        Get.snackbar(
          'Referral Rejected',
          '${updated.promoterName} → ${updated.customerName} rejected.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void markPaid(String id) {
    final index = referrals.indexWhere((r) => r.id == id);
    if (index != -1) {
      final updated =
          referrals[index].copyWith(status: BusinessReferralStatus.paid);
      referrals[index] = updated;

      if (Get.context != null && Get.key.currentState?.overlay != null) {
        Get.snackbar(
          'Reward Paid',
          '\$${updated.rewardAmount} marked as paid to ${updated.promoterName}.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
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
        // Already on Referrals
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
        if (Get.key.currentState != null) {
          Get.toNamed(AppRoutes.businessProfile);
        }
        break;
      default:
        break;
    }
  }
}
