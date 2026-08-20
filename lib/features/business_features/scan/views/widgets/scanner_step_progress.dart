import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class ScannerStepProgress extends StatelessWidget {
  const ScannerStepProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Step 1: Promoter Shares (Completed)
        _buildCompletedStep('Promoter\nShares'),

        _buildConnectorLine(isCompleted: true),

        // Step 2: Customer Shows QR (Completed)
        _buildCompletedStep('Customer\nShows QR'),

        _buildConnectorLine(isCompleted: true),

        // Step 3: You Scan (Current Active)
        _buildActiveStep('3', 'You\nScan'),

        _buildConnectorLine(isCompleted: false),

        // Step 4: Pay Reward (Upcoming)
        _buildUpcomingStep('4', 'Pay\nReward'),
      ],
    );
  }

  Widget _buildCompletedStep(String label) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: AppColors.businessPrimary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            size: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 9.5,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveStep(String stepNum, String label) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.businessPrimary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.businessPrimary.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              stepNum,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingStep(String stepNum, String label) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFF0E2E48),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF1B4968),
              width: 0.8,
            ),
          ),
          child: Center(
            child: Text(
              stepNum,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 9.5,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildConnectorLine({required bool isCompleted}) {
    return Expanded(
      child: Container(
        height: 1.5,
        margin: const EdgeInsets.only(bottom: 24, left: 4, right: 4),
        color: isCompleted ? AppColors.businessPrimary : const Color(0xFF1B4968),
      ),
    );
  }
}
