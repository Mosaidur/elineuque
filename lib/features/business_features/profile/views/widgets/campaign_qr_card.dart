import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class CampaignQrCard extends StatelessWidget {
  final String referralLink;
  final String rewardAmount;
  final VoidCallback onCopy;
  final VoidCallback onDownload;

  const CampaignQrCard({
    super.key,
    required this.referralLink,
    required this.rewardAmount,
    required this.onCopy,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header Row ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Campaign QR Code',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Share with clients & on social media',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF143B39),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'ACTIVE',
                style: TextStyle(
                  color: AppColors.businessPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ── Mint / Cream Card Body ──
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F4EA),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // QR Matrix Visual
                  Container(
                    width: 108,
                    height: 108,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFCBD5E0),
                        width: 0.8,
                      ),
                    ),
                    child: CustomPaint(
                      painter: _QrPatternPainter(),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Brand & Info Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // elivapp Logo
                        Row(
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0F3E32),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                size: 10,
                                color: AppColors.businessPrimary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'elivapp',
                              style: TextStyle(
                                color: Color(0xFF1A202C),
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 5),

                        const Text(
                          'Promoters share their personalized link. Customers show QR at checkout',
                          style: TextStyle(
                            color: Color(0xFF4A5568),
                            fontSize: 10.5,
                            height: 1.3,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Referral link container
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD6EADA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Referral link',
                                style: TextStyle(
                                  color: Color(0xFF718096),
                                  fontSize: 9,
                                ),
                              ),
                              Text(
                                referralLink,
                                style: const TextStyle(
                                  color: Color(0xFF1A202C),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Action Buttons Row (Copy & Download)
                        Row(
                          children: [
                            // Copy Button
                            Expanded(
                              child: GestureDetector(
                                onTap: onCopy,
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD6EADA),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.copy_rounded,
                                        size: 11,
                                        color: Color(0xFF2D3748),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Copy',
                                        style: TextStyle(
                                          color: Color(0xFF2D3748),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 6),

                            // Download Button
                            Expanded(
                              child: GestureDetector(
                                onTap: onDownload,
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF071F34),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.download_rounded,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Download',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
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
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Bottom Gift Note
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFD6EADA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.card_giftcard_rounded,
                      size: 14,
                      color: Color(0xFF2B6CB0),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'You pay $rewardAmount only when customer makes a purchase',
                        style: const TextStyle(
                          color: Color(0xFF2D3748),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QrPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF071F34)
      ..style = PaintingStyle.fill;

    // Corner Finder Patterns (Top-Left, Top-Right, Bottom-Left)
    _drawFinderPattern(canvas, const Offset(4, 4), 26, paint);
    _drawFinderPattern(canvas, Offset(size.width - 30, 4), 26, paint);
    _drawFinderPattern(canvas, Offset(4, size.height - 30), 26, paint);

    // Decorative matrix points
    final randomPoints = [
      const Offset(36, 6),
      const Offset(42, 6),
      const Offset(52, 6),
      const Offset(36, 16),
      const Offset(48, 16),
      const Offset(60, 16),
      const Offset(36, 26),
      const Offset(52, 26),
      const Offset(6, 36),
      const Offset(16, 36),
      const Offset(36, 36),
      const Offset(48, 36),
      const Offset(60, 36),
      const Offset(72, 36),
      const Offset(84, 36),
      const Offset(6, 46),
      const Offset(22, 46),
      const Offset(32, 46),
      const Offset(44, 46),
      const Offset(56, 46),
      const Offset(70, 46),
      const Offset(84, 46),
      const Offset(12, 56),
      const Offset(28, 56),
      const Offset(40, 56),
      const Offset(52, 56),
      const Offset(66, 56),
      const Offset(78, 56),
      const Offset(36, 68),
      const Offset(48, 68),
      const Offset(62, 68),
      const Offset(76, 68),
      const Offset(36, 80),
      const Offset(50, 80),
      const Offset(64, 80),
      const Offset(78, 80),
      const Offset(90, 80),
    ];

    for (final p in randomPoints) {
      if (p.dx < size.width && p.dy < size.height) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(p.dx, p.dy, 4.5, 4.5),
            const Radius.circular(1),
          ),
          paint,
        );
      }
    }
  }

  void _drawFinderPattern(
      Canvas canvas, Offset offset, double size, Paint paint) {
    // Outer square
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(offset.dx, offset.dy, size, size),
        const Radius.circular(5),
      ),
      paint,
    );

    // Inner clear square
    final clearPaint = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(offset.dx + 4, offset.dy + 4, size - 8, size - 8),
        const Radius.circular(3),
      ),
      clearPaint,
    );

    // Center core square
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(offset.dx + 8, offset.dy + 8, size - 16, size - 16),
        const Radius.circular(2),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
