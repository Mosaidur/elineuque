import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/theme.dart';
import '../controllers/send_email_controller.dart';

class SendEmailScreen extends GetView<SendEmailController> {
  const SendEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                // TOP CHECKMARK ICON BADGE
                // ─────────────────────────────
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: controller.iconBackground,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.border,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: controller.iconColor,
                          width: 2.2,
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        size: 24,
                        color: controller.iconColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ─────────────────────────────
                // TITLE
                // ─────────────────────────────
                const Text(
                  'Check your inbox',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                // ─────────────────────────────
                // SUBTITLE 1
                // ─────────────────────────────
                const Text(
                  'We sent a password reset link to',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 6),

                // ─────────────────────────────
                // HIGHLIGHTED EMAIL
                // ─────────────────────────────
                Text(
                  controller.email,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: controller.primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 14),

                // ─────────────────────────────
                // SUBTITLE 2 (SPAM NOTE)
                // ─────────────────────────────
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Didn't receive it? Check your spam folder or try again.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.5,
                      height: 1.45,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ─────────────────────────────
                // TRY A DIFFERENT EMAIL BUTTON
                // ─────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: controller.tryDifferentEmail,
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
                      'Try a different email',
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
                  onTap: controller.backToSignIn,
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
