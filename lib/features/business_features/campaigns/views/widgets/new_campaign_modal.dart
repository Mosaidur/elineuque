import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class NewCampaignModal extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController rewardController;
  final TextEditingController offerController;
  final TextEditingController minimumSpendController;
  final TextEditingController endDateController;
  final bool isEditing;
  final VoidCallback onSave;

  const NewCampaignModal({
    super.key,
    required this.titleController,
    required this.rewardController,
    required this.offerController,
    required this.minimumSpendController,
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

            // ── Field 2: Promoter Reward ($) ──
            Row(
              children: [
                const Icon(Icons.payments_outlined, size: 16, color: AppColors.businessPrimary),
                const SizedBox(width: 6),
                const Text(
                  'Promoter Reward (\$ per referral)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            const Text(
              'Commission paid to the promoter when a referred customer purchases',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 8),
            _buildInputField(
              controller: rewardController,
              hintText: 'e.g. 10 (or 20, 40)',
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            // ── Field 3: Customer Offer / Discount ──
            Row(
              children: [
                const Icon(Icons.card_giftcard_rounded, size: 16, color: Color(0xFF5365F5)),
                const SizedBox(width: 6),
                const Text(
                  'Customer Offer / Discount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            const Text(
              'Incentive the referred customer receives at checkout (e.g. discount, gift)',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
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
                minLines: 2,
                maxLines: 3,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                ),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      'e.g. 15% discount on total bill, or Free gift with purchase',
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

            // ── Field 4: Rules & Conditions: Minimum Spend / Purchase ($) ──
            Row(
              children: [
                const Icon(Icons.rule_folder_outlined, size: 16, color: Color(0xFFF59E0B)),
                const SizedBox(width: 6),
                const Text(
                  'Rule: Minimum Purchase / Spend (\$)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            const Text(
              'Customer must spend at least this bill amount for referral to qualify (0 = no minimum)',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 8),
            _buildInputField(
              controller: minimumSpendController,
              hintText: 'e.g. 50 (enter 0 for any purchase)',
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            // ── Field 5: End Date (optional) ──
            const Text(
              'End Date (optional)',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: now.add(const Duration(days: 30)),
                  firstDate: now,
                  lastDate: now.add(const Duration(days: 365)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: AppColors.businessPrimary,
                          onPrimary: Colors.black,
                          surface: Color(0xFF1E2228),
                          onSurface: Colors.white,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  endDateController.text =
                      '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                }
              },
              child: Container(
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
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        endDateController.text.isEmpty
                            ? 'Select expiry date (e.g. 30 days from now)'
                            : endDateController.text,
                        style: TextStyle(
                          color: endDateController.text.isEmpty
                              ? const Color(0xFF7A8699)
                              : Colors.white,
                          fontSize: 13.5,
                          fontWeight: endDateController.text.isEmpty
                              ? FontWeight.w400
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 18,
                      color: AppColors.businessPrimary,
                    ),
                  ],
                ),
              ),
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
