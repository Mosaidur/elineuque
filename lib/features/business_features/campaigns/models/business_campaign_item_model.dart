enum BusinessCampaignStatus {
  active,
  paused,
}

class BusinessCampaignItemModel {
  final String id;
  final String title;
  final int rewardPerPurchase;
  final String? customerOffer;
  final int minimumSpend;
  final String? endDate;
  final String referralLink;
  final int sharedCount;
  final int purchasedCount;
  final int conversionRate;
  final BusinessCampaignStatus status;

  const BusinessCampaignItemModel({
    required this.id,
    required this.title,
    required this.rewardPerPurchase,
    this.customerOffer,
    this.minimumSpend = 0,
    this.endDate,
    required this.referralLink,
    required this.sharedCount,
    required this.purchasedCount,
    required this.conversionRate,
    this.status = BusinessCampaignStatus.active,
  });

  BusinessCampaignItemModel copyWith({
    String? id,
    String? title,
    int? rewardPerPurchase,
    String? customerOffer,
    int? minimumSpend,
    String? endDate,
    String? referralLink,
    int? sharedCount,
    int? purchasedCount,
    int? conversionRate,
    BusinessCampaignStatus? status,
  }) {
    return BusinessCampaignItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      rewardPerPurchase: rewardPerPurchase ?? this.rewardPerPurchase,
      customerOffer: customerOffer ?? this.customerOffer,
      minimumSpend: minimumSpend ?? this.minimumSpend,
      endDate: endDate ?? this.endDate,
      referralLink: referralLink ?? this.referralLink,
      sharedCount: sharedCount ?? this.sharedCount,
      purchasedCount: purchasedCount ?? this.purchasedCount,
      conversionRate: conversionRate ?? this.conversionRate,
      status: status ?? this.status,
    );
  }
}
