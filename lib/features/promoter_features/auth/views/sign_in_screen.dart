import 'package:elineuque/features/promoter_features/auth/views/widgets/account_badge.dart';
import 'package:elineuque/features/promoter_features/auth/views/widgets/auth_input_field.dart';
import 'package:elineuque/features/promoter_features/auth/views/widgets/auth_tab_selector.dart';
import 'package:elineuque/features/promoter_features/auth/views/widgets/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/theme.dart';
import '../../../../core/enums/auth_role.dart';
import '../providers/auth_provider.dart';
import '../providers/sign_in_provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is AuthRole) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<SignInProvider>().initRole(args);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final signInProvider = context.watch<SignInProvider>();

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
              // ACCOUNT TYPE
              // ─────────────────────────────
              AccountBadge(
                role: signInProvider.role,
              ),

              const SizedBox(height: 14),

              // ─────────────────────────────
              // SIGN IN / SIGN UP TAB SELECTOR
              // ─────────────────────────────
              AuthTabSelector(
                isSignUp: signInProvider.isSignUp,
                onSignIn: signInProvider.selectSignIn,
                onSignUp: () => signInProvider.selectSignUp(context),
              ),

              const SizedBox(height: 18),

              // ─────────────────────────────
              // TITLE
              // ─────────────────────────────
              Text(
                signInProvider.isSignUp ? 'Create account' : 'Welcome back',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              // ─────────────────────────────
              // EMAIL
              // ─────────────────────────────
              AuthInputField(
                label: 'Email',
                hint: 'name@example.com',
                icon: Icons.mail_outline,
                controller: signInProvider.emailController,
              ),

              const SizedBox(height: 12),

              // ─────────────────────────────
              // PASSWORD
              // ─────────────────────────────
              AuthInputField(
                label: 'Password',
                hint: 'Enter your password',
                icon: Icons.lock_outline,
                controller: signInProvider.passwordController,
                obscureText: !signInProvider.isPasswordVisible,
                showPasswordToggle: true,
                onTogglePassword: signInProvider.togglePasswordVisibility,
              ),

              const SizedBox(height: 8),

              // ─────────────────────────────
              // FORGOT PASSWORD
              // ─────────────────────────────
              if (!signInProvider.isSignUp) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => signInProvider.goToForgotPassword(context),
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: signInProvider.primaryColor,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ] else
                const SizedBox(height: 6),

              // ─────────────────────────────
              // SUBMIT BUTTON (SIGN IN / SIGN UP)
              // ─────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  onPressed: signInProvider.isLoading
                      ? null
                      : () => signInProvider.signIn(context, authProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: signInProvider.primaryColor,
                    foregroundColor: signInProvider.isBusiness
                        ? Colors.black
                        : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: signInProvider.isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              signInProvider.isBusiness
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          signInProvider.isSignUp ? 'Sign Up' : 'Sign In',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 14),

              // ─────────────────────────────
              // SIGN UP / SIGN IN TOGGLE TEXT
              // ─────────────────────────────
              Center(
                child: GestureDetector(
                  onTap: signInProvider.isSignUp
                      ? signInProvider.selectSignIn
                      : () => signInProvider.selectSignUp(context),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: signInProvider.isSignUp
                              ? 'Already have an account? '
                              : "Don't have an account? ",
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12.5,
                          ),
                        ),
                        TextSpan(
                          text: signInProvider.isSignUp ? 'Sign In' : 'Sign Up',
                          style: TextStyle(
                            color: signInProvider.primaryColor,
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