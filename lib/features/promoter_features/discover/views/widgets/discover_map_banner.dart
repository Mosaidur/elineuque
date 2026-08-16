import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class DiscoverMapBanner extends StatelessWidget {
  final VoidCallback onMapView;
  final String locationText;

  const DiscoverMapBanner({
    super.key,
    required this.onMapView,
    this.locationText = 'San Francisco, CA',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF071F36),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 0.8,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Custom Painted Dark Map Illustration
            CustomPaint(
              size: const Size(double.infinity, 120),
              painter: _MapGraphicPainter(),
            ),

            // Top Left Location Badge
            Positioned(
              left: 12,
              top: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF031628).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.6),
                    width: 0.6,
                  ),
                ),
                child: Text(
                  locationText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Bottom Right Map View Button
            Positioned(
              right: 12,
              bottom: 10,
              child: GestureDetector(
                onTap: onMapView,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4C5FF5),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4C5FF5).withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Map View',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapGraphicPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Water background
    final bgPaint = Paint()..color = const Color(0xFF081C30);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Land contours
    final landPaint = Paint()..color = const Color(0xFF0C2744);
    final landPath = Path();
    landPath.moveTo(0, size.height * 0.3);
    landPath.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.1,
      size.width * 0.6,
      size.height * 0.45,
    );
    landPath.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.8,
      size.width,
      size.height * 0.6,
    );
    landPath.lineTo(size.width, size.height);
    landPath.lineTo(0, size.height);
    landPath.close();
    canvas.drawPath(landPath, landPaint);

    // Road network lines
    final roadPaint = Paint()
      ..color = const Color(0xFF1E5284).withValues(alpha: 0.6)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final roadPath = Path();
    roadPath.moveTo(size.width * 0.1, size.height * 0.8);
    roadPath.lineTo(size.width * 0.4, size.height * 0.3);
    roadPath.lineTo(size.width * 0.7, size.height * 0.5);
    roadPath.lineTo(size.width * 0.9, size.height * 0.2);

    roadPath.moveTo(size.width * 0.25, size.height * 0.15);
    roadPath.lineTo(size.width * 0.55, size.height * 0.6);
    roadPath.lineTo(size.width * 0.85, size.height * 0.75);

    canvas.drawPath(roadPath, roadPaint);

    // Glowing Pin Dots (Red/Coral)
    final pinPaint = Paint()..color = const Color(0xFFFF5252);
    final glowPaint = Paint()
      ..color = const Color(0xFFFF5252).withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    final pins = [
      Offset(size.width * 0.25, size.height * 0.45),
      Offset(size.width * 0.45, size.height * 0.55),
      Offset(size.width * 0.65, size.height * 0.35),
      Offset(size.width * 0.8, size.height * 0.5),
      Offset(size.width * 0.35, size.height * 0.75),
    ];

    for (final pin in pins) {
      canvas.drawCircle(pin, 7, glowPaint);
      canvas.drawCircle(pin, 3.5, pinPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
