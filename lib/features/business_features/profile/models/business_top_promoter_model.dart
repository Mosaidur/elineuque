class BusinessTopPromoterModel {
  final int rank;
  final String name;
  final String handle;
  final int referralsCount;
  final int totalEarnings;
  final int conversionsCount;
  final String? avatarEmoji;
  final String initials;

  const BusinessTopPromoterModel({
    required this.rank,
    required this.name,
    required this.handle,
    required this.referralsCount,
    required this.totalEarnings,
    required this.conversionsCount,
    this.avatarEmoji,
    required this.initials,
  });
}
