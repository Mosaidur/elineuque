import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class ReferralJourneyGuide extends StatelessWidget {
  const ReferralJourneyGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF092942),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1B4968),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'REFERRAL JOURNEY',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),

          const SizedBox(height: 16),

          // 4-Step Progress Indicator
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step 1: You Share Link (Completed)
              _buildStepItem(
                isCompleted: true,
                isActive: false,
                stepNumber: '1',
                label: 'You\nShare Link',
              ),
              _buildConnectingLine(isDone: true),

              // Step 2: Friend Clicks (Completed)
              _buildStepItem(
                isCompleted: true,
                isActive: false,
                stepNumber: '2',
                label: 'Friend\nClicks',
              ),
              _buildConnectingLine(isDone: true),

              // Step 3: Friend Buys (Active)
              _buildStepItem(
                isCompleted: false,
                isActive: true,
                stepNumber: '3',
                label: 'Friend\nBuys',
              ),
              _buildConnectingLine(isDone: false),

              // Step 4: You Earn (Inactive)
              _buildStepItem(
                isCompleted: false,
                isActive: false,
                stepNumber: '4',
                label: 'You\nEarn',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Note
          const Center(
            child: Text(
              'You only earn when your friend actually makes a purchase',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required bool isCompleted,
    required bool isActive,
    required String stepNumber,
    required String label,
  }) {
    Color circleBg;
    Widget centerContent;

    if (isCompleted) {
      circleBg = AppColors.businessPrimary;
      centerContent = const Icon(
        Icons.check,
        size: 14,
        color: Colors.black,
      );
    } else if (isActive) {
      circleBg = AppColors.businessPrimary;
      centerContent = Text(
        stepNumber,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      );
    } else {
      circleBg = const Color(0xFF1B3B52);
      centerContent = Text(
        stepNumber,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return SizedBox(
      width: 58,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: circleBg,
              shape: BoxShape.circle,
            ),
            child: Center(child: centerContent),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 9.5,
              height: 1.2,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectingLine({required bool isDone}) {
    return Expanded(
      child: Container(
        height: 1.5,
        margin: const EdgeInsets.only(top: 13),
        color: isDone ? AppColors.businessPrimary : const Color(0xFF264764),
      ),
    );
  }
}
