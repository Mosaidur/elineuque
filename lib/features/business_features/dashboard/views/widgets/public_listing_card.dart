import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class PublicListingCard extends StatelessWidget {
  final String title;
  final String category;
  final String rating;
  final String hours;
  final String description;
  final String rewardAmount;
  final int activePromoters;
  final VoidCallback onEdit;

  const PublicListingCard({
    super.key,
    required this.title,
    required this.category,
    required this.rating,
    required this.hours,
    required this.description,
    required this.rewardAmount,
    required this.activePromoters,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your Public Listing',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            GestureDetector(
              onTap: onEdit,
              child: const Text(
                'Edit →',
                style: TextStyle(
                  color: AppColors.businessPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Card Container
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
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
              // Top Row: Avatar & Details
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF193D64),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.fitness_center,
                      color: Color(0xFF42A5F5),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.circle,
                              size: 6,
                              color: AppColors.businessPrimary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$category · $rating · $hours',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFC4D5E6),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 12),

              // Reward Rate & Promoters
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: rewardAmount,
                      style: const TextStyle(
                        color: AppColors.businessPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: ' per referral · $activePromoters promoters active',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
