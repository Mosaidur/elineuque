import 'package:elineuque/features/promoter_features/auth/views/widgets/account_badge.dart';
import 'package:elineuque/features/promoter_features/auth/views/widgets/auth_input_field.dart';
import 'package:elineuque/features/promoter_features/auth/views/widgets/auth_tab_selector.dart';
import 'package:elineuque/features/promoter_features/auth/views/widgets/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/theme.dart';
import '../../../../core/enums/auth_role.dart';
import '../providers/auth_provider.dart';
import '../providers/sign_up_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is AuthRole) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<SignUpProvider>().initRole(args);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final signUpProvider = context.watch<SignUpProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
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
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
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
                role: signUpProvider.role,
              ),

              const SizedBox(height: 14),

              // ─────────────────────────────
              // SIGN IN / SIGN UP TAB SELECTOR
              // ─────────────────────────────
              AuthTabSelector(
                isSignUp: true,
                onSignIn: () => signUpProvider.goToSignIn(context),
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
                label: signUpProvider.nameLabel,
                hint: signUpProvider.nameHint,
                icon: signUpProvider.nameIcon,
                controller: signUpProvider.nameController,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 12),

              // ─────────────────────────────
              // EMAIL
              // ─────────────────────────────
              AuthInputField(
                label: signUpProvider.isBusiness ? 'Business Email' : 'Email Address',
                hint: signUpProvider.isBusiness ? 'contact@business.com' : 'name@example.com',
                icon: Icons.email_outlined,
                controller: signUpProvider.emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 12),

              // ─────────────────────────────
              // PHONE
              // ─────────────────────────────
              AuthInputField(
                label: 'Phone Number',
                hint: '+1 (555) 000-0000',
                icon: Icons.phone_outlined,
                controller: signUpProvider.phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 12),

              // ─────────────────────────────
              // PASSWORD
              // ─────────────────────────────
              AuthInputField(
                label: 'Password',
                hint: 'Create a secure password',
                icon: Icons.lock_outline,
                controller: signUpProvider.passwordController,
                obscureText: !signUpProvider.isPasswordVisible,
                showPasswordToggle: true,
                onTogglePassword: signUpProvider.togglePasswordVisibility,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 6),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Must be 8+ chars with uppercase, lowercase, number & special char.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ─────────────────────────────
              // SUBMIT BUTTON (CREATE ACCOUNT)
              // ─────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: signUpProvider.isLoading
                      ? null
                      : () => signUpProvider.signUp(context, authProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: signUpProvider.primaryColor,
                    foregroundColor: signUpProvider.isBusiness
                        ? Colors.black
                        : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: signUpProvider.isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              signUpProvider.isBusiness
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        )
                      : const Text(
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
                  onTap: () => signUpProvider.goToSignIn(context),
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
                            color: signUpProvider.primaryColor,
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

              const SizedBox(height: 12),

              // ─────────────────────────────
              // SOCIAL LOGIN BUTTONS
              // ─────────────────────────────
              SocialLoginButton(
                title: 'Continue with Google',
                onTap: () {},
              ),

              const SizedBox(height: 10),

              SocialLoginButton(
                title: 'Continue with Apple',
                isApple: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
