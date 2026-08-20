import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../models/qr_verification_result_model.dart';

class ScanController extends GetxController {
  final selectedNavIndex = 2.obs; // Scan tab is index 2

  final isCameraPermissionGranted = true.obs;
  final isScanning = false.obs;
  final isVerified = false.obs;

  final manualCodeController = TextEditingController();
  final verificationResult = Rxn<QrVerificationResultModel>();

  int _codeIndex = 0;
  final sampleCodes = const ['DEVON-X7K', 'ALICIA-992', 'JORDAN-481', 'FITZONE-108'];

  void requestCameraPermission() {
    isCameraPermissionGranted.value = true;
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Camera Permission',
        'Camera access granted for QR scanning.',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> startScan() async {
    if (!isCameraPermissionGranted.value) {
      requestCameraPermission();
    }

    isScanning.value = true;
    await Future.delayed(const Duration(milliseconds: 900));

    final detectedCode = sampleCodes[_codeIndex % sampleCodes.length];
    _codeIndex++;

    // Auto-fill the manual code input field as requested
    manualCodeController.text = detectedCode;
    isScanning.value = false;

    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'QR Code Scanned',
        'Auto-filled code: $detectedCode',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void verifyCode() {
    final code = manualCodeController.text.trim();
    if (code.isEmpty) {
      if (Get.context != null && Get.key.currentState?.overlay != null) {
        Get.snackbar(
          'Validation Error',
          'Please scan a QR or enter a referral code.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return;
    }

    // Determine promoter name based on code
    String promoter = 'Devon R.';
    String initials = 'DR';
    if (code.contains('ALICIA')) {
      promoter = 'Alicia M.';
      initials = 'AM';
    } else if (code.contains('JORDAN')) {
      promoter = 'Jordan T.';
      initials = 'JT';
    }

    verificationResult.value = QrVerificationResultModel(
      businessName: 'FitZone Gym',
      timestamp: 'Jul 29, 11:06 AM',
      referralCode: code.toUpperCase(),
      promoterName: promoter,
      promoterInitials: initials,
      customerType: 'Walk-in Visit',
      rewardAmount: '\$40',
      isRewardPaid: false,
    );

    isVerified.value = true;
  }

  void markRewardAsPaid() {
    final result = verificationResult.value;
    if (result != null) {
      result.isRewardPaid = true;
      verificationResult.refresh();

      if (Get.context != null && Get.key.currentState?.overlay != null) {
        Get.snackbar(
          'Reward Paid',
          '${result.rewardAmount} marked as paid to ${result.promoterName}.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void scanAnotherQr() {
    isVerified.value = false;
    manualCodeController.clear();
    verificationResult.value = null;
  }

  void onNavTap(int index) {
    if (index == selectedNavIndex.value) return;

    selectedNavIndex.value = index;
    switch (index) {
      case 0:
        if (Get.key.currentState != null) {
          Get.offNamed(AppRoutes.businessDashboard);
        }
        break;
      case 1:
        if (Get.key.currentState != null) {
          Get.toNamed(AppRoutes.businessReferrals);
        }
        break;
      case 2:
        // Already on scan; no-op
        break;
      case 3:
        if (Get.key.currentState != null) {
          Get.toNamed(AppRoutes.businessCampaigns);
        }
        break;
      case 4:
        if (Get.key.currentState != null) {
          Get.toNamed(AppRoutes.businessProfile);
        }
        break;
      default:
        break;
    }
  }

  @override
  void onClose() {
    manualCodeController.dispose();
    super.onClose();
  }
}
