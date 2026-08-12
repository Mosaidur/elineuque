import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';


class SocialLoginButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isApple;

  const SocialLoginButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isApple = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: Material(
        color: isApple
            ? AppColors.white
            : AppColors.input,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isApple
                    ? AppColors.white
                    : AppColors.border,
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isApple)
                  const Icon(
                    Icons.apple,
                    size: 16,
                    color: Colors.black,
                  )
                else
                  const Text(
                    'G',
                    style: TextStyle(
                      color: Color(0xFF4285F4),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                const SizedBox(width: 8),

                Text(
                  title,
                  style: TextStyle(
                    color: isApple
                        ? Colors.black
                        : AppColors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
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