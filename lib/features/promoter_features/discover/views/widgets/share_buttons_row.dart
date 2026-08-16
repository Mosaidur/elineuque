import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class ShareButtonsRow extends StatelessWidget {
  final ValueChanged<String> onShare;

  const ShareButtonsRow({
    super.key,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ShareItem(
            icon: Icons.chat_bubble_outline,
            label: 'WhatsApp',
            onTap: () => onShare('WhatsApp'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ShareItem(
            icon: Icons.camera_alt_outlined,
            label: 'Instagram',
            onTap: () => onShare('Instagram'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ShareItem(
            icon: Icons.sms_outlined,
            label: 'SMS',
            onTap: () => onShare('SMS'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ShareItem(
            icon: Icons.more_horiz,
            label: 'More',
            onTap: () => onShare('More Apps'),
          ),
        ),
      ],
    );
  }
}

class _ShareItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ShareItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF092942),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF1B4968),
              width: 0.8,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: Colors.white,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
