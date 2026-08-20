import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class NewCampaignModal extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController rewardController;
  final TextEditingController offerController;
  final TextEditingController endDateController;
  final bool isEditing;
  final VoidCallback onSave;

  const NewCampaignModal({
    super.key,
    required this.titleController,
    required this.rewardController,
    required this.offerController,
    required this.endDateController,
    required this.isEditing,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E2228),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Drag Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Header Title
            Text(
              isEditing ? 'Edit Campaign' : 'New Campaign',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 18),

            // ── Field 1: Campaign Title ──
            const Text(
              'Campaign Title',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _buildInputField(
              controller: titleController,
              hintText: 'e.g. Summer Membership Drive',
            ),

            const SizedBox(height: 16),

            // ── Field 2: Reward per Purchase ($) ──
            const Text(
              'Reward per Purchase (\$)',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _buildInputField(
              controller: rewardController,
              hintText: 'e.g. 40',
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            // ── Field 3: Customer Offer (optional) ──
            const Text(
              'Customer Offer (optional)',
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
                color: const Color(0xFF2B3037),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF38404A),
                  width: 0.8,
                ),
              ),
              child: TextField(
                controller: offerController,
                minLines: 3,
                maxLines: 4,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                ),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      'What do referred customers receive?\ne.g. First month 50% off',
                  hintStyle: TextStyle(
                    color: Color(0xFF7A8699),
                    fontSize: 13,
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Field 4: End Date (optional) ──
            const Text(
              'End Date (optional)',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _buildInputField(
              controller: endDateController,
              hintText: 'e.g. Aug 31',
            ),

            const SizedBox(height: 24),

            // ── Submit Button: Create / Update Campaign ──
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.businessPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  isEditing ? 'Save Changes' : 'Create Campaign',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2B3037),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF38404A),
          width: 0.8,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF7A8699),
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
        ),
      ),
    );
  }
}
