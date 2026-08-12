import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';
import '../../models/roles_model.dart';

class RoleCard extends StatelessWidget {
  final RoleOption role;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.role,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconBackground = role.isBusiness
        ? AppColors.iconGreen
        : AppColors.iconBlue;

    final Color iconColor = role.isBusiness
        ? AppColors.businessPrimary
        : Colors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            14,
            14,
            14,
            13,
          ),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconBackground,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      role.isBusiness
                          ? Icons.business_outlined
                          : Icons.people_outline,
                      color: iconColor,
                      size: 21,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      role.title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                role.description,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                  height: 1.45,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: role.tags
                    .map(
                      (tag) => _Tag(
                    text: tag,
                    isBusiness: role.isBusiness,
                  ),
                )
                    .toList(),
              ),

              const SizedBox(height: 9),

              GestureDetector(
                onTap: onTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Get started',
                      style: TextStyle(
                        color: role.isBusiness
                            ? AppColors.businessPrimary
                            : AppColors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: role.isBusiness
                          ? AppColors.businessPrimary
                          : AppColors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final bool isBusiness;

  const _Tag({
    required this.text,
    required this.isBusiness,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isBusiness
            ? AppColors.iconGreen
            : AppColors.iconBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isBusiness
              ? AppColors.businessPrimary
              : Colors.white,
          fontSize: 7.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}