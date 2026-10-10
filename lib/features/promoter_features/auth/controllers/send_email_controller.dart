import 'package:flutter/material.dart';
import '../../../../app/routes/routes.dart';
import '../../../../app/theme/theme.dart';
import '../../../../core/enums/auth_role.dart';
import '../../../../core/services/storage_service.dart';
import '../providers/auth_provider.dart';

class SendEmailController extends ChangeNotifier {
  AuthRole _role = AuthRole.promoter;
  String _email = 'you@example.com';
  final TextEditingController otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;

  AuthRole get role => _role;
  set role(AuthRole r) {
    _role = r;
    notifyListeners();
  }

  String get email => _email;
  set email(String e) {
    _email = e;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  bool get isResending => _isResending;
  bool get isBusiness => _role == AuthRole.business;

  Color get primaryColor => isBusiness ? AppColors.businessPrimary : AppColors.promoterPrimary;
  Color get iconBackground => isBusiness ? AppColors.iconGreen : AppColors.iconBlue;
  Color get iconColor => isBusiness ? AppColors.businessPrimary : AppColors.promoterPrimary;

  void init({required AuthRole role, required String email}) {
    _role = role;
    _email = email;
    notifyListeners();
  }

  Future<void> verifyCode(BuildContext context, AuthProvider authProvider) async {
    final code = otpController.text.trim();
    if (code.isEmpty) {
      _showSnackbar(context, 'Please enter the 6-digit verification code', isError: true);
      return;
    }

    _isLoading = true;
    notifyListeners();

    final response = await authProvider.verifyOtp(email: _email, otp: code);

    _isLoading = false;
    notifyListeners();

    if (!context.mounted) return;

    if (response.success) {
      final roleStr = (authProvider.isBusinessOwner || isBusiness) ? 'BUSINESS_OWNER' : 'PROMOTER';
      await StorageService.saveRole(roleStr);
      if (!context.mounted) return;
      _showSnackbar(context, 'Email verified successfully!', isError: false);
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
      _showSnackbar(context, response.message, isError: true);
    }
  }

  Future<void> resendCode(BuildContext context, AuthProvider authProvider) async {
    _isResending = true;
    notifyListeners();

    final response = await authProvider.resendOtp(email: _email);

    _isResending = false;
    notifyListeners();

    if (!context.mounted) return;

    if (response.success) {
      _showSnackbar(context, 'A new verification code has been sent to your email!', isError: false);
    } else {
      _showSnackbar(context, response.message, isError: true);
    }
  }

  void tryDifferentEmail(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.forgetPassword,
      arguments: _role,
    );
  }

  void backToSignIn(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.signIn,
      (route) => false,
      arguments: _role,
    );
  }

  void _showSnackbar(BuildContext context, String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.red.shade900 : Colors.green.shade800,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
}
