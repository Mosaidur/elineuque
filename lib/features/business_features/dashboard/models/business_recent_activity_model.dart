import 'package:flutter/material.dart';

enum BusinessActivityStatus { verified, pending, paid }

class BusinessRecentActivityModel {
  final String id;
  final String customerName;
  final String actionDetail;
  final String timeAgo;
  final BusinessActivityStatus status;
  final String avatarEmoji;

  const BusinessRecentActivityModel({
    required this.id,
    required this.customerName,
    required this.actionDetail,
    required this.timeAgo,
    required this.status,
    required this.avatarEmoji,
  });

  String get statusLabel => status.name;

  Color get statusBgColor {
    switch (status) {
      case BusinessActivityStatus.verified:
        return const Color(0xFF1D3B6C);
      case BusinessActivityStatus.pending:
        return const Color(0xFF1B2F44);
      case BusinessActivityStatus.paid:
        return const Color(0xFF163C32);
    }
  }

  Color get statusTextColor {
    switch (status) {
      case BusinessActivityStatus.verified:
        return const Color(0xFF5365F5);
      case BusinessActivityStatus.pending:
        return const Color(0xFF8EA5BB);
      case BusinessActivityStatus.paid:
        return const Color(0xFFC8FF5A);
    }
  }
}
