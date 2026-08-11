import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../../../../app/theme/theme.dart';
import '../../../../core/enums/auth_role.dart';

class SignInController extends GetxController {
  late AuthRole role;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isSignUp = false.obs;
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

    debugPrint('Authentication role initialized: $role');
  }

  bool get isBusiness => role == AuthRole.business;

  String get accountTitle {
    return isBusiness ? 'Business Account' : 'Promoter Account';
  }

  Color get primaryColor {
    return isBusiness
        ? AppColors.businessPrimary
        : AppColors.promoterPrimary;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  void selectSignIn() {
    isSignUp.value = false;
  }

  void selectSignUp() {
    Get.offNamed(
      AppRoutes.signUp,
      arguments: role,
    );
  }

  void goToForgotPassword() {
    Get.toNamed(
      AppRoutes.forgetPassword,
      arguments: role,
    );
  }

  void signIn() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

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

    if (password.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.card,
        colorText: AppColors.white,
      );
      return;
    }

    debugPrint('Executing ${isSignUp.value ? "Sign Up" : "Sign In"} for role: $role');
    debugPrint('Email: $email, Password length: ${password.length}');

    if (isBusiness) {
      Get.offAllNamed(AppRoutes.businessDashboard);
    } else {
      Get.offAllNamed(AppRoutes.home);
    }
  }

  void continueWithGoogle() {
    debugPrint('Continue with Google for role: $role');
    if (isBusiness) {
      Get.offAllNamed(AppRoutes.businessDashboard);
    } else {
      Get.offAllNamed(AppRoutes.home);
    }
  }

  void continueWithApple() {
    debugPrint('Continue with Apple for role: $role');
    if (isBusiness) {
      Get.offAllNamed(AppRoutes.businessDashboard);
    } else {
      Get.offAllNamed(AppRoutes.home);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}