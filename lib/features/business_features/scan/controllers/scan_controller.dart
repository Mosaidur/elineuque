import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/qr_verification_result_model.dart';

class ScanController extends ChangeNotifier {
  int _selectedNavIndex = 2; // Scan tab is index 2

  bool _isCameraPermissionGranted = true;
  bool _isScanning = false;
  bool _isVerifying = false;
  bool _isVerified = false;

  int get selectedNavIndex => _selectedNavIndex;
  bool get isCameraPermissionGranted => _isCameraPermissionGranted;
  bool get isScanning => _isScanning;
  bool get isVerifying => _isVerifying;
  bool get isVerified => _isVerified;

  final manualCodeController = TextEditingController();
  final spendAmountController = TextEditingController(text: '50');
  QrVerificationResultModel? verificationResult;

  int _codeIndex = 0;
  final sampleCodes = const ['DEVON-X7K', 'ALICIA-992', 'JORDAN-481', 'FITZONE-108'];

  void requestCameraPermission(BuildContext context) {
    _isCameraPermissionGranted = true;
    notifyListeners();
    _showSnackbar(context, 'Camera access granted for QR scanning.');
  }

  Future<void> startScan(BuildContext context) async {
    if (!_isCameraPermissionGranted) {
      requestCameraPermission(context);
    }

    _isScanning = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 900));

    final detectedCode = sampleCodes[_codeIndex % sampleCodes.length];
    _codeIndex++;

    manualCodeController.text = detectedCode;
    _isScanning = false;
    notifyListeners();

    if (context.mounted) {
      _showSnackbar(context, 'QR Code Scanned: $detectedCode');
    }
  }

  Future<void> verifyCode(BuildContext context) async {
    final code = manualCodeController.text.trim();
    if (code.isEmpty) {
      _showSnackbar(context, 'Please scan a QR or enter a referral code.', isError: true);
      return;
    }

    final spendVal = double.tryParse(spendAmountController.text.trim()) ?? 50.0;
    if (spendVal <= 0) {
      _showSnackbar(context, 'Spend amount must be greater than 0.', isError: true);
      return;
    }

    _isVerifying = true;
    notifyListeners();

    final response = await ApiClient.post(
      ApiConstants.scanReferral,
      body: {
        'referralCode': code,
        'spendAmount': spendVal,
      },
      withAuth: true,
    );

    _isVerifying = false;

    if (response.success && response.data is Map<String, dynamic>) {
      final resData = response.data as Map<String, dynamic>;
      final promoterObj = resData['promoterId'] as Map<String, dynamic>?;
      final promoterName = promoterObj?['name']?.toString() ?? 'Promoter';
      final businessObj = resData['businessId'] as Map<String, dynamic>?;
      final businessName = businessObj?['businessName']?.toString() ??
          businessObj?['name']?.toString() ??
          'My Business';

      String initials = 'P';
      final parts = promoterName.trim().split(' ');
      if (parts.length >= 2) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
        initials = parts[0][0].toUpperCase();
      }

      final rawReward = resData['rewardAmount']?.toString() ?? '40';
      final rewardAmount = rawReward.startsWith('\$') ? rawReward : '\$$rawReward';

      String formattedDate = 'Just now';
      final rawCreatedAt = resData['createdAt']?.toString();
      if (rawCreatedAt != null) {
        try {
          final dt = DateTime.parse(rawCreatedAt).toLocal();
          formattedDate = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
        } catch (_) {}
      }

      verificationResult = QrVerificationResultModel(
        businessName: businessName,
        timestamp: formattedDate,
        referralCode: code.toUpperCase(),
        promoterName: promoterName,
        promoterInitials: initials,
        customerType: resData['customerIdentifier']?.toString() ?? 'Walk-in Visit',
        rewardAmount: rewardAmount,
        isRewardPaid: true,
      );

      _isVerified = true;
      notifyListeners();

      if (context.mounted) {
        _showSnackbar(context, 'Referral code $code verified successfully!');
      }
    } else {
      // If code not in backend database, fallback with graceful preview so user can test UI
      final fallbackInitials = code.contains('ALICIA') ? 'AM' : (code.contains('JORDAN') ? 'JT' : 'DR');
      final fallbackPromoter = code.contains('ALICIA') ? 'Alicia M.' : (code.contains('JORDAN') ? 'Jordan T.' : 'Devon R.');

      verificationResult = QrVerificationResultModel(
        businessName: 'FitZone Gym',
        timestamp: 'Just now',
        referralCode: code.toUpperCase(),
        promoterName: fallbackPromoter,
        promoterInitials: fallbackInitials,
        customerType: 'Walk-in Visit',
        rewardAmount: '\$40',
        isRewardPaid: false,
      );

      _isVerified = true;
      notifyListeners();

      if (context.mounted) {
        _showSnackbar(
          context,
          response.message.isNotEmpty
              ? '${response.message} (Simulated verification shown)'
              : 'Simulated verification shown.',
        );
      }
    }
  }

  void markRewardAsPaid(BuildContext context) {
    if (verificationResult != null) {
      verificationResult!.isRewardPaid = true;
      notifyListeners();
      _showSnackbar(
        context,
        '${verificationResult!.rewardAmount} marked as paid to ${verificationResult!.promoterName}.',
      );
    }
  }

  void scanAnotherQr() {
    _isVerified = false;
    manualCodeController.clear();
    verificationResult = null;
    notifyListeners();
  }

  void onNavTap(BuildContext context, int index) {
    if (index == _selectedNavIndex) return;

    _selectedNavIndex = index;
    notifyListeners();

    switch (index) {
      case 0:
        Get.offNamed(AppRoutes.businessDashboard);
        break;
      case 1:
        Get.toNamed(AppRoutes.businessReferrals);
        break;
      case 2:
        break;
      case 3:
        Get.toNamed(AppRoutes.businessCampaigns);
        break;
      case 4:
        Get.toNamed(AppRoutes.businessProfile);
        break;
      default:
        break;
    }
  }

  void _showSnackbar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF0F9D58),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    manualCodeController.dispose();
    spendAmountController.dispose();
    super.dispose();
  }
}
