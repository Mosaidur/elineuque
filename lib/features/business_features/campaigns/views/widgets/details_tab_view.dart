import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class DetailsTabView extends StatelessWidget {
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final TextEditingController websiteController;
  final List<String> hoursOptions;
  final String selectedHours;
  final ValueChanged<String> onSelectHours;

  const DetailsTabView({
    super.key,
    required this.addressController,
    required this.phoneController,
    required this.websiteController,
    required this.hoursOptions,
    required this.selectedHours,
    required this.onSelectHours,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. Address Section ──
        const Text(
          'Address',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        _buildInputField(
          controller: addressController,
          icon: Icons.location_on_outlined,
        ),

        const SizedBox(height: 18),

        // ── 2. Phone Number Section ──
        const Text(
          'Phone Number',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        _buildInputField(
          controller: phoneController,
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),

        const SizedBox(height: 18),

        // ── 3. Website Section ──
        const Text(
          'Website',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        _buildInputField(
          controller: websiteController,
          icon: Icons.language_outlined,
          keyboardType: TextInputType.url,
        ),

        const SizedBox(height: 20),

        // ── 4. Opening Hours Section ──
        const Text(
          'Opening Hours',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: hoursOptions.map((hour) {
            final isSelected = hour == selectedHours;

            return GestureDetector(
              onTap: () => onSelectHours(hour),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF5365F5)
                      : const Color(0xFF071F34),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF5365F5)
                        : const Color(0xFF184160),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  hour,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF071F34),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF184160),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
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
    );
  }
}
