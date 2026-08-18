import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class EditProfileCard extends StatelessWidget {
  final TextEditingController fullNameCtrl;
  final TextEditingController handleCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController bioCtrl;

  const EditProfileCard({
    super.key,
    required this.fullNameCtrl,
    required this.handleCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.bioCtrl,
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
            'EDIT PROFILE',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 14),

          // 1. Full Name Input
          _buildFieldLabel('Full Name'),
          const SizedBox(height: 6),
          _buildInputField(
            controller: fullNameCtrl,
            icon: Icons.person_outline,
            hintText: 'Full Name',
          ),

          const SizedBox(height: 14),

          // 2. Username / Handle Input
          _buildFieldLabel('Username / Handle'),
          const SizedBox(height: 6),
          _buildInputField(
            controller: handleCtrl,
            icon: Icons.alternate_email,
            hintText: '@username',
          ),

          const SizedBox(height: 14),

          // 3. Email Input
          _buildFieldLabel('Email'),
          const SizedBox(height: 6),
          _buildInputField(
            controller: emailCtrl,
            icon: Icons.mail_outline,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 14),

          // 4. Phone Input
          _buildFieldLabel('Phone'),
          const SizedBox(height: 6),
          _buildInputField(
            controller: phoneCtrl,
            icon: Icons.phone_outlined,
            hintText: '+1 555 000 0000',
            keyboardType: TextInputType.phone,
          ),

          const SizedBox(height: 14),

          // 5. Bio Input
          _buildFieldLabel('Bio'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF071F34),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF184160),
                width: 0.8,
              ),
            ),
            child: TextField(
              controller: bioCtrl,
              maxLines: 3,
              minLines: 3,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Tell people about yourself...',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 11.5,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 44,
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
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
