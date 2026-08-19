import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';
import '../../models/business_referral_model.dart';

class ReferralCardItem extends StatelessWidget {
  final BusinessReferralModel item;
  final VoidCallback onVerify;
  final VoidCallback onReject;
  final VoidCallback onMarkPaid;

  const ReferralCardItem({
    super.key,
    required this.item,
    required this.onVerify,
    required this.onReject,
    required this.onMarkPaid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          // ── Top Row: Avatar, Names, Status Badge ──
          Row(
            children: [
              // Avatar
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFF193D64),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: item.avatarEmoji != null
                      ? Text(
                          item.avatarEmoji!,
                          style: const TextStyle(fontSize: 20),
                        )
                      : Text(
                          item.promoterInitials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ),

              const SizedBox(width: 12),

              // Names & Time Ago
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.promoterName} → ${item.customerName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.timeAgo,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Status Badge Pill
              _buildStatusBadge(item.status),
            ],
          ),

          const SizedBox(height: 12),

          // ── Bottom Row: Reward Amount & Actions ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Reward Rate
              Text(
                'Reward: \$${item.rewardAmount}',
                style: const TextStyle(
                  color: AppColors.businessPrimary,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),

              // Actions according to status
              _buildActionSection(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BusinessReferralStatus status) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case BusinessReferralStatus.verified:
        bg = const Color(0xFF1E3368);
        fg = const Color(0xFF7090FF);
        label = 'verified';
        break;
      case BusinessReferralStatus.pending:
        bg = const Color(0xFF382E18);
        fg = const Color(0xFFFFB74D);
        label = 'pending';
        break;
      case BusinessReferralStatus.paid:
        bg = const Color(0xFF143B39);
        fg = AppColors.businessPrimary;
        label = 'paid';
        break;
      case BusinessReferralStatus.rejected:
        bg = const Color(0xFF3A1F28);
        fg = const Color(0xFFEF5350);
        label = 'rejected';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildActionSection() {
    switch (item.status) {
      case BusinessReferralStatus.verified:
        return GestureDetector(
          onTap: onMarkPaid,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.businessPrimary,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 14,
                  color: Colors.black,
                ),
                SizedBox(width: 5),
                Text(
                  'Mark Paid',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        );

      case BusinessReferralStatus.pending:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reject Button
            GestureDetector(
              onTap: onReject,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A1F28),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF5C2534),
                    width: 0.8,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.highlight_off_rounded,
                      size: 13,
                      color: Color(0xFFEF5350),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Reject',
                      style: TextStyle(
                        color: Color(0xFFEF5350),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Verify Button
            GestureDetector(
              onTap: onVerify,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF5365F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 13,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Verify',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );

      case BusinessReferralStatus.paid:
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check,
              size: 14,
              color: AppColors.businessPrimary,
            ),
            SizedBox(width: 4),
            Text(
              'Paid out',
              style: TextStyle(
                color: AppColors.businessPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );

      case BusinessReferralStatus.rejected:
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.close,
              size: 14,
              color: Color(0xFFEF5350),
            ),
            SizedBox(width: 4),
            Text(
              'Rejected',
              style: TextStyle(
                color: Color(0xFFEF5350),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
    }
  }
}
