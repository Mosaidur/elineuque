import 'package:flutter/material.dart';

class ProfileBadgeModel {
  final String id;
  final String title;
  final IconData icon;
  final Color iconColor;
  final bool isEarned;

  const ProfileBadgeModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.iconColor,
    this.isEarned = false,
  });
}
