import 'package:flutter/material.dart';

class NotificationItemModel {
  final String id;
  final String title;
  final String message;
  final String type; // 'REFERRAL', 'PAYOUT', 'CAMPAIGN', 'SYSTEM'
  final bool isRead;
  final DateTime createdAt;

  const NotificationItemModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate = DateTime.now();
    if (json['createdAt'] != null) {
      parsedDate = DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now();
    }

    return NotificationItemModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Platform Alert',
      message: json['message']?.toString() ?? json['body']?.toString() ?? '',
      type: (json['type']?.toString() ?? 'SYSTEM').toUpperCase(),
      isRead: json['isRead'] == true || json['read'] == true,
      createdAt: parsedDate,
    );
  }

  NotificationItemModel copyWith({bool? isRead}) {
    return NotificationItemModel(
      id: id,
      title: title,
      message: message,
      type: type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${createdAt.month}/${createdAt.day}';
  }

  IconData get icon {
    switch (type) {
      case 'REFERRAL':
        return Icons.qr_code_scanner_rounded;
      case 'PAYOUT':
      case 'REWARD':
        return Icons.account_balance_wallet_rounded;
      case 'CAMPAIGN':
        return Icons.campaign_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }

  Color get iconColor {
    switch (type) {
      case 'REFERRAL':
        return const Color(0xFFC7F556);
      case 'PAYOUT':
      case 'REWARD':
        return const Color(0xFF52E385);
      case 'CAMPAIGN':
        return const Color(0xFFFFA726);
      default:
        return const Color(0xFF7E9EFF);
    }
  }
}
