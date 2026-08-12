import 'package:elineuque/features/promoter_features/auth/views/widgets/account_badge.dart';
import 'package:elineuque/features/promoter_features/auth/views/widgets/auth_input_field.dart';
import 'package:elineuque/features/promoter_features/auth/views/widgets/auth_tab_selector.dart';
import 'package:elineuque/features/promoter_features/auth/views/widgets/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/theme.dart';
import '../controllers/sign_up_controller.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─────────────────────────────
                // HEADER
                // ─────────────────────────────
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      'assets/images/elivapp_logo.png',
                      width: 22,
                      height: 22,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'elivapp',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ─────────────────────────────
                // ACCOUNT TYPE BADGE
                // ─────────────────────────────
                AccountBadge(
                  role: controller.role,
                ),

                const SizedBox(height: 14),

                // ─────────────────────────────
                // SIGN IN / SIGN UP TAB SELECTOR
                // ─────────────────────────────
                AuthTabSelector(
                  isSignUp: true,
                  onSignIn: controller.goToSignIn,
                  onSignUp: () {},
                ),

                const SizedBox(height: 18),

                // ─────────────────────────────
                // TITLE
                // ─────────────────────────────
                const Text(
                  'Create account',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 12),

                // ─────────────────────────────
                // NAME (BUSINESS NAME / FULL NAME)
                // ─────────────────────────────
                AuthInputField(
                  label: controller.nameLabel,
                  hint: controller.nameHint,
                  icon: controller.nameIcon,
                  controller: controller.nameController,
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 12),

                // ─────────────────────────────
                // EMAIL
                // ─────────────────────────────
                AuthInputField(
                  label: 'Email',
                  hint: 'you@example.com',
                  icon: Icons.lock_outline,
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 12),

                // ─────────────────────────────
                // PHONE (OPTIONAL)
                // ─────────────────────────────
                AuthInputField(
                  label: 'Phone (optional)',
                  hint: '+1 555 000 0000',
                  icon: Icons.lock_outline,
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 12),

                // ─────────────────────────────
                // PASSWORD
                // ─────────────────────────────
                AuthInputField(
                  label: 'Password',
                  hint: 'Min. 6 characters',
                  icon: Icons.lock_outline,
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  showPasswordToggle: true,
                  onTogglePassword: controller.togglePasswordVisibility,
                  textInputAction: TextInputAction.done,
                ),

                const SizedBox(height: 16),

                // ─────────────────────────────
                // CREATE ACCOUNT BUTTON
                // ─────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: controller.signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.primaryColor,
                      foregroundColor: controller.isBusiness
                          ? Colors.black
                          : Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ─────────────────────────────
                // SIGN IN TOGGLE TEXT
                // ─────────────────────────────
                Center(
                  child: GestureDetector(
                    onTap: controller.goToSignIn,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: controller.primaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ─────────────────────────────
                // DIVIDER
                // ─────────────────────────────
                Row(
                  children: const [
                    Expanded(
                      child: Divider(
                        color: AppColors.border,
                        thickness: 0.6,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'or continue with',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColors.border,
                        thickness: 0.6,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ─────────────────────────────
                // SOCIAL LOGIN BUTTONS
                // ─────────────────────────────
                SocialLoginButton(
                  title: 'Continue with Google',
                  onTap: controller.continueWithGoogle,
                ),

                const SizedBox(height: 10),

                SocialLoginButton(
                  title: 'Continue with Apple',
                  isApple: true,
                  onTap: controller.continueWithApple,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
