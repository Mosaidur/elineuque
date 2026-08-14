import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class ReferralStatCards extends StatelessWidget {
  final String shared;
  final String pending;
  final String converted;

  const ReferralStatCards({
    super.key,
    required this.shared,
    required this.pending,
    required this.converted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            count: shared,
            label: 'Shared',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            count: pending,
            label: 'Pending',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            count: converted,
            label: 'Converted',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String count;
  final String label;

  const _StatCard({
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 0.8,
        ),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
