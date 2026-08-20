import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/theme.dart';
import '../../../business_features/dashboard/views/widgets/business_bottom_nav.dart';
import '../controllers/scan_controller.dart';
import 'widgets/camera_viewfinder_card.dart';
import 'widgets/manual_code_input_card.dart';
import 'widgets/scanner_step_progress.dart';
import 'widgets/visit_verified_card.dart';

class ScanScreen extends GetView<ScanController> {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: Obx(
        () => BusinessBottomNav(
          selectedIndex: controller.selectedNavIndex.value,
          onItemSelected: controller.onNavTap,
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isVerified.value) {
            return _buildVerifiedPage();
          }
          return _buildScanPage();
        }),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // PAGE 1 — Scan QR
  // ──────────────────────────────────────────────────────────
  Widget _buildScanPage() {
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
          Obx(
            () => CameraViewfinderCard(
              isScanning: controller.isScanning.value,
              onTapScan: controller.startScan,
            ),
          ),

          const SizedBox(height: 20),

          // ── Manual Code Entry Card ──
          ManualCodeInputCard(
            controller: controller.manualCodeController,
            onVerify: controller.verifyCode,
          ),

          const SizedBox(height: 16),

          // ── Permission hint row ──
          Obx(
            () => AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: controller.isCameraPermissionGranted.value ? 0 : 1,
              child: GestureDetector(
                onTap: controller.requestCameraPermission,
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
                  child: Row(
                    children: [
                      const Icon(
                        Icons.camera_alt_rounded,
                        size: 18,
                        color: Color(0xFFFF7043),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Camera permission required. Tap to grant.',
                          style: TextStyle(
                            color: Color(0xFFFF7043),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: Color(0xFFFF7043),
                      ),
                    ],
                  ),
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
  Widget _buildVerifiedPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      child: Obx(
        () {
          final result = controller.verificationResult.value;
          if (result == null) return const SizedBox.shrink();

          return VisitVerifiedCard(
            result: result,
            onMarkPaid: controller.markRewardAsPaid,
            onScanAnother: controller.scanAnotherQr,
          );
        },
      ),
    );
  }
}
