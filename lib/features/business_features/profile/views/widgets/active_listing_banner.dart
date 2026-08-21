import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class ActiveListingBanner extends StatelessWidget {
  final String rewardAmount;
  final int activePromoters;
  final String hours;
  final VoidCallback onEditListing;

  const ActiveListingBanner({
    super.key,
    required this.rewardAmount,
    required this.activePromoters,
    required this.hours,
    required this.onEditListing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF092942),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF1B4968),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: ACTIVE LISTING & Edit listing →
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ACTIVE LISTING',
                style: TextStyle(
                  color: AppColors.businessPrimary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              GestureDetector(
                onTap: onEditListing,
                child: const Text(
                  'Edit listing →',
                  style: TextStyle(
                    color: AppColors.businessPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Reward rate
          Row(
            children: [
              const Icon(
                Icons.card_giftcard_rounded,
                size: 18,
                color: AppColors.businessPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                '$rewardAmount per referral',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Promoters and hours info
          Text(
            '$activePromoters promoters currently active · $hours',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}
