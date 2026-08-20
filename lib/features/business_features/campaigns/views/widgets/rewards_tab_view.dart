import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class RewardsTabView extends StatelessWidget {
  final int selectedReward;
  final ValueChanged<int> onSelectPresetReward;
  final TextEditingController customRewardController;
  final ValueChanged<String> onCustomRewardChanged;
  final List<int> presetRewards;
  final String businessName;
  final String category;

  const RewardsTabView({
    super.key,
    required this.selectedReward,
    required this.onSelectPresetReward,
    required this.customRewardController,
    required this.onCustomRewardChanged,
    required this.presetRewards,
    required this.businessName,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. REWARD PER REFERRAL CARD ──
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF092942),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFF1B4968),
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'REWARD PER REFERRAL',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),

              const SizedBox(height: 8),

              // Big Amount Text
              Text(
                '\$$selectedReward',
                style: const TextStyle(
                  color: AppColors.businessPrimary,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 2),

              const Text(
                'Paid to promoter when referral converts',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                ),
              ),

              const SizedBox(height: 16),

              // Preset Reward Buttons Wrap
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: presetRewards.map((amount) {
                  final isSelected = amount == selectedReward;

                  return GestureDetector(
                    onTap: () => onSelectPresetReward(amount),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.businessPrimary
                            : const Color(0xFF113859),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.businessPrimary
                              : const Color(0xFF1C4C74),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        '\$$amount',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.black
                              : const Color(0xFF8BB5DA),
                          fontSize: 12.5,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Custom Amount Input Row
              Row(
                children: [
                  const Text(
                    'Custom:',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF071F34),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF184160),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            '\$ ',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: customRewardController,
                              keyboardType: TextInputType.number,
                              onChanged: onCustomRewardChanged,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                              ),
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ── 2. PREVIEW FOR PROMOTERS CARD ──
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF092942),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFF1B4968),
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Preview for Promoters',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 2),

              const Text(
                'This is how your listing card appears',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                ),
              ),

              const SizedBox(height: 14),

              // Live Mini Preview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF071F34),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF184160),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    // Mini Logo
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF051727),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.businessPrimary.withValues(alpha: 0.8),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                              color: AppColors.businessPrimary,
                              width: 0.6,
                            ),
                          ),
                          child: const Text(
                            'eliv\napp',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.businessPrimary,
                              fontSize: 7.5,
                              fontWeight: FontWeight.w800,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Listing Name, Category, Reward Rate
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            businessName.isEmpty ? 'FitZone Gym' : businessName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            category,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '\$$selectedReward',
                                  style: const TextStyle(
                                    color: AppColors.businessPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' / referral',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
