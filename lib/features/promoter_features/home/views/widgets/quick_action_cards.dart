import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class QuickActionCards extends StatelessWidget {
  final VoidCallback onBrowseDeals;
  final VoidCallback onMyEarnings;
  final VoidCallback onWithdraw;

  const QuickActionCards({
    super.key,
    required this.onBrowseDeals,
    required this.onMyEarnings,
    required this.onWithdraw,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionItem(
            title: 'Browse Deals',
            icon: Icons.explore_outlined,
            iconColor: const Color(0xFFC8FF5A),
            circleBg: const Color(0xFF173B45),
            onTap: onBrowseDeals,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionItem(
            title: 'My Earnings',
            icon: Icons.bar_chart_rounded,
            iconColor: const Color(0xFF6B87FF),
            circleBg: const Color(0xFF183363),
            onTap: onMyEarnings,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionItem(
            title: 'Withdraw',
            icon: Icons.account_balance_wallet_outlined,
            iconColor: const Color(0xFFB57FFF),
            circleBg: const Color(0xFF36245C),
            onTap: onWithdraw,
          ),
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color circleBg;
  final VoidCallback onTap;

  const _ActionItem({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.circleBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border,
              width: 0.8,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: circleBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: iconColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
