import 'package:flutter/material.dart';

import '../../../../../app/theme/theme.dart';

class EarningsHeroCard extends StatelessWidget {
  final String totalEarnings;
  final String thisMonth;
  final String referrals;
  final String converted;

  const EarningsHeroCard({
    super.key,
    required this.totalEarnings,
    required this.thisMonth,
    required this.referrals,
    required this.converted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3850EA),
            Color(0xFF2B3EB8),
            Color(0xFF1E2D8E),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3850EA).withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decorative glow shapes
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.businessPrimary.withValues(alpha: 0.06),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Earnings',
                  style: TextStyle(
                    color: Color(0xFFD4DCFF),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  totalEarnings,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 18),

                // Metrics Row
                Row(
                  children: [
                    _MetricColumn(
                      label: 'This Month',
                      value: thisMonth,
                      valueColor: AppColors.businessPrimary,
                    ),
                    Container(
                      width: 1,
                      height: 28,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                    _MetricColumn(
                      label: 'Referrals',
                      value: referrals,
                      valueColor: Colors.white,
                    ),
                    Container(
                      width: 1,
                      height: 28,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                    _MetricColumn(
                      label: 'Converted',
                      value: converted,
                      valueColor: Colors.white,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Wave Chart Graphic
                SizedBox(
                  height: 42,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _WaveChartPainter(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _MetricColumn({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFC0CDFF),
            fontSize: 11.5,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _WaveChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = const Color(0xFFD4FF5A)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.cubicTo(
      size.width * 0.2,
      size.height * 0.75,
      size.width * 0.35,
      size.height * 0.65,
      size.width * 0.45,
      size.height * 0.4,
    );
    path.cubicTo(
      size.width * 0.55,
      size.height * 0.2,
      size.width * 0.7,
      size.height * 0.5,
      size.width * 0.82,
      size.height * 0.25,
    );
    path.cubicTo(
      size.width * 0.9,
      size.height * 0.1,
      size.width * 0.95,
      size.height * 0.3,
      size.width,
      size.height * 0.35,
    );

    // Fill under path
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFD4FF5A).withValues(alpha: 0.18),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
