import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class AuthTabSelector extends StatelessWidget {
  final bool isSignUp;
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;

  const AuthTabSelector({
    super.key,
    required this.isSignUp,
    required this.onSignIn,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(9),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onSignIn,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !isSignUp
                      ? const Color(0xFF294964)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: !isSignUp
                        ? AppColors.white
                        : AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: !isSignUp
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: onSignUp,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSignUp
                      ? const Color(0xFF294964)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: isSignUp
                        ? AppColors.white
                        : AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: isSignUp
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}