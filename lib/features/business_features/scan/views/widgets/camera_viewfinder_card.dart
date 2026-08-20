import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class CameraViewfinderCard extends StatelessWidget {
  final bool isScanning;
  final VoidCallback onTapScan;

  const CameraViewfinderCard({
    super.key,
    required this.isScanning,
    required this.onTapScan,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapScan,
      child: Container(
        width: double.infinity,
        height: 240,
        decoration: BoxDecoration(
          color: const Color(0xFF041424),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF133959),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // 4 Corner Viewfinder Brackets
            const _CornerBracket(alignment: Alignment.topLeft),
            const _CornerBracket(alignment: Alignment.topRight),
            const _CornerBracket(alignment: Alignment.bottomLeft),
            const _CornerBracket(alignment: Alignment.bottomRight),

            // Scanning Animation Laser Line
            if (isScanning)
              const Positioned.fill(
                child: _ScanningLaserAnimation(),
              ),

            // Center Content (Camera Icon & Label)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isScanning
                          ? const Color(0xFF5365F5).withValues(alpha: 0.3)
                          : const Color(0xFF0F2F4A),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isScanning
                            ? const Color(0xFF5365F5)
                            : const Color(0xFF1D4A72),
                        width: 1.5,
                      ),
                    ),
                    child: isScanning
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.businessPrimary,
                            ),
                          )
                        : const Icon(
                            Icons.camera_alt_outlined,
                            size: 26,
                            color: Colors.white,
                          ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    isScanning ? 'Scanning QR code...' : 'Tap to start scanning',
                    style: TextStyle(
                      color: isScanning
                          ? AppColors.businessPrimary
                          : AppColors.textSecondary,
                      fontSize: 13.5,
                      fontWeight: isScanning ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CornerBracket extends StatelessWidget {
  final Alignment alignment;

  const _CornerBracket({required this.alignment});

  @override
  Widget build(BuildContext context) {
    const double bracketSize = 24.0;
    const double strokeWidth = 2.5;
    const Color bracketColor = Color(0xFF2A5780);

    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: CustomPaint(
          size: const Size(bracketSize, bracketSize),
          painter: _CornerPainter(
            alignment: alignment,
            color: bracketColor,
            strokeWidth: strokeWidth,
          ),
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Alignment alignment;
  final Color color;
  final double strokeWidth;

  _CornerPainter({
    required this.alignment,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (alignment == Alignment.topLeft) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (alignment == Alignment.topRight) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (alignment == Alignment.bottomLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else if (alignment == Alignment.bottomRight) {
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ScanningLaserAnimation extends StatefulWidget {
  const _ScanningLaserAnimation();

  @override
  State<_ScanningLaserAnimation> createState() => _ScanningLaserAnimationState();
}

class _ScanningLaserAnimationState extends State<_ScanningLaserAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return Align(
          alignment: Alignment(0, (_ctrl.value * 2) - 1),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            height: 2,
            decoration: BoxDecoration(
              color: AppColors.businessPrimary,
              boxShadow: [
                BoxShadow(
                  color: AppColors.businessPrimary.withValues(alpha: 0.8),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
