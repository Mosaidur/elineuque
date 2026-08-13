import 'package:flutter/material.dart';

enum ActivityStatus { paid, verified, pending, shared }

class ReferralActivityItem {
  final String businessName;
  final String friendName;
  final String timeAgo;
  final String amount;
  final ActivityStatus status;
  final int currentStep; // 1: Shared, 2: Visited, 3: Verified, 4: Paid
  final bool canShareAgain;
  final IconData icon;
  final Color iconColor;

  const ReferralActivityItem({
    required this.businessName,
    required this.friendName,
    required this.timeAgo,
    required this.amount,
    required this.status,
    required this.currentStep,
    this.canShareAgain = false,
    required this.icon,
    required this.iconColor,
  });

  String get statusLabel {
    switch (status) {
      case ActivityStatus.paid:
        return 'paid';
      case ActivityStatus.verified:
        return 'verified';
      case ActivityStatus.pending:
        return 'pending';
      case ActivityStatus.shared:
        return 'shared';
    }
  }
}
