import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';
import '../../models/business_top_promoter_model.dart';

class ActivePromotersSection extends StatelessWidget {
  final List<BusinessTopPromoterModel> promoters;

  const ActivePromotersSection({
    super.key,
    required this.promoters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Active Promoters',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '${promoters.length} referrers',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11.5,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ── Promoters List ──
        Column(
          children: promoters.map((promoter) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF092942),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF1B4968),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    // Rank Medal or Number Badge
                    SizedBox(
                      width: 24,
                      child: Center(
                        child: _buildRankBadge(promoter.rank),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Avatar Circle
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFF193D64),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: promoter.avatarEmoji != null
                            ? Text(
                                promoter.avatarEmoji!,
                                style: const TextStyle(fontSize: 18),
                              )
                            : Text(
                                promoter.initials,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Name & Handle + Ref count
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            promoter.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${promoter.handle} · ${promoter.referralsCount} refs',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Earnings & Conversions
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${promoter.totalEarnings}',
                          style: const TextStyle(
                            color: AppColors.businessPrimary,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${promoter.conversionsCount} conv.',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRankBadge(int rank) {
    switch (rank) {
      case 1:
        return const Text('🥇', style: TextStyle(fontSize: 14));
      case 2:
        return const Text('🥈', style: TextStyle(fontSize: 14));
      case 3:
        return const Text('🥉', style: TextStyle(fontSize: 14));
      default:
        return Text(
          '#$rank',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        );
    }
  }
}
