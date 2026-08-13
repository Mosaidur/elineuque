import 'package:flutter/material.dart';

enum ReferralStatus { paid, pending }

class RecentReferral {
  final String name;
  final String initials;
  final Color avatarColor;
  final String businessName;
  final String timeAgo;
  final String amount;
  final ReferralStatus status;

  const RecentReferral({
    required this.name,
    required this.initials,
    required this.avatarColor,
    required this.businessName,
    required this.timeAgo,
    required this.amount,
    required this.status,
  });
}
