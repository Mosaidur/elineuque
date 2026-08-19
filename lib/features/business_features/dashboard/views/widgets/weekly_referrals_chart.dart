import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';
import '../../models/weekly_referral_model.dart';

class WeeklyReferralsChart extends StatelessWidget {
  final List<WeeklyReferralModel> data;
  final String growthRate;
  final bool startAnimation;

  const WeeklyReferralsChart({
    super.key,
    required this.data,
    required this.growthRate,
    required this.startAnimation,
  });

  @override
  Widget build(BuildContext context) {
    // Find max count to scale bar heights relative to container
    final maxCount = data.fold<double>(
      1,
      (max, item) => item.count > max ? item.count : max,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF092942),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1B4968),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Referrals',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                growthRate,
                style: const TextStyle(
                  color: AppColors.businessPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 7 Bar Graph Container
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((item) {
                final targetHeight = (item.count / maxCount) * 75;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Animated Bar
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0,
                        end: startAnimation ? targetHeight : 0,
                      ),
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.easeOutQuart,
                      builder: (context, heightValue, child) {
                        return Container(
                          width: 28,
                          height: heightValue.clamp(4.0, 75.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5365F5),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF5365F5).withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    // Day Name
                    Text(
                      item.day,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
