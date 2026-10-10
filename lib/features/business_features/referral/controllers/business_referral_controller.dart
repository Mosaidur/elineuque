import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/business_referral_model.dart';

class BusinessReferralController extends ChangeNotifier {
  int _selectedNavIndex = 1; // Referrals tab is index 1
  String _selectedFilter = 'all';
  bool _isLoading = false;

  int get selectedNavIndex => _selectedNavIndex;
  String get selectedFilter => _selectedFilter;
  bool get isLoading => _isLoading;

  List<BusinessReferralModel> referrals = [];

  Future<void> fetchReferrals() async {
    _isLoading = true;
    notifyListeners();

    final response = await ApiClient.get(ApiConstants.myScans, withAuth: true);

    _isLoading = false;

    if (response.success && response.data is List) {
      final list = response.data as List;
      referrals = list.map((item) {
        final c = item as Map<String, dynamic>;
        final id = c['_id']?.toString() ?? c['id']?.toString() ?? '';
        final promoterObj = c['promoterId'] as Map<String, dynamic>?;
        final promoterName = promoterObj?['name']?.toString() ?? 'Promoter';
        final customerName = c['customerIdentifier']?.toString() ?? 'Walk-in Customer';

        String initials = 'P';
        final parts = promoterName.trim().split(' ');
        if (parts.length >= 2) {
          initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
        } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
          initials = parts[0][0].toUpperCase();
        }

        final rawReward = c['rewardAmount']?.toString() ?? '40';
        final rewardVal = int.tryParse(rawReward.replaceAll(RegExp(r'[^0-9]'), '')) ?? 40;

        final statusStr = (c['status']?.toString() ?? 'COMPLETED').toUpperCase();
        BusinessReferralStatus status = BusinessReferralStatus.verified;
        if (statusStr == 'PENDING') {
          status = BusinessReferralStatus.pending;
        } else if (statusStr == 'PAID' || statusStr == 'COMPLETED') {
          status = BusinessReferralStatus.verified;
        } else if (statusStr == 'REJECTED') {
          status = BusinessReferralStatus.rejected;
        }

        String timeAgo = 'Recently';
        final rawCreatedAt = c['createdAt']?.toString();
        if (rawCreatedAt != null) {
          try {
            final dt = DateTime.parse(rawCreatedAt).toLocal();
            final diff = DateTime.now().difference(dt);
            if (diff.inMinutes < 60) {
              timeAgo = '${diff.inMinutes}m ago';
            } else if (diff.inHours < 24) {
              timeAgo = '${diff.inHours}h ago';
            } else {
              timeAgo = '${diff.inDays}d ago';
            }
          } catch (_) {}
        }

        return BusinessReferralModel(
          id: id,
          promoterName: promoterName,
          customerName: customerName,
          timeAgo: timeAgo,
          rewardAmount: rewardVal,
          status: status,
          promoterInitials: initials,
        );
      }).toList();
    }

    notifyListeners();
  }

  // Filtered List
  List<BusinessReferralModel> get filteredReferrals {
    switch (_selectedFilter) {
      case 'pending':
        return referrals.where((r) => r.status == BusinessReferralStatus.pending).toList();
      case 'verified':
        return referrals.where((r) => r.status == BusinessReferralStatus.verified).toList();
      case 'paid':
        return referrals.where((r) => r.status == BusinessReferralStatus.paid).toList();
      case 'all':
      default:
        return referrals.toList();
    }
  }

  int get allCount => referrals.length;
  int get pendingCount => referrals.where((r) => r.status == BusinessReferralStatus.pending).length;
  int get verifiedCount => referrals.where((r) => r.status == BusinessReferralStatus.verified).length;
  int get paidCount => referrals.where((r) => r.status == BusinessReferralStatus.paid).length;

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void verifyReferral(BuildContext context, String id) {
    final index = referrals.indexWhere((r) => r.id == id);
    if (index != -1) {
      final updated = referrals[index].copyWith(status: BusinessReferralStatus.verified);
      referrals[index] = updated;
      notifyListeners();
      _showSnackbar(
        context,
        '${updated.promoterName} → ${updated.customerName} verified successfully.',
      );
    }
  }

  void rejectReferral(BuildContext context, String id) {
    final index = referrals.indexWhere((r) => r.id == id);
    if (index != -1) {
      final updated = referrals[index].copyWith(status: BusinessReferralStatus.rejected);
      referrals[index] = updated;
      notifyListeners();
      _showSnackbar(
        context,
        '${updated.promoterName} → ${updated.customerName} rejected.',
      );
    }
  }

  void markPaid(BuildContext context, String id) {
    final index = referrals.indexWhere((r) => r.id == id);
    if (index != -1) {
      final updated = referrals[index].copyWith(status: BusinessReferralStatus.paid);
      referrals[index] = updated;
      notifyListeners();
      _showSnackbar(
        context,
        '\$${updated.rewardAmount} marked as paid to ${updated.promoterName}.',
      );
    }
  }

  void onNavTap(BuildContext context, int index) {
    if (index == _selectedNavIndex) return;
    _selectedNavIndex = index;
    notifyListeners();

    switch (index) {
      case 0:
        Get.offNamed(AppRoutes.businessDashboard);
        break;
      case 1:
        break;
      case 2:
        Get.toNamed(AppRoutes.businessScan);
        break;
      case 3:
        Get.toNamed(AppRoutes.businessCampaigns);
        break;
      case 4:
        Get.toNamed(AppRoutes.businessProfile);
        break;
      default:
        break;
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF0F9D58),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
