import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';
import '../../models/referral_activity_model.dart';

class ActivityTimelineCard extends StatelessWidget {
  final ReferralActivityItem item;
  final VoidCallback? onShareAgain;

  const ActivityTimelineCard({
    super.key,
    required this.item,
    this.onShareAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              // Avatar
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: item.iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: item.iconColor.withValues(alpha: 0.3),
                    width: 0.8,
                  ),
                ),
                child: Icon(
                  item.icon,
                  size: 20,
                  color: item.iconColor,
                ),
              ),

              const SizedBox(width: 10),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.businessName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.friendName} · ${item.timeAgo}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11.5,
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
                    item.amount,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  _buildStatusBadge(item.status),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 4-Step Timeline
          _buildActivityTimeline(item.currentStep),

          // Optional "Share Link Again" button
          if (item.canShareAgain) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 38,
              child: ElevatedButton(
                onPressed: onShareAgain,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.businessPrimary,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: const Text(
                  'Share Link Again →',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ActivityStatus status) {
    Color bgColor;
    Color textColor;
    Color borderColor;

    switch (status) {
      case ActivityStatus.paid:
        bgColor = const Color(0xFF193B33);
        textColor = AppColors.businessPrimary;
        borderColor = const Color(0xFF235C4E);
        break;
      case ActivityStatus.verified:
        bgColor = const Color(0xFF154148);
        textColor = const Color(0xFF5DF2D6);
        borderColor = const Color(0xFF1E636E);
        break;
      case ActivityStatus.pending:
        bgColor = const Color(0xFF3B301F);
        textColor = const Color(0xFFFFB74D);
        borderColor = const Color(0xFF6B4E22);
        break;
      case ActivityStatus.shared:
        bgColor = const Color(0xFF1F3547);
        textColor = AppColors.textSecondary;
        borderColor = const Color(0xFF2C435A);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: borderColor,
          width: 0.6,
        ),
      ),
      child: Text(
        item.statusLabel,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActivityTimeline(int currentStep) {
    const steps = ['Shared', 'Visited', 'Verified', 'Paid'];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          _buildNode(
            stepNumber: i + 1,
            label: steps[i],
            currentStep: currentStep,
          ),
          if (i < steps.length - 1)
            Expanded(
              child: Container(
                height: 1.5,
                margin: const EdgeInsets.only(top: 11),
                color: (i + 1) < currentStep
                    ? AppColors.businessPrimary
                    : const Color(0xFF264764),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildNode({
    required int stepNumber,
    required String label,
    required int currentStep,
  }) {
    final bool isPassed = stepNumber < currentStep;
    final bool isCurrent = stepNumber == currentStep;

    Color circleBg;
    Widget centerWidget;

    if (isPassed) {
      circleBg = AppColors.businessPrimary;
      centerWidget = const Icon(
        Icons.check,
        size: 13,
        color: Colors.black,
      );
    } else if (isCurrent) {
      circleBg = AppColors.businessPrimary;
      centerWidget = Text(
        '$stepNumber',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      );
    } else {
      circleBg = const Color(0xFF1B3B52);
      centerWidget = Text(
        '$stepNumber',
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return SizedBox(
      width: 48,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: circleBg,
              shape: BoxShape.circle,
            ),
            child: Center(child: centerWidget),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isCurrent || isPassed
                  ? Colors.white
                  : AppColors.textSecondary,
              fontSize: 9.5,
              fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
