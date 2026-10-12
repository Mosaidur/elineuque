import 'package:flutter/material.dart';
import '../../../../app/routes/routes.dart';
import '../../../../app/theme/theme.dart';
import '../../../../core/enums/auth_role.dart';
import '../providers/auth_provider.dart';

class SignUpController extends ChangeNotifier {
  AuthRole _role = AuthRole.promoter;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  AuthRole get role => _role;
  set role(AuthRole r) => initRole(r);
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isLoading => _isLoading;
  bool get isBusiness => _role == AuthRole.business;

  String get accountTitle => isBusiness ? 'Business Account' : 'Promoter Account';
  String get nameLabel => isBusiness ? 'Business Name' : 'Full Name';
  String get nameHint => isBusiness ? 'e.g. FitZone Health Club' : 'e.g. Alex Morgan';
  IconData get nameIcon => isBusiness ? Icons.storefront_outlined : Icons.person_outline_rounded;
  Color get primaryColor => isBusiness ? AppColors.businessPrimary : AppColors.promoterPrimary;

  void initRole(AuthRole role) {
    if (_role == role) return;
    _role = role;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void goToSignIn(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.signIn,
      arguments: _role,
    );
  }

  Future<void> signUp(BuildContext context, AuthProvider authProvider) async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty) {
      _showSnackbar(context, 'Please enter your ${nameLabel.toLowerCase()}', isError: true);
      return;
    }

    if (email.isEmpty) {
      _showSnackbar(context, 'Please enter your email address', isError: true);
      return;
    }

    if (phone.isEmpty) {
      _showSnackbar(context, 'Please enter your phone number', isError: true);
      return;
    }

    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-={}\[\]|;:\x22\x27,.<>\/?]).{8,}$');
    if (password.isEmpty || !passwordRegex.hasMatch(password)) {
      _showSnackbar(
        context,
        'Password must be at least 8 chars long with uppercase (A-Z), lowercase (a-z), a number (0-9), and special character (e.g. Elinque@123)',
        isError: true,
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    final backendRole = isBusiness ? 'BUSINESS_OWNER' : 'PROMOTER';
    final response = await authProvider.register(
      name: name,
      email: email,
      phone: phone,
      password: password,
      role: backendRole,
      businessName: isBusiness ? name : null,
    );

    _isLoading = false;
    notifyListeners();

    if (!context.mounted) return;

    if (response.success) {
      _showSnackbar(context, 'Verification code sent to your email.', isError: false);
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
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
