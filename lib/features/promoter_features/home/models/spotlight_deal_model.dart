class SpotlightDeal {
  final String title;
  final String description;
  final String category;
  final String rewardAmount;
  final String rewardDescription;
  final String promotersActive;
  final String imageUrl;
  final bool isHot;

  const SpotlightDeal({
    required this.title,
    required this.description,
    required this.category,
    required this.rewardAmount,
    required this.rewardDescription,
    required this.promotersActive,
    this.imageUrl = '',
    this.isHot = true,
  });
}
