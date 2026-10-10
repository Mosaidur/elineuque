import 'package:flutter/material.dart';
import '../../../../app/routes/routes.dart';
import '../../../../app/theme/theme.dart';
import '../../../../core/enums/auth_role.dart';
import '../providers/auth_provider.dart';

class ForgetPasswordController extends ChangeNotifier {
  AuthRole _role = AuthRole.promoter;
  final TextEditingController emailController = TextEditingController();
  bool _isLoading = false;

  AuthRole get role => _role;
  set role(AuthRole r) => initRole(r);
  bool get isLoading => _isLoading;
  bool get isBusiness => _role == AuthRole.business;

  Color get primaryColor => isBusiness ? AppColors.businessPrimary : AppColors.promoterPrimary;
  Color get iconBackground => isBusiness ? AppColors.iconGreen : AppColors.iconBlue;
  Color get iconColor => isBusiness ? AppColors.businessPrimary : AppColors.promoterPrimary;

  void initRole(AuthRole role) {
    if (_role == role) return;
    _role = role;
    notifyListeners();
  }

  Future<void> sendResetLink(BuildContext context, AuthProvider authProvider) async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _showSnackbar(context, 'Please enter your email address', isError: true);
      return;
    }

    final bool isEmailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    if (!isEmailValid) {
      _showSnackbar(context, 'Please enter a valid email address', isError: true);
      return;
    }

    _isLoading = true;
    notifyListeners();

    final response = await authProvider.forgotPassword(email: email);

    _isLoading = false;
    notifyListeners();

    if (!context.mounted) return;

    if (response.success) {
      _showSnackbar(context, response.message, isError: false);
      Navigator.pushNamed(
        context,
        AppRoutes.sendEmail,
        arguments: {
          'role': _role,
          'email': email,
        },
      );
    } else {
      _showSnackbar(context, response.message, isError: true);
    }
  }

  void backToSignIn(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.signIn,
      arguments: _role,
    );
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
    super.dispose();
  }
}

typedef ForgetPassController = ForgetPasswordController;
