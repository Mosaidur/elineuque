import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';
import '../../models/business_campaign_item_model.dart';

class CampaignCardWidget extends StatelessWidget {
  final BusinessCampaignItemModel campaign;
  final VoidCallback onTap;
  final VoidCallback? onTogglePause;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onCopyLink;

  const CampaignCardWidget({
    super.key,
    required this.campaign,
    required this.onTap,
    this.onTogglePause,
    this.onEdit,
    this.onDelete,
    this.onCopyLink,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = campaign.status == BusinessCampaignStatus.active;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF092942),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF1B4968),
            width: 0.8,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Top Row: Title & Status Badge ──
            Row(
              children: [
                Expanded(
                  child: Text(
                    campaign.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.businessPrimary.withValues(alpha: 0.15)
                        : const Color(0xFF223547),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isActive
                          ? AppColors.businessPrimary.withValues(alpha: 0.4)
                          : const Color(0xFF3B5672),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    isActive ? '● ACTIVE' : '❚❚ PAUSED',
                    style: TextStyle(
                      color: isActive
                          ? AppColors.businessPrimary
                          : const Color(0xFF8BB5DA),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            // ── 2. Subtitle: Validity / End Date ──
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 13,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  campaign.endDate != null ? campaign.endDate! : 'Ongoing',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── 3. Key Highlight Pills (Promoter Reward, Customer Offer, Min Spend) ──
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                // Promoter Reward Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.businessPrimary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.businessPrimary.withValues(alpha: 0.25),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.payments_outlined,
                        size: 13,
                        color: AppColors.businessPrimary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '\$${campaign.rewardPerPurchase} / referral',
                        style: const TextStyle(
                          color: AppColors.businessPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                // Customer Offer Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5365F5).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF5365F5).withValues(alpha: 0.3),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.card_giftcard_rounded,
                        size: 13,
                        color: Color(0xFF8692FA),
                      ),
                      const SizedBox(width: 4),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 150),
                        child: Text(
                          campaign.customerOffer?.isNotEmpty == true
                              ? campaign.customerOffer!
                              : 'Special Offer',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF8692FA),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Rule: Min Spend Pill
                if (campaign.minimumSpend > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.rule_folder_outlined,
                          size: 13,
                          color: Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Min: \$${campaign.minimumSpend}',
                          style: const TextStyle(
                            color: Color(0xFFF59E0B),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(color: Color(0xFF184160), height: 1),
            const SizedBox(height: 8),

            // ── 4. Footer: Quick Stats & View Details CTA ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildMiniStat('Shared', '${campaign.sharedCount}'),
                    const SizedBox(width: 10),
                    _buildMiniStat('Purchased', '${campaign.purchasedCount}'),
                    const SizedBox(width: 10),
                    _buildMiniStat('Rate', '${campaign.conversionRate}%'),
                  ],
                ),
                const Row(
                  children: [
                    Text(
                      'Details',
                      style: TextStyle(
                        color: AppColors.businessPrimary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 3),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10,
                      color: AppColors.businessPrimary,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10.5,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
