import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/theme.dart';
import '../../../business_features/dashboard/views/widgets/business_bottom_nav.dart';
import '../controllers/scan_controller.dart';
import 'widgets/camera_viewfinder_card.dart';
import 'widgets/manual_code_input_card.dart';
import 'widgets/scanner_step_progress.dart';
import 'widgets/visit_verified_card.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ScanController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: BusinessBottomNav(
        selectedIndex: controller.selectedNavIndex,
        onItemSelected: (index) => controller.onNavTap(context, index),
      ),
      body: SafeArea(
        child: controller.isVerified
            ? _buildVerifiedPage(context, controller)
            : _buildScanPage(context, controller),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // PAGE 1 — Scan QR
  // ──────────────────────────────────────────────────────────
  Widget _buildScanPage(BuildContext context, ScanController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          const Text(
            'Scan Customer QR',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Customer shows you their QR → you scan → confirm\npurchase → pay promoter',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 22),

          // ── Step Progress Bar ──
          const ScannerStepProgress(),

          const SizedBox(height: 24),

          // ── Camera Viewfinder ──
          CameraViewfinderCard(
            isScanning: controller.isScanning,
            onTapScan: () => controller.startScan(context),
          ),

          const SizedBox(height: 20),

          // ── Spend amount row ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF092942),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1B4968), width: 0.8),
            ),
            child: Row(
              children: [
                const Icon(Icons.attach_money_rounded, color: AppColors.businessPrimary, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Spend Amount: \$',
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: TextField(
                    controller: controller.spendAmountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '50',
                      hintStyle: TextStyle(color: AppColors.textSecondary),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ── Manual Code Entry Card ──
          ManualCodeInputCard(
            controller: controller.manualCodeController,
            onVerify: () => controller.verifyCode(context),
          ),

          const SizedBox(height: 16),

          // ── Permission hint row ──
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: controller.isCameraPermissionGranted ? 0 : 1,
            child: GestureDetector(
              onTap: () => controller.requestCameraPermission(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF3B2525),
                    width: 0.8,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.camera_alt_rounded,
                      size: 18,
                      color: Color(0xFFFF7043),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Camera permission required. Tap to grant.',
                        style: TextStyle(
                          color: Color(0xFFFF7043),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: Color(0xFFFF7043),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // PAGE 2 — Visit Verified Receipt
  // ──────────────────────────────────────────────────────────
  Widget _buildVerifiedPage(BuildContext context, ScanController controller) {
    final result = controller.verificationResult;
    if (result == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      child: VisitVerifiedCard(
        result: result,
        onMarkPaid: () => controller.markRewardAsPaid(context),
        onScanAnother: controller.scanAnotherQr,
      ),
    );
  }
}
