import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../../../../app/theme/theme.dart';
import '../../../../core/enums/auth_role.dart';

class SendEmailController extends GetxController {
  late AuthRole role;
  late String email;

  @override
  void onInit() {
    super.onInit();

    final dynamic args = Get.arguments;
    if (args is Map) {
      role = args['role'] is AuthRole ? args['role'] as AuthRole : AuthRole.promoter;
      email = args['email'] is String ? args['email'] as String : 'you@example.com';
    } else if (args is AuthRole) {
      role = args;
      email = 'you@example.com';
    } else {
      role = AuthRole.promoter;
      email = 'you@example.com';
    }

    debugPrint('SendEmailController initialized with role: $role, email: $email');
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

  void tryDifferentEmail() {
    Get.offNamed(
      AppRoutes.forgetPassword,
      arguments: role,
    );
  }

  void backToSignIn() {
    Get.offAllNamed(
      AppRoutes.signIn,
      arguments: role,
    );
  }
}
