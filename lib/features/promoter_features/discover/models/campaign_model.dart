class CampaignModel {
  final String id;
  final String title;
  final String rewardAmount;
  final String rewardSuffix;
  final String description;
  final String endsDate;
  final String promotersCount;
  final bool isActive;

  const CampaignModel({
    required this.id,
    required this.title,
    required this.rewardAmount,
    this.rewardSuffix = 'per conversion',
    required this.description,
    required this.endsDate,
    required this.promotersCount,
    this.isActive = true,
  });
}
