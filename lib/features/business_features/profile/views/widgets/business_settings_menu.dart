import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class BusinessSettingsMenu extends StatelessWidget {
  final VoidCallback onEditListing;
  final VoidCallback onNotificationPreferences;
  final VoidCallback onPaymentAndPayouts;
  final VoidCallback onHelpAndSupport;

  const BusinessSettingsMenu({
    super.key,
    required this.onEditListing,
    required this.onNotificationPreferences,
    required this.onPaymentAndPayouts,
    required this.onHelpAndSupport,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.edit_note_rounded,
          title: 'Edit Business Listing',
          onTap: onEditListing,
        ),
        const SizedBox(height: 8),
        _buildMenuItem(
          icon: Icons.notifications_none_rounded,
          title: 'Notification Preferences',
          onTap: onNotificationPreferences,
        ),
        const SizedBox(height: 8),
        _buildMenuItem(
          icon: Icons.credit_card_rounded,
          title: 'Payment & Payouts',
          onTap: onPaymentAndPayouts,
        ),
        const SizedBox(height: 8),
        _buildMenuItem(
          icon: Icons.help_outline_rounded,
          title: 'Help & Support',
          onTap: onHelpAndSupport,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF092942),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF1B4968),
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
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
