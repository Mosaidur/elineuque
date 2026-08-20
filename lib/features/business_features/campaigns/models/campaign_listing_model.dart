class CampaignListingModel {
  final String businessName;
  final String category;
  final String description;
  final String address;
  final String phoneNumber;
  final String website;
  final String openingHours;
  final int rewardAmount;
  final int activePromoters;
  final String? logoPath;

  CampaignListingModel({
    required this.businessName,
    required this.category,
    required this.description,
    required this.address,
    required this.phoneNumber,
    required this.website,
    required this.openingHours,
    required this.rewardAmount,
    this.activePromoters = 128,
    this.logoPath,
  });

  CampaignListingModel copyWith({
    String? businessName,
    String? category,
    String? description,
    String? address,
    String? phoneNumber,
    String? website,
    String? openingHours,
    int? rewardAmount,
    int? activePromoters,
    String? logoPath,
  }) {
    return CampaignListingModel(
      businessName: businessName ?? this.businessName,
      category: category ?? this.category,
      description: description ?? this.description,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      openingHours: openingHours ?? this.openingHours,
      rewardAmount: rewardAmount ?? this.rewardAmount,
      activePromoters: activePromoters ?? this.activePromoters,
      logoPath: logoPath ?? this.logoPath,
    );
  }
}
