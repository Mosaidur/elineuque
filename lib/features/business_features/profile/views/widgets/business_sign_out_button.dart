import 'package:flutter/material.dart';

class BusinessSignOutButton extends StatelessWidget {
  final VoidCallback onSignOut;

  const BusinessSignOutButton({
    super.key,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onSignOut,
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFF092942),
          side: const BorderSide(
            color: Color(0xFF1B4968),
            width: 0.8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              size: 18,
              color: Colors.white70,
            ),
            SizedBox(width: 8),
            Text(
              'Sign Out',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
