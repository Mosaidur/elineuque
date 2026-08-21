import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class BusinessProfileHeader extends StatelessWidget {
  final String name;
  final String category;
  final String location;
  final VoidCallback onEdit;

  const BusinessProfileHeader({
    super.key,
    required this.name,
    required this.category,
    required this.location,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Business Avatar
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF0F2F48),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF1D4E78),
              width: 1,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.fitness_center_rounded,
              color: Color(0xFF42A5F5),
              size: 26,
            ),
          ),
        ),

        const SizedBox(width: 14),

        // Business Name & Location
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.circle,
                    size: 7,
                    color: AppColors.businessPrimary,
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                '$category · $location',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Edit Pencil Button
        GestureDetector(
          onTap: onEdit,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF092942),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF1B4968),
                width: 0.8,
              ),
            ),
            child: const Icon(
              Icons.edit_outlined,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
