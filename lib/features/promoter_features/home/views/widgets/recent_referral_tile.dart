import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';
import '../../models/recent_referral_model.dart';

class RecentReferralTile extends StatelessWidget {
  final RecentReferral referral;
  final VoidCallback? onTap;

  const RecentReferralTile({
    super.key,
    required this.referral,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPaid = referral.status == ReferralStatus.paid;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 0.8,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Initials Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: referral.avatarColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      referral.initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Name & Business Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        referral.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${referral.businessName} · ${referral.timeAgo}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Amount & Status Badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      referral.amount,
                      style: TextStyle(
                        color: isPaid ? Colors.white : AppColors.textSecondary,
                        fontSize: isPaid ? 13 : 11.5,
                        fontWeight: isPaid ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isPaid
                            ? const Color(0xFF193B33)
                            : const Color(0xFF223547),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isPaid
                              ? const Color(0xFF235C4E)
                              : const Color(0xFF2C435A),
                          width: 0.6,
                        ),
                      ),
                      child: Text(
                        isPaid ? 'paid' : 'pending',
                        style: TextStyle(
                          color: isPaid
                              ? AppColors.businessPrimary
                              : AppColors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
