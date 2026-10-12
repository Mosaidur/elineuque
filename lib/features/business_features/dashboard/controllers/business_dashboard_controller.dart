import 'package:flutter/material.dart';
import '../../../../app/routes/routes.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/business_recent_activity_model.dart';
import '../models/weekly_referral_model.dart';

class BusinessDashboardController extends ChangeNotifier {
  int _selectedNavIndex = 0;
  bool _isLoading = false;
  bool _animateCounters = false;

  int get selectedNavIndex => _selectedNavIndex;
  bool get isLoading => _isLoading;
  bool get animateCounters => _animateCounters;

  String businessName = 'My Business';
  int unreadNotificationsCount = 0;

  // Key KPI Summary Metrics
  int totalReferrals = 0;
  String referralsSubtitle = 'This week';

  int conversionsCount = 0;
  String conversionsSubtitle = '0% rate';

  double revenueDrivenK = 0.0;
  String revenueSubtitle = 'This month';
  String get revenueDriven => '\$${revenueDrivenK.toStringAsFixed(1)}K';

  void updateListing({
    required String name,
    required String category,
    required String hours,
    required String description,
    required String rewardPerReferral,
  }) {
    businessName = name;
    listingName = name;
    listingCategory = category;
    listingHours = hours;
    listingDescription = description;
    this.rewardPerReferral = rewardPerReferral;
    notifyListeners();
  }

  int rewardsPaidAmount = 0;
  String rewardsPaidSubtitle = '0 payouts';

  // Weekly Referrals chart data
  String weeklyGrowth = '+0%';
  List<WeeklyReferralModel> weeklyData = const [
    WeeklyReferralModel(day: 'Sun', count: 0),
    WeeklyReferralModel(day: 'Mon', count: 0),
    WeeklyReferralModel(day: 'Tue', count: 0),
    WeeklyReferralModel(day: 'Wed', count: 0),
    WeeklyReferralModel(day: 'Thu', count: 0),
    WeeklyReferralModel(day: 'Fri', count: 0),
    WeeklyReferralModel(day: 'Sat', count: 0),
  ];

  // Public Listing data
  String listingName = 'My Business';
  String listingCategory = 'General';
  String listingRating = '5.0★';
  String listingHours = 'Open';
  String listingDescription = 'Welcome to our business.';
  String rewardPerReferral = '\$0';
  int activePromotersCount = 0;

  // Recent Activity List
  List<BusinessRecentActivityModel> recentActivities = const [];

  Future<void> fetchDashboardOverview() async {
    _isLoading = true;
    notifyListeners();

    final response = await ApiClient.get(ApiConstants.businessOverview, withAuth: true);

    _isLoading = false;

    if (response.success && response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;

      businessName = data['businessName']?.toString() ?? businessName;

      if (data['metrics'] is Map<String, dynamic>) {
        final m = data['metrics'] as Map<String, dynamic>;
        totalReferrals = (m['totalReferrals'] as num?)?.toInt() ?? 0;
        referralsSubtitle = m['referralsSubtitle']?.toString() ?? referralsSubtitle;

        conversionsCount = (m['conversionsCount'] as num?)?.toInt() ?? 0;
        conversionsSubtitle = m['conversionsSubtitle']?.toString() ?? conversionsSubtitle;

        final rev = (m['revenueDriven'] as num?)?.toDouble() ?? 0.0;
        revenueDrivenK = rev >= 1000 ? (rev / 1000) : rev;
        revenueSubtitle = m['revenueSubtitle']?.toString() ?? revenueSubtitle;

        rewardsPaidAmount = (m['rewardsPaidAmount'] as num?)?.toInt() ?? 0;
        rewardsPaidSubtitle = m['rewardsPaidSubtitle']?.toString() ?? rewardsPaidSubtitle;
      }

      weeklyGrowth = data['weeklyGrowth']?.toString() ?? weeklyGrowth;

      if (data['weeklyData'] is List) {
        final list = data['weeklyData'] as List;
        weeklyData = list.map((item) {
          if (item is Map<String, dynamic>) {
            return WeeklyReferralModel(
              day: item['day']?.toString() ?? '',
              count: (item['count'] as num?)?.toDouble() ?? 0.0,
            );
          }
          return const WeeklyReferralModel(day: '', count: 0);
        }).toList();
      }

      if (data['listing'] is Map<String, dynamic>) {
        final l = data['listing'] as Map<String, dynamic>;
        listingName = l['listingName']?.toString() ?? listingName;
        listingCategory = l['listingCategory']?.toString() ?? listingCategory;
        listingRating = l['listingRating']?.toString() ?? listingRating;
        listingHours = l['listingHours']?.toString() ?? listingHours;
        listingDescription = l['listingDescription']?.toString() ?? listingDescription;
        rewardPerReferral = l['rewardPerReferral']?.toString() ?? rewardPerReferral;
        activePromotersCount = (l['activePromotersCount'] as num?)?.toInt() ?? 0;
      }
    }

    _animateCounters = true;
    notifyListeners();
  }

  void onScanAndVerify(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.businessScan);
  }

  void onManageReferrals(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.businessReferrals);
  }

  void onEditPublicListing(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.editListing);
  }

  void onViewAllActivity(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.businessReferrals);
  }

  void onNotifications(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.notifications);
  }

  void onNavTap(BuildContext context, int index) {
    if (index == _selectedNavIndex) return;
    _selectedNavIndex = index;
    notifyListeners();

    if (index == 1) {
      Navigator.pushNamed(context, AppRoutes.businessReferrals);
    } else if (index == 2) {
      Navigator.pushNamed(context, AppRoutes.businessScan);
    } else if (index == 3) {
      Navigator.pushNamed(context, AppRoutes.businessCampaigns);
    } else if (index == 4) {
      Navigator.pushNamed(context, AppRoutes.businessProfile);
    }
  }
}
