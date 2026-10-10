import 'package:elineuque/features/promoter_features/auth/views/widgets/auth_input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/theme.dart';
import '../../../../core/enums/auth_role.dart';
import '../providers/auth_provider.dart';
import '../providers/forget_password_provider.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is AuthRole) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<ForgetPasswordProvider>().initRole(args);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final forgetProvider = context.watch<ForgetPasswordProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ─────────────────────────────
                // TOP MAIL ICON BADGE
                // ─────────────────────────────
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: forgetProvider.iconBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.border,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.mail_outline,
                    size: 26,
                    color: forgetProvider.iconColor,
                  ),
                ),

                const SizedBox(height: 24),

                // ─────────────────────────────
                // TITLE
                // ─────────────────────────────
                const Text(
                  'Forgot your password?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                // ─────────────────────────────
                // SUBTITLE
                // ─────────────────────────────
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "No worries. Enter the email linked to your account and we'll send you a reset link.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13.5,
                      height: 1.45,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ─────────────────────────────
                // EMAIL INPUT
                // ─────────────────────────────
                AuthInputField(
                  label: 'Email',
                  hint: 'you@example.com',
                  icon: Icons.mail_outline,
                  controller: forgetProvider.emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                ),

                const SizedBox(height: 20),

                // ─────────────────────────────
                // SEND RESET LINK BUTTON
                // ─────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: forgetProvider.isLoading
                        ? null
                        : () => forgetProvider.sendResetLink(context, authProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: forgetProvider.primaryColor,
                      foregroundColor: forgetProvider.isBusiness
                          ? Colors.black
                          : Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: forgetProvider.isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                forgetProvider.isBusiness
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Send Reset Link',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 22),

                // ─────────────────────────────
                // BACK TO SIGN IN
                // ─────────────────────────────
                GestureDetector(
                  onTap: () => forgetProvider.backToSignIn(context),
                  child: const Text(
                    'Back to Sign In',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
