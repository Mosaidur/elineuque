import 'package:flutter_test/flutter_test.dart';
import 'package:elineuque/core/enums/auth_role.dart';
import 'package:elineuque/features/promoter_features/auth/controllers/forget_pass_controller.dart';
import 'package:elineuque/features/promoter_features/auth/controllers/role_select_controller.dart';
import 'package:elineuque/features/promoter_features/auth/controllers/send_email_controller.dart';
import 'package:elineuque/features/promoter_features/auth/controllers/sign_in_controller.dart';
import 'package:elineuque/features/promoter_features/auth/controllers/sign_up_controller.dart';
import 'package:elineuque/app/theme/theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RoleSelectionController Tests', () {
    test('RoleSelectionController contains two roles with correct AuthRoles', () {
      final controller = RoleSelectionController();
      expect(controller.roles.length, 2);

      final promoterRole = controller.roles.firstWhere((r) => !r.isBusiness);
      expect(promoterRole.role, AuthRole.promoter);
      expect(promoterRole.title, 'Promoter / Referrer');

      final businessRole = controller.roles.firstWhere((r) => r.isBusiness);
      expect(businessRole.role, AuthRole.business);
      expect(businessRole.title, 'Business Owner');
    });
  });

  group('SignInController Tests', () {
    test('SignInController initializes with promoter role by default', () {
      final controller = SignInController();

      expect(controller.role, AuthRole.promoter);
      expect(controller.isBusiness, false);
      expect(controller.accountTitle, 'Promoter Account');
      expect(controller.primaryColor, AppColors.promoterPrimary);
    });

    test('SignInController toggles password visibility', () {
      final controller = SignInController();

      expect(controller.isPasswordVisible, false);
      controller.togglePasswordVisibility();
      expect(controller.isPasswordVisible, true);
      controller.togglePasswordVisibility();
      expect(controller.isPasswordVisible, false);
    });
  });

  group('SignUpController Tests', () {
    test('SignUpController adapts dynamically for Promoter role', () {
      final controller = SignUpController();

      expect(controller.role, AuthRole.promoter);
      expect(controller.isBusiness, false);
      expect(controller.accountTitle, 'Promoter Account');
      expect(controller.nameLabel, 'Full Name');
      expect(controller.nameHint, 'Devon Rivera');
      expect(controller.primaryColor, AppColors.promoterPrimary);
    });

    test('SignUpController adapts dynamically for Business role', () {
      final controller = SignUpController();
      controller.role = AuthRole.business;

      expect(controller.isBusiness, true);
      expect(controller.accountTitle, 'Business Account');
      expect(controller.nameLabel, 'Business Name');
      expect(controller.nameHint, 'FitZone Gym');
      expect(controller.primaryColor, AppColors.businessPrimary);
    });

    test('SignUpController toggles password visibility', () {
      final controller = SignUpController();

      expect(controller.isPasswordVisible, false);
      controller.togglePasswordVisibility();
      expect(controller.isPasswordVisible, true);
      controller.togglePasswordVisibility();
      expect(controller.isPasswordVisible, false);
    });
  });

  group('ForgetPasswordController Tests', () {
    test('ForgetPasswordController adapts styling for promoter and business', () {
      final promoterController = ForgetPasswordController();
      promoterController.role = AuthRole.promoter;
      expect(promoterController.primaryColor, AppColors.promoterPrimary);
      expect(promoterController.iconColor, AppColors.promoterPrimary);

      final businessController = ForgetPasswordController();
      businessController.role = AuthRole.business;
      expect(businessController.primaryColor, AppColors.businessPrimary);
      expect(businessController.iconColor, AppColors.businessPrimary);
    });
  });

  group('SendEmailController Tests', () {
    test('SendEmailController initializes email and role', () {
      final controller = SendEmailController();
      controller.role = AuthRole.business;
      controller.email = 'test@example.com';

      expect(controller.isBusiness, true);
      expect(controller.email, 'test@example.com');
      expect(controller.primaryColor, AppColors.businessPrimary);
    });
  });
}
