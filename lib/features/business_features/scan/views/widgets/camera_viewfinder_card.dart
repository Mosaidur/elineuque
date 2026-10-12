import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../../app/theme/theme.dart';

class CameraViewfinderCard extends StatefulWidget {
  final bool isVerifying;
  final void Function(String scannedCode) onScanned;

  const CameraViewfinderCard({
    super.key,
    required this.isVerifying,
    required this.onScanned,
  });

  @override
  State<CameraViewfinderCard> createState() => _CameraViewfinderCardState();
}

class _CameraViewfinderCardState extends State<CameraViewfinderCard>
    with SingleTickerProviderStateMixin {
  late final MobileScannerController _scannerController;
  late final AnimationController _laserController;
  bool _isTorchOn = false;
  bool _isProcessing = false;
  String? _lastScannedCode;
  DateTime? _lastScannedTime;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _laserController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture capture) {
    if (_isProcessing || widget.isVerifying) return;

    for (final barcode in capture.barcodes) {
      final raw = barcode.rawValue?.trim();
      if (raw != null && raw.isNotEmpty) {
        final now = DateTime.now();
        // Prevent duplicate spam within 3 seconds of the same code
        if (_lastScannedCode == raw &&
            _lastScannedTime != null &&
            now.difference(_lastScannedTime!) < const Duration(seconds: 3)) {
          return;
        }

        _lastScannedCode = raw;
        _lastScannedTime = now;
        _isProcessing = true;
        HapticFeedback.mediumImpact();

        widget.onScanned(raw);

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _isProcessing = false;
            });
          }
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      decoration: BoxDecoration(
        color: const Color(0xFF041424),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF133959),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // 1. Live Embedded Camera Stream
            Positioned.fill(
              child: MobileScanner(
                controller: _scannerController,
                onDetect: _handleBarcode,
                fit: BoxFit.cover,
                errorBuilder: (context, error) {
                  return Container(
                    color: const Color(0xFF071F33),
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.videocam_off_rounded,
                            color: Colors.orangeAccent,
                            size: 38,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Camera preview unavailable',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Use manual entry or test chips below',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () => _scannerController.start(),
                            icon: const Icon(Icons.refresh_rounded, size: 16),
                            label: const Text('Retry Camera', style: TextStyle(fontSize: 12)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.businessPrimary,
                              side: const BorderSide(color: AppColors.businessPrimary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // 2. Subtle Dark Vignette Border Gradient
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.95,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF041424).withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 3. Scanning Laser Animation
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _laserController,
                  builder: (context, child) {
                    return Align(
                      alignment: Alignment(0, (_laserController.value * 2) - 1),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        height: 2.5,
                        decoration: BoxDecoration(
                          color: AppColors.businessPrimary,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.businessPrimary.withValues(alpha: 0.85),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 4. Viewfinder Reticle Brackets (4 Corners)
            const _CornerBracket(alignment: Alignment.topLeft),
            const _CornerBracket(alignment: Alignment.topRight),
            const _CornerBracket(alignment: Alignment.bottomLeft),
            const _CornerBracket(alignment: Alignment.bottomRight),

            // 5. Top Controls Overlay (Live badge, Torch, Flip)
            Positioned(
              top: 10,
              left: 12,
              right: 12,
              child: Row(
                children: [
                  // Live indicator badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B2A44).withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF1E5680), width: 0.7),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 7, color: Color(0xFF00E676)),
                        SizedBox(width: 5),
                        Text(
                          'LIVE SCANNER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Torch toggle
                  _CircleToolButton(
                    icon: _isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                    isActive: _isTorchOn,
                    onTap: () async {
                      await _scannerController.toggleTorch();
                      setState(() {
                        _isTorchOn = !_isTorchOn;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  // Switch camera
                  _CircleToolButton(
                    icon: Icons.flip_camera_ios_rounded,
                    onTap: () => _scannerController.switchCamera(),
                  ),
                ],
              ),
            ),

            // 6. Bottom Instruction Pill
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF071F33).withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF18446A), width: 0.8),
                  ),
                  child: const Text(
                    'Point camera directly at customer QR code',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // 7. Loading / Verifying Overlay
            if (widget.isVerifying)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.75),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 3,
                          color: AppColors.businessPrimary,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Verifying referral code...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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

class _CircleToolButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _CircleToolButton({
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFFFFD54F)
              : const Color(0xFF0B2A44).withValues(alpha: 0.85),
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? const Color(0xFFFFD54F) : const Color(0xFF1E5680),
            width: 0.8,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isActive ? Colors.black : Colors.white,
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
    const double bracketSize = 22.0;
    const double strokeWidth = 3.0;
    const Color bracketColor = AppColors.businessPrimary;

    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(18),
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
