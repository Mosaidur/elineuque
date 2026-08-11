import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../../../../app/theme/theme.dart';
import '../../../../core/enums/auth_role.dart';

class SignUpController extends GetxController {
  late AuthRole role;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    final dynamic args = Get.arguments;
    if (args is AuthRole) {
      role = args;
    } else {
      role = AuthRole.promoter;
    }

    debugPrint('SignUpController initialized with role: $role');
  }

  bool get isBusiness => role == AuthRole.business;

  String get accountTitle {
    return isBusiness ? 'Business Account' : 'Promoter Account';
  }

  String get nameLabel {
    return isBusiness ? 'Business Name' : 'Full Name';
  }

  String get nameHint {
    return isBusiness ? 'FitZone Gym' : 'Devon Rivera';
  }

  IconData get nameIcon {
    return isBusiness ? Icons.business_outlined : Icons.mail_outline;
  }

  Color get primaryColor {
    return isBusiness
        ? AppColors.businessPrimary
        : AppColors.promoterPrimary;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  void goToSignIn() {
    Get.offNamed(
      AppRoutes.signIn,
      arguments: role,
    );
  }

  void signUp() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your ${nameLabel.toLowerCase()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.card,
        colorText: AppColors.white,
      );
      return;
    }

    if (email.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.card,
        colorText: AppColors.white,
      );
      return;
    }

    if (password.isEmpty || password.length < 6) {
      Get.snackbar(
        'Validation Error',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.card,
        colorText: AppColors.white,
      );
      return;
    }

    debugPrint('Executing Sign Up for role: $role');
    debugPrint('Name: $name, Email: $email, Phone: $phone, Password len: ${password.length}');

    Get.offAllNamed(AppRoutes.home);
  }

  void continueWithGoogle() {
    debugPrint('Sign Up with Google for role: $role');
    Get.offAllNamed(AppRoutes.home);
  }

  void continueWithApple() {
    debugPrint('Sign Up with Apple for role: $role');
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
