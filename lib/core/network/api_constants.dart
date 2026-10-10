import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5001/api/v1';
    }
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:5001/api/v1';
      }
    } catch (_) {
      // In web or non-dart:io environments
    }
    return 'http://localhost:5001/api/v1';
  }

  // Auth routes
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String me = '/auth/me'; 
  static const String refreshToken = '/auth/refresh-token';
  static const String forgetPassword = '/auth/forget-password';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';
  static const String logout = '/auth/logout';

  // Business Dashboard
  static const String businessOverview = '/dashboard/business-overview';

  // Campaigns
  static const String campaigns = '/campaigns';
  static const String myCampaigns = '/campaigns/my-campaigns';
  static String activateCampaign(String id) => '/campaigns/$id/activate';

  // Referral & QR Scans
  static const String scanReferral = '/referrals/scan';
  static const String myScans = '/referrals/my-scans';
  static const String myReferrals = '/referrals/my-referrals';
  static const String myRewards = '/reward-ledger/my-rewards';
  static String joinCampaign(String id) => '/campaigns/$id/join';

  // Profile & Community
  static const String userProfile = '/users/profile';
  static const String discoverBusinesses = '/users/discover-businesses';
  static const String leaderboard = '/users/leaderboard';
  static const String myBadges = '/users/my-badges';
  static const String posts = '/posts';
  static String likePost(String id) => '/posts/$id/like';
  static String postComments(String id) => '/posts/$id/comments';
}
