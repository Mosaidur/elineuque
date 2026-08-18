import 'package:flutter/material.dart';

class LeaderboardUserModel {
  final int rank;
  final String name;
  final String initials;
  final Color avatarColor;
  final int referralsCount;
  final String earnings;
  final bool isCurrentUser;

  const LeaderboardUserModel({
    required this.rank,
    required this.name,
    required this.initials,
    required this.avatarColor,
    required this.referralsCount,
    required this.earnings,
    this.isCurrentUser = false,
  });
}
