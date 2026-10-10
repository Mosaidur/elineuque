import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/routes/routes.dart';
import '../../../../app/theme/theme.dart';
import '../../../../core/enums/auth_role.dart';
import '../../../../core/services/storage_service.dart';
import '../providers/auth_provider.dart';

class SignInController extends ChangeNotifier {
  AuthRole _role = AuthRole.promoter;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isSignUp = false;

  AuthRole get role => _role;
  set role(AuthRole r) => initRole(r);
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isLoading => _isLoading;
  bool get isBusiness => _role == AuthRole.business;
  bool get isSignUp => _isSignUp;

  String get accountTitle => isBusiness ? 'Business Account' : 'Promoter Account';
  Color get primaryColor => isBusiness ? AppColors.businessPrimary : AppColors.promoterPrimary;

  void initRole(AuthRole role) {
    if (_role == role) return;
    _role = role;
    notifyListeners();
  }

  void selectSignIn() {
    _isSignUp = false;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void selectSignUp(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.signUp,
      arguments: _role,
    );
  }

  void goToForgotPassword(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.forgetPassword,
      arguments: _role,
    );
  }

  Future<void> signIn(BuildContext context, AuthProvider authProvider) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty) {
      _showSnackbar(context, 'Please enter your email address', isError: true);
      return;
    }

    if (password.isEmpty) {
      _showSnackbar(context, 'Please enter your password', isError: true);
      return;
    }

    _isLoading = true;
    notifyListeners();

    final response = await authProvider.login(
      email: email,
      password: password,
    );

    _isLoading = false;
    notifyListeners();

    if (!context.mounted) return;

    if (response.success) {
      final roleStr = (authProvider.isBusinessOwner || isBusiness) ? 'BUSINESS_OWNER' : 'PROMOTER';
      await StorageService.saveRole(roleStr);
      if (!context.mounted) return;
      _showSnackbar(context, 'Logged in successfully!', isError: false);
      if (authProvider.isBusinessOwner || isBusiness) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.businessDashboard,
          (route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (route) => false,
        );
      }
    } else {
      final msg = response.message.toLowerCase();
      final isUnverified = (response.raw?['data'] is Map &&
              response.raw?['data']['isUnverified'] == true) ||
          msg.contains('verify');

      if (isUnverified) {
        final targetRole = isBusiness || authProvider.isBusinessOwner
            ? AuthRole.business
            : AuthRole.promoter;

        _showSnackbar(
          context,
          'Please verify your email. A verification code has been sent.',
          isError: true,
        );
        Get.toNamed(
          AppRoutes.sendEmail,
          arguments: {
            'role': targetRole,
            'email': email,
          },
        );
        return;
      }

      _showSnackbar(context, response.message, isError: true);
    }
  }

  void continueWithGoogle(BuildContext context) {
    if (isBusiness) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.businessDashboard, (r) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (r) => false);
    }
  }

  void continueWithApple(BuildContext context) {
    if (isBusiness) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.businessDashboard, (r) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (r) => false);
    }
  }

  void _showSnackbar(BuildContext context, String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.red.shade900 : Colors.green.shade800,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}