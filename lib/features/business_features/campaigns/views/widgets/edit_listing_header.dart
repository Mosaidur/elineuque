import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class EditListingHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSave;

  const EditListingHeader({
    super.key,
    required this.onBack,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Back Button
        GestureDetector(
          onTap: onBack,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF092942),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF1B4968),
                width: 0.8,
              ),
            ),
            child: const Icon(
              Icons.arrow_back,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(width: 14),

        // Title & Subtitle
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Listing',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'What promoters see about your business',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ),

        // Save Button
        ElevatedButton(
          onPressed: onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.businessPrimary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'Save',
            style: TextStyle(
              color: Colors.black,
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
