import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../../../../app/theme/theme.dart';
import '../../../../core/enums/auth_role.dart';

class ForgetPasswordController extends GetxController {
  late AuthRole role;

  final emailController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    final dynamic args = Get.arguments;
    if (args is AuthRole) {
      role = args;
    } else if (args is Map && args['role'] is AuthRole) {
      role = args['role'] as AuthRole;
    } else {
      role = AuthRole.promoter;
    }

    debugPrint('ForgetPasswordController initialized with role: $role');
  }

  bool get isBusiness => role == AuthRole.business;

  Color get primaryColor {
    return isBusiness
        ? AppColors.businessPrimary
        : AppColors.promoterPrimary;
  }

  Color get iconBackground {
    return isBusiness
        ? AppColors.iconGreen
        : AppColors.iconBlue;
  }

  Color get iconColor {
    return isBusiness
        ? AppColors.businessPrimary
        : AppColors.promoterPrimary;
  }

  void sendResetLink() {
    final email = emailController.text.trim();

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

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Validation Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.card,
        colorText: AppColors.white,
      );
      return;
    }

    debugPrint('Sending password reset link to $email for role: $role');

    Get.toNamed(
      AppRoutes.sendEmail,
      arguments: {
        'role': role,
        'email': email,
      },
    );
  }

  void backToSignIn() {
    Get.offNamed(
      AppRoutes.signIn,
      arguments: role,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
