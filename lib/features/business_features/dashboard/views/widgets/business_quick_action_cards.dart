import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class BusinessQuickActionCards extends StatelessWidget {
  final VoidCallback onScanAndVerify;
  final VoidCallback onManageReferrals;

  const BusinessQuickActionCards({
    super.key,
    required this.onScanAndVerify,
    required this.onManageReferrals,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Scan & Verify Card
        Expanded(
          child: _ActionCard(
            icon: Icons.camera_alt_outlined,
            iconBgColor: const Color(0xFF143B39),
            iconColor: AppColors.businessPrimary,
            title: 'Scan & Verify',
            subtitle: 'Confirm customer visits',
            onTap: onScanAndVerify,
          ),
        ),

        const SizedBox(width: 12),

        // Manage Referrals Card
        Expanded(
          child: _ActionCard(
            icon: Icons.people_outline,
            iconBgColor: const Color(0xFF1D3B64),
            iconColor: const Color(0xFF5365F5),
            title: 'Manage Referrals',
            subtitle: '2 pending review',
            onTap: onManageReferrals,
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF092942),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1B4968),
          width: 0.8,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
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
