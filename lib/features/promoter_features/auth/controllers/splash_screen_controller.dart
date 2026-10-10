import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../app/routes/routes.dart';
import '../../../../core/services/storage_service.dart';

class SplashScreenController extends ChangeNotifier {
  Timer? _timer;

  void startSplashTimer(BuildContext context) => initialize(context);

  void initialize(BuildContext context) {
    _timer?.cancel();
    _timer = Timer(
      const Duration(milliseconds: 1500),
      () {
        if (!context.mounted) return;
        final isLoggedIn = StorageService.isLoggedIn();
        final token = StorageService.getAccessToken();
        final role = StorageService.getRole()?.toUpperCase();

        debugPrint('Splash check - isLoggedIn: $isLoggedIn, token: ${token != null ? "exists" : "null"}, role: $role');

        if (isLoggedIn && token != null && token.isNotEmpty) {
          if (role == 'BUSINESS_OWNER' || role == 'BUSINESS') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.businessDashboard,
              (route) => false,
            );
            return;
          } else if (role == 'PROMOTER') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (route) => false,
            );
            return;
          } else {
            // Role unknown but logged in - fallback safely to role selection or dashboard
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.businessDashboard,
              (route) => false,
            );
            return;
          }
        }

        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.roleSelection,
          (route) => false,
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

typedef SplashController = SplashScreenController;