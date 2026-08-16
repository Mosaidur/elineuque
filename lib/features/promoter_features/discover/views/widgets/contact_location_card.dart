import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class ContactLocationCard extends StatelessWidget {
  final String location;
  final String hours;
  final String website;

  const ContactLocationCard({
    super.key,
    required this.location,
    required this.hours,
    required this.website,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF092942),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1B4968),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CONTACT & LOCATION',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 14),
          _buildItem(
            icon: Icons.location_on_outlined,
            text: location,
          ),
          const SizedBox(height: 12),
          _buildItem(
            icon: Icons.access_time_rounded,
            text: hours,
          ),
          const SizedBox(height: 12),
          _buildItem(
            icon: Icons.language_rounded,
            text: website,
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFF163750),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 15,
            color: const Color(0xFF8EA5BB),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
