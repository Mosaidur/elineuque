import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class AnimatedKpiCard extends StatelessWidget {
  final String label;
  final num targetValue;
  final String prefix;
  final String suffix;
  final bool isDecimal;
  final String subtitle;
  final Color valueColor;
  final bool startAnimation;

  const AnimatedKpiCard({
    super.key,
    required this.label,
    required this.targetValue,
    this.prefix = '',
    this.suffix = '',
    this.isDecimal = false,
    required this.subtitle,
    required this.valueColor,
    required this.startAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF092942),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1B4968),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),

          // Count-Up Animated Number Value
          TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: 0,
              end: startAnimation ? targetValue.toDouble() : 0,
            ),
            duration: const Duration(milliseconds: 1400),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              final formattedStr = isDecimal
                  ? value.toStringAsFixed(1)
                  : value.toInt().toString();

              return Text(
                '$prefix$formattedStr$suffix',
                style: TextStyle(
                  color: valueColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              );
            },
          ),

          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
