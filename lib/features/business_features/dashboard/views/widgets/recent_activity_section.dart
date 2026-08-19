import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';
import '../../models/business_recent_activity_model.dart';

class RecentActivitySection extends StatelessWidget {
  final List<BusinessRecentActivityModel> activities;
  final VoidCallback onViewAll;

  const RecentActivitySection({
    super.key,
    required this.activities,
    required this.onViewAll,
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
              'Recent Activity',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            GestureDetector(
              onTap: onViewAll,
              child: const Text(
                'View all',
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

        // Activity Tiles
        Column(
          children: activities.map((item) => _ActivityTile(item: item)).toList(),
        ),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final BusinessRecentActivityModel item;

  const _ActivityTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF092942),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1B4968),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFF1B3D5E),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                item.avatarEmoji,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Name & Action detail
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.customerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.actionDetail,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Status Badge Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: item.statusBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              item.statusLabel,
              style: TextStyle(
                color: item.statusTextColor,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
