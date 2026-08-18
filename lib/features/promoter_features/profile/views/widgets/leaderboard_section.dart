import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';
import '../../models/leaderboard_user_model.dart';

class LeaderboardSection extends StatelessWidget {
  final List<LeaderboardUserModel> users;
  final String selectedPeriod;
  final List<String> periods;
  final ValueChanged<String> onSelectPeriod;

  const LeaderboardSection({
    super.key,
    required this.users,
    required this.selectedPeriod,
    required this.periods,
    required this.onSelectPeriod,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Leaderboard Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Leaderboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            PopupMenuButton<String>(
              onSelected: onSelectPeriod,
              color: const Color(0xFF092942),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFF1B4968), width: 0.8),
              ),
              itemBuilder: (context) {
                return periods.map((p) {
                  return PopupMenuItem<String>(
                    value: p,
                    child: Text(
                      p,
                      style: TextStyle(
                        color: p == selectedPeriod ? AppColors.businessPrimary : Colors.white,
                        fontSize: 12.5,
                        fontWeight: p == selectedPeriod ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  );
                }).toList();
              },
              child: Row(
                children: [
                  Text(
                    selectedPeriod,
                    style: const TextStyle(
                      color: Color(0xFF4C5FF5),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(
                    Icons.arrow_drop_down,
                    size: 18,
                    color: Color(0xFF4C5FF5),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // List of Rankings
        Column(
          children: users.map((u) => _LeaderboardTile(user: u)).toList(),
        ),
      ],
    );
  }
}

class _LeaderboardTile extends StatelessWidget {
  final LeaderboardUserModel user;

  const _LeaderboardTile({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: user.isCurrentUser
            ? const Color(0xFF0F3255)
            : const Color(0xFF092942),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: user.isCurrentUser
              ? const Color(0xFF2B6299)
              : const Color(0xFF1B4968),
          width: user.isCurrentUser ? 1.2 : 0.8,
        ),
      ),
      child: Row(
        children: [
          // Rank Badge or Text
          _buildRankBadge(),

          const SizedBox(width: 10),

          // User Avatar / Initials
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: user.avatarColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Name & Referrals count
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: user.isCurrentUser ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${user.referralsCount} referrals',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Earnings
          Text(
            user.earnings,
            style: TextStyle(
              color: user.isCurrentUser ? AppColors.businessPrimary : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankBadge() {
    if (user.rank == 1) {
      return const Text('🥇', style: TextStyle(fontSize: 16));
    } else if (user.rank == 2) {
      return const Text('🥈', style: TextStyle(fontSize: 16));
    } else if (user.rank == 3) {
      return const Text('🥉', style: TextStyle(fontSize: 16));
    } else {
      return SizedBox(
        width: 24,
        child: Text(
          '#${user.rank}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
  }
}
