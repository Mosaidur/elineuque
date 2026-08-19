import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class ReferralFilterTabs extends StatelessWidget {
  final String selectedFilter;
  final int allCount;
  final int pendingCount;
  final int verifiedCount;
  final int paidCount;
  final ValueChanged<String> onFilterSelected;

  const ReferralFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.allCount,
    required this.pendingCount,
    required this.verifiedCount,
    required this.paidCount,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildFilterPill(
          filterKey: 'all',
          count: allCount,
          label: 'All',
        ),
        const SizedBox(width: 8),
        _buildFilterPill(
          filterKey: 'pending',
          count: pendingCount,
          label: 'Pending',
        ),
        const SizedBox(width: 8),
        _buildFilterPill(
          filterKey: 'verified',
          count: verifiedCount,
          label: 'Verified',
        ),
        const SizedBox(width: 8),
        _buildFilterPill(
          filterKey: 'paid',
          count: paidCount,
          label: 'Paid',
        ),
      ],
    );
  }

  Widget _buildFilterPill({
    required String filterKey,
    required int count,
    required String label,
  }) {
    final isSelected = selectedFilter == filterKey;

    return Expanded(
      child: GestureDetector(
        onTap: () => onFilterSelected(filterKey),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF5365F5) : const Color(0xFF092942),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF5365F5)
                  : const Color(0xFF1B4968),
              width: 0.8,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$count',
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
