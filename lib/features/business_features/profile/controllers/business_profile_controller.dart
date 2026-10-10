import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../../dashboard/controllers/business_dashboard_controller.dart';
import '../models/business_top_promoter_model.dart';

class BusinessProfileController extends ChangeNotifier {
  int _selectedNavIndex = 4; // Profile tab is index 4
  bool _isLoading = false;

  int get selectedNavIndex => _selectedNavIndex;
  bool get isLoading => _isLoading;

  // Business Details
  String businessName = '';
  String category = 'Business';
  String location = '';
  String rewardPerReferral = '\$0';
  int activePromotersCount = 0;
  String listingHours = 'Open until 10pm';

  // KPI Metrics
  int totalReferrals = 0;
  int totalConverted = 0;
  String totalRevenue = '\$0.0K';

  // Campaign QR details
  String qrReferralLink = 'eliv.app/b';

  // Active Promoters List
  List<BusinessTopPromoterModel> activePromoters = const [];

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> fetchProfile(BusinessDashboardController? dashboard) async {
    // If dashboard data is available, populate immediately
    if (dashboard != null) {
      businessName = dashboard.businessName;
      category = dashboard.listingCategory;
      listingHours = dashboard.listingHours;
      rewardPerReferral = dashboard.rewardPerReferral;
      activePromotersCount = dashboard.activePromotersCount;
      totalReferrals = dashboard.totalReferrals;
      totalConverted = dashboard.conversionsCount;
      totalRevenue = dashboard.revenueDriven;
      qrReferralLink = 'eliv.app/b/${businessName.toLowerCase().replaceAll(' ', '-')}';
      if (!_isDisposed) notifyListeners();
    }

    _isLoading = true;
    if (!_isDisposed) notifyListeners();

    final response = await ApiClient.get(ApiConstants.userProfile, withAuth: true);

    if (_isDisposed) return;
    _isLoading = false;

    if (response.success && response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      final bName = data['businessName']?.toString() ?? data['name']?.toString();
      if (bName != null && bName.isNotEmpty) {
        businessName = bName;
        qrReferralLink = 'eliv.app/b/${bName.toLowerCase().replaceAll(' ', '-')}';
      }

      final cat = data['category']?.toString();
      if (cat != null && cat.isNotEmpty) {
        category = cat;
      }

      final addr = data['address']?.toString();
      if (addr != null && addr.isNotEmpty) {
        location = addr;
      }

      final hrs = data['hours']?.toString();
      if (hrs != null && hrs.isNotEmpty) {
        listingHours = hrs;
      }
    }

    if (!_isDisposed) notifyListeners();
  }

  void onEditListing() {
    Get.toNamed(AppRoutes.editListing);
  }

  void copyQrLink(BuildContext context) {
    Clipboard.setData(ClipboardData(text: 'https://$qrReferralLink'));
    _showSnackbar(context, '$qrReferralLink copied to clipboard.');
  }

  void downloadQr(BuildContext context) {
    _showSnackbar(context, 'Campaign QR code saved to gallery.');
  }

  void onNotificationPreferences(BuildContext context) {
    _showSnackbar(context, 'Email and push alerts are currently enabled.');
  }

  void onPaymentAndPayouts(BuildContext context) {
    _showSnackbar(context, 'Connected Payment Account: Active');
  }

  void onHelpAndSupport(BuildContext context) {
    _showSnackbar(context, 'Support team is available 24/7 at support@elivapp.com');
  }

  Future<void> signOut() async {
    await StorageService.clear();
    Get.offAllNamed(AppRoutes.roleSelection);
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
        Get.toNamed(AppRoutes.businessReferrals);
        break;
      case 2:
        Get.toNamed(AppRoutes.businessScan);
        break;
      case 3:
        Get.toNamed(AppRoutes.businessCampaigns);
        break;
      case 4:
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
