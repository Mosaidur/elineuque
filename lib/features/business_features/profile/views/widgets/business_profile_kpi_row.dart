import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class BusinessProfileKpiRow extends StatelessWidget {
  final int referrals;
  final int converted;
  final String revenue;

  const BusinessProfileKpiRow({
    super.key,
    required this.referrals,
    required this.converted,
    required this.revenue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatCard('$referrals', 'Referrals'),
        const SizedBox(width: 10),
        _buildStatCard('$converted', 'Converted'),
        const SizedBox(width: 10),
        _buildStatCard(revenue, 'Revenue'),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF092942),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF1B4968),
            width: 0.8,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: AppColors.businessPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
