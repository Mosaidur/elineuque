import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';
import '../../models/profile_badge_model.dart';

class BadgesGrid extends StatelessWidget {
  final List<ProfileBadgeModel> badges;
  final String earnedText;

  const BadgesGrid({
    super.key,
    required this.badges,
    required this.earnedText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badges Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Badges',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              earnedText,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Grid 2x3
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: badges.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (context, index) {
            final b = badges[index];
            return _BadgeTile(badge: b);
          },
        ),
      ],
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final ProfileBadgeModel badge;

  const _BadgeTile({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF092942),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: badge.isEarned
              ? const Color(0xFF1B4968)
              : const Color(0xFF13344D),
          width: 0.8,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Icon(
            badge.icon,
            size: 24,
            color: badge.isEarned
                ? badge.iconColor
                : AppColors.textMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 6),
          // Title
          Text(
            badge.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: badge.isEarned ? Colors.white : AppColors.textMuted,
              fontSize: 11,
              fontWeight: badge.isEarned ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          // Checkmark or Empty
          if (badge.isEarned)
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Color(0xFFC8FF5A),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                size: 11,
                color: Colors.black,
              ),
            )
          else
            const SizedBox(height: 16),
        ],
      ),
    );
  }
}
