enum BusinessReferralStatus {
  pending,
  verified,
  paid,
  rejected,
}

class BusinessReferralModel {
  final String id;
  final String promoterName;
  final String customerName;
  final String timeAgo;
  final int rewardAmount;
  final BusinessReferralStatus status;
  final String promoterInitials;
  final String? avatarEmoji;

  const BusinessReferralModel({
    required this.id,
    required this.promoterName,
    required this.customerName,
    required this.timeAgo,
    required this.rewardAmount,
    required this.status,
    required this.promoterInitials,
    this.avatarEmoji,
  });

  BusinessReferralModel copyWith({
    String? id,
    String? promoterName,
    String? customerName,
    String? timeAgo,
    int? rewardAmount,
    BusinessReferralStatus? status,
    String? promoterInitials,
    String? avatarEmoji,
  }) {
    return BusinessReferralModel(
      id: id ?? this.id,
      promoterName: promoterName ?? this.promoterName,
      customerName: customerName ?? this.customerName,
      timeAgo: timeAgo ?? this.timeAgo,
      rewardAmount: rewardAmount ?? this.rewardAmount,
      status: status ?? this.status,
      promoterInitials: promoterInitials ?? this.promoterInitials,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
    );
  }
}
