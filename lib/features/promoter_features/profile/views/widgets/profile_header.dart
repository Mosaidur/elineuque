import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String handle;
  final String rank;
  final bool isEditing;
  final VoidCallback onEditTap;
  final VoidCallback onCancelTap;
  final VoidCallback onSaveTap;
  final VoidCallback onChangePhoto;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.handle,
    required this.rank,
    required this.isEditing,
    required this.onEditTap,
    required this.onCancelTap,
    required this.onSaveTap,
    required this.onChangePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar with Camera Badge
        GestureDetector(
          onTap: onChangePhoto,
          child: Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A5A),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF2A4E78),
                    width: 1.5,
                  ),
                ),
                child: const Center(
                  child: Text(
                    '🧑',
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.businessPrimary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.background,
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 11,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 14),

        // Name, Handle, Rank & Change Photo text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Text(
                    handle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '· $rank',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: onChangePhoto,
                child: const Text(
                  'Change photo',
                  style: TextStyle(
                    color: Color(0xFF4C5FF5),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // Top Right Actions (Edit Pencil OR Cancel & Save Buttons)
        if (!isEditing)
          GestureDetector(
            onTap: onEditTap,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF0D2A42),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF1B4568),
                  width: 0.8,
                ),
              ),
              child: const Icon(
                Icons.edit_outlined,
                size: 18,
                color: Colors.white,
              ),
            ),
          )
        else
          Row(
            children: [
              // Cancel button (Dark circle with cross)
              GestureDetector(
                onTap: onCancelTap,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D2A42),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1B4568),
                      width: 0.8,
                    ),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Save button (Lime green circle with checkmark)
              GestureDetector(
                onTap: onSaveTap,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.businessPrimary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.businessPrimary.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
