import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class BasicTabView extends StatelessWidget {
  final bool isLogoUploaded;
  final VoidCallback onUploadLogo;
  final VoidCallback onRemoveLogo;
  final TextEditingController businessNameController;
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;
  final TextEditingController descriptionController;

  const BasicTabView({
    super.key,
    required this.isLogoUploaded,
    required this.onUploadLogo,
    required this.onRemoveLogo,
    required this.businessNameController,
    required this.categories,
    required this.selectedCategory,
    required this.onSelectCategory,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. Business Logo Section ──
        const Text(
          'Business Logo',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo Container / Preview
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF071F34),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isLogoUploaded
                      ? AppColors.businessPrimary
                      : const Color(0xFF1B4968),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: isLogoUploaded
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: AppColors.businessPrimary,
                                width: 0.8,
                              ),
                            ),
                            child: const Text(
                              'eliv\napp',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.businessPrimary,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Icon(
                        Icons.business,
                        color: AppColors.textSecondary,
                        size: 28,
                      ),
              ),
            ),

            const SizedBox(width: 14),

            // Action Buttons
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Upload Logo Button
                  GestureDetector(
                    onTap: onUploadLogo,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      decoration: BoxDecoration(
                        color: const Color(0xFF133252),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF1D4E7C),
                          width: 0.8,
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.file_upload_outlined,
                            size: 18,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Upload Logo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Remove Photo Text
                  GestureDetector(
                    onTap: onRemoveLogo,
                    child: const Text(
                      'Remove photo',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Supported format hint
                  const Text(
                    'JPG, PNG or GIF · Max 5MB',
                    style: TextStyle(
                      color: Color(0xFF5A809E),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // ── 2. Business Name Section ──
        const Text(
          'Business Name',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        Container(
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
              const Icon(
                Icons.domain_outlined,
                size: 20,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: businessNameController,
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

        const SizedBox(height: 20),

        // ── 3. Category Section ──
        const Text(
          'Category',
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
          children: categories.map((cat) {
            final isSelected = cat == selectedCategory;

            return GestureDetector(
              onTap: () => onSelectCategory(cat),
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
                  cat,
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

        const SizedBox(height: 20),

        // ── 4. About / Description Section ──
        const Text(
          'About / Description',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF071F34),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF184160),
              width: 0.8,
            ),
          ),
          child: TextField(
            controller: descriptionController,
            minLines: 4,
            maxLines: 6,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.4,
            ),
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText:
                  'Describe your business and what referred customers receive...',
              hintStyle: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.5,
              ),
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}
