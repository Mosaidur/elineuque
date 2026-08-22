import 'package:get/get.dart';

import '../../features/business_features/campaigns/bindings/campaign_bindings.dart';
import '../../features/business_features/campaigns/views/campaigns_screen.dart';
import '../../features/business_features/campaigns/views/edit_listing_screen.dart';
import '../../features/business_features/dashboard/bindings/business_dashboard_bindings.dart';
import '../../features/business_features/dashboard/views/business_dashboard_screen.dart';
import '../../features/business_features/profile/bindings/business_profile_bindings.dart';
import '../../features/business_features/profile/views/business_profile_screen.dart';
import '../../features/business_features/referral/bindings/business_referral_bindings.dart';
import '../../features/business_features/referral/views/business_referral_screen.dart';
import '../../features/business_features/scan/bindings/scan_bindings.dart';
import '../../features/business_features/scan/views/scan_screen.dart';
import '../../features/promoter_features/auth/bindings/forget_pass_bindings.dart';
import '../../features/promoter_features/auth/bindings/roles_select_bindings.dart';
import '../../features/promoter_features/auth/bindings/send_email_bindings.dart';
import '../../features/promoter_features/auth/bindings/sign_in_bindings.dart';
import '../../features/promoter_features/auth/bindings/sign_up_bindings.dart';
import '../../features/promoter_features/auth/bindings/splash_screen_bindings.dart';
import '../../features/promoter_features/auth/views/forget_pass_screen.dart';
import '../../features/promoter_features/auth/views/role_select_screen.dart';
import '../../features/promoter_features/auth/views/send_email_screen.dart';
import '../../features/promoter_features/auth/views/sign_in_screen.dart';
import '../../features/promoter_features/auth/views/sign_up_screen.dart';
import '../../features/promoter_features/auth/views/spalsh_screen.dart';
import '../../features/promoter_features/discover/bindings/business_detail_bindings.dart';
import '../../features/promoter_features/discover/bindings/discover_bindings.dart';
import '../../features/promoter_features/discover/views/business_detail_screen.dart';
import '../../features/promoter_features/discover/views/discover_screen.dart';
import '../../features/promoter_features/feed/bindings/feed_bindings.dart';
import '../../features/promoter_features/feed/views/community_feed_screen.dart';
import '../../features/promoter_features/home/bindings/home_bindings.dart';
import '../../features/promoter_features/home/bindings/my_referrals_bindings.dart';
import '../../features/promoter_features/home/views/home_screen.dart';
import '../../features/promoter_features/home/views/my_referrals_screen.dart';
import '../../features/promoter_features/profile/bindings/profile_bindings.dart';
import '../../features/promoter_features/profile/views/profile_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const roleSelection = '/role-selection';
  static const String signIn = '/sign_in';
  static const String signUp = '/sign_up';
  static const String forgetPassword = '/forget_password';
  static const String sendEmail = '/send_email';
  static const String home = '/home';
  static const String myReferrals = '/my_referrals';
  static const String discover = '/discover';
  static const String businessDetail = '/business_detail';
  static const String communityFeed = '/community_feed';
  static const String profile = '/profile';
  static const String businessDashboard = '/business_dashboard';
  static const String businessReferrals = '/business_referrals';
  static const String businessScan = '/business_scan';
  static const String editListing = '/edit_listing';
  static const String businessCampaigns = '/business_campaigns';
  static const String businessProfile = '/business_profile';

  static final pages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),

    GetPage(
      name: roleSelection,
      page: () => const RoleSelectionScreen(),
      binding: RoleSelectionBinding(),
    ),

    GetPage(
      name: signIn,
      page: () => const SignInScreen(),
      binding: SignInBinding(),
    ),

    GetPage(
      name: signUp,
      page: () => const SignUpScreen(),
      binding: SignUpBinding(),
    ),

    GetPage(
      name: forgetPassword,
      page: () => const ForgetPassScreen(),
      binding: ForgetPasswordBinding(),
    ),

    GetPage(
      name: sendEmail,
      page: () => const SendEmailScreen(),
      binding: SendEmailBinding(),
    ),

    GetPage(
      name: home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: myReferrals,
      page: () => const MyReferralsScreen(),
      binding: MyReferralsBinding(),
    ),

    GetPage(
      name: discover,
      page: () => const DiscoverScreen(),
      binding: DiscoverBinding(),
    ),

    GetPage(
      name: businessDetail,
      page: () => const BusinessDetailScreen(),
      binding: BusinessDetailBinding(),
    ),

    GetPage(
      name: communityFeed,
      page: () => const CommunityFeedScreen(),
      binding: FeedBinding(),
    ),

    GetPage(
      name: profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),

    GetPage(
      name: businessDashboard,
      page: () => const BusinessDashboardScreen(),
      binding: BusinessDashboardBinding(),
    ),

    GetPage(
      name: businessReferrals,
      page: () => const BusinessReferralScreen(),
      binding: BusinessReferralBinding(),
    ),

    GetPage(
      name: businessScan,
      page: () => const ScanScreen(),
      binding: ScanBinding(),
    ),

    GetPage(
      name: editListing,
      page: () => const EditListingScreen(),
      binding: CampaignBinding(),
    ),

    GetPage(
      name: businessCampaigns,
      page: () => const CampaignsScreen(),
      binding: CampaignBinding(),
    ),

    GetPage(
      name: businessProfile,
      page: () => const BusinessProfileScreen(),
      binding: BusinessProfileBinding(),
    ),
  ];
}