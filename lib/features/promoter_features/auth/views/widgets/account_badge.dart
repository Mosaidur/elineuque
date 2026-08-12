import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';
import '../../../../../core/enums/auth_role.dart';


class AccountBadge extends StatelessWidget {
  final AuthRole role;

  const AccountBadge({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final bool isBusiness = role == AuthRole.business;

    final Color color = isBusiness
        ? AppColors.businessPrimary
        : AppColors.promoterPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isBusiness
                ? Icons.business_outlined
                : Icons.people_outline,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            isBusiness
                ? 'Business Account'
                : 'Promoter Account',
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}