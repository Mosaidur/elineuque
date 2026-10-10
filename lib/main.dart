import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'app/routes/routes.dart';
import 'core/services/storage_service.dart';
import 'features/promoter_features/auth/providers/auth_provider.dart';
import 'features/promoter_features/auth/providers/forget_password_provider.dart';
import 'features/promoter_features/auth/providers/role_selection_provider.dart';
import 'features/promoter_features/auth/providers/sign_in_provider.dart';
import 'features/promoter_features/auth/providers/sign_up_provider.dart';
import 'features/promoter_features/auth/providers/splash_provider.dart';
import 'features/promoter_features/auth/controllers/send_email_controller.dart';
import 'features/business_features/dashboard/controllers/business_dashboard_controller.dart';
import 'features/business_features/campaigns/controllers/campaigns_controller.dart';
import 'features/business_features/campaigns/controllers/edit_listing_controller.dart';
import 'features/business_features/scan/controllers/scan_controller.dart';
import 'features/business_features/referral/controllers/business_referral_controller.dart';
import 'features/business_features/profile/controllers/business_profile_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await StorageService.init();

  runApp(const Elivapp());
}

class Elivapp extends StatelessWidget {
  const Elivapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RoleSelectionProvider()),
        ChangeNotifierProvider(create: (_) => SignInProvider()),
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => ForgetPasswordProvider()),
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => SendEmailController()),
        ChangeNotifierProvider(create: (_) => BusinessDashboardController()),
        ChangeNotifierProvider(create: (_) => CampaignsController()),
        ChangeNotifierProvider(create: (_) => EditListingController()),
        ChangeNotifierProvider(create: (_) => ScanController()),
        ChangeNotifierProvider(create: (_) => BusinessReferralController()),
        ChangeNotifierProvider(create: (_) => BusinessProfileController()),
      ],
      child: GetMaterialApp(
        title: 'Elivapp',
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        getPages: AppRoutes.pages,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFF001F3E),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFC8FF5A),
            brightness: Brightness.dark,
          ),
        ),
      ),
    );
  }
}