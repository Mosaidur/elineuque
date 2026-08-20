class QrVerificationResultModel {
  final String businessName;
  final String timestamp;
  final String referralCode;
  final String promoterName;
  final String promoterInitials;
  final String customerType;
  final String rewardAmount;
  bool isRewardPaid;

  QrVerificationResultModel({
    required this.businessName,
    required this.timestamp,
    required this.referralCode,
    required this.promoterName,
    required this.promoterInitials,
    required this.customerType,
    required this.rewardAmount,
    this.isRewardPaid = false,
  });
}
