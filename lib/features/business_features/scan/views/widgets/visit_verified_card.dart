import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';
import '../../models/qr_verification_result_model.dart';

class VisitVerifiedCard extends StatelessWidget {
  final QrVerificationResultModel result;
  final VoidCallback onMarkPaid;
  final VoidCallback onScanAnother;

  const VisitVerifiedCard({
    super.key,
    required this.result,
    required this.onMarkPaid,
    required this.onScanAnother,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),

        // Big Verified Checkmark Circle Icon
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFF143B39),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.businessPrimary.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.check_circle_rounded,
              size: 40,
              color: AppColors.businessPrimary,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Title & Subtitle
        const Text(
          'Visit Verified!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Referral confirmed & reward triggered',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.5,
          ),
        ),

        const SizedBox(height: 24),

        // Verification Receipt Container
        Container(
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
            children: [
              // Top Business Row
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF193D64),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.fitness_center,
                      size: 20,
                      color: Color(0xFF42A5F5),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.businessName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          result.timestamp,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // VERIFIED Badge Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF143B39),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'VERIFIED',
                      style: TextStyle(
                        color: AppColors.businessPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(color: Color(0xFF133650), height: 1),
              const SizedBox(height: 14),

              // Detail Row 1: Referral Code
              _buildDataRow(
                label: 'Referral Code',
                valueChild: Text(
                  result.referralCode,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Detail Row 2: Promoter
              _buildDataRow(
                label: 'Promoter',
                valueChild: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Color(0xFF5365F5),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          result.promoterInitials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      result.promoterName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Detail Row 3: Customer
              _buildDataRow(
                label: 'Customer',
                valueChild: Text(
                  result.customerType,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Divider(color: Color(0xFF133650), height: 1),
              const SizedBox(height: 14),

              // Bottom Row: Reward Triggered
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reward Triggered',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    result.rewardAmount,
                    style: const TextStyle(
                      color: AppColors.businessPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Primary Action: Mark Reward as Paid
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: onMarkPaid,
            style: ElevatedButton.styleFrom(
              backgroundColor: result.isRewardPaid
                  ? const Color(0xFF153C32)
                  : AppColors.businessPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              result.isRewardPaid
                  ? 'Reward Paid ✓'
                  : 'Mark Reward as Paid → ${result.promoterName}',
              style: TextStyle(
                color: result.isRewardPaid
                    ? AppColors.businessPrimary
                    : Colors.black,
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Secondary Action: Scan Another QR
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: onScanAnother,
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFF092942),
              side: const BorderSide(
                color: Color(0xFF1B4968),
                width: 0.8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              'Scan Another QR',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataRow({
    required String label,
    required Widget valueChild,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        valueChild,
      ],
    );
  }
}
