import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';
import '../../models/spotlight_deal_model.dart';

class MiniBusinessCard extends StatelessWidget {
  final SpotlightDeal deal;
  final VoidCallback onTap;

  const MiniBusinessCard({
    super.key,
    required this.deal,
    required this.onTap,
  });

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'café':
      case 'cafe':
        return Icons.coffee_outlined;
      case 'fitness':
        return Icons.fitness_center_outlined;
      case 'wellness':
        return Icons.spa_outlined;
      default:
        return Icons.storefront_outlined;
    }
  }

  Color _getColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'café':
      case 'cafe':
        return const Color(0xFFFFA726);
      case 'fitness':
        return const Color(0xFF42A5F5);
      case 'wellness':
        return const Color(0xFFAB47BC);
      default:
        return AppColors.promoterPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final catColor = _getColorForCategory(deal.category);

    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border,
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Avatar
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: catColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: catColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  _getIconForCategory(deal.category),
                  size: 18,
                  color: catColor,
                ),
              ),

              const SizedBox(height: 10),

              // Title
              Text(
                deal.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 2),

              // Category
              Text(
                deal.category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 8),

              // Reward Rate
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: deal.rewardAmount,
                      style: const TextStyle(
                        color: AppColors.businessPrimary,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text: ' / ref',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
