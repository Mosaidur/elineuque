import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class EditListingTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const EditListingTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF071F34),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF133650),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          _buildTabItem(0, 'Basic'),
          _buildTabItem(1, 'Details'),
          _buildTabItem(2, 'Rewards'),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF193D64) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
