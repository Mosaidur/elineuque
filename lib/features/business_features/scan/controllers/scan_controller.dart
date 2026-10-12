import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/qr_verification_result_model.dart';
import '../views/widgets/live_qr_scanner_sheet.dart';

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

  /// Helper to extract clean referral code from raw QR payload (which may be a URL or raw text)
  String parseReferralCode(String raw) {
    raw = raw.trim();
    try {
      final uri = Uri.tryParse(raw);
      if (uri != null) {
        if (uri.queryParameters.containsKey('code')) {
          return uri.queryParameters['code']!.trim().toUpperCase();
        }
        if (uri.queryParameters.containsKey('ref')) {
          return uri.queryParameters['ref']!.trim().toUpperCase();
        }
        if (uri.pathSegments.isNotEmpty) {
          final last = uri.pathSegments.last.trim();
          if (last.isNotEmpty && last.length <= 30 && !last.contains('.')) {
            return last.toUpperCase();
          }
        }
      }
    } catch (_) {}
    return raw.toUpperCase();
  }

  void requestCameraPermission(BuildContext context) {
    _isCameraPermissionGranted = true;
    notifyListeners();
    _showSnackbar(context, 'Camera access granted for QR scanning.');
  }

  /// Opens the live device camera QR scanner sheet
  Future<void> openLiveScanner(BuildContext context) async {
    _isScanning = true;
    notifyListeners();

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LiveQrScannerSheet(
          onScanned: (rawCode) {
            handleScannedCode(context, rawCode);
          },
        ),
      ),
    );

    _isScanning = false;
    notifyListeners();
  }

  /// Starts the scan workflow (opens camera viewfinder)
  Future<void> startScan(BuildContext context) async {
    await openLiveScanner(context);
  }

  /// Handles code captured from the camera or external scanner
  void handleScannedCode(BuildContext context, String rawCode) {
    final cleanCode = parseReferralCode(rawCode);
    manualCodeController.text = cleanCode;
    notifyListeners();

    _showSnackbar(context, 'QR Code Scanned: $cleanCode');

    // Automatically trigger verification on detection
    verifyCode(context);
  }

  /// Quick fill for testing
  void setManualCode(String code) {
    manualCodeController.text = code.trim().toUpperCase();
    notifyListeners();
  }

  Future<void> verifyCode(BuildContext context) async {
    final code = manualCodeController.text.trim().toUpperCase();
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
        referralCode: code,
        promoterName: promoterName,
        promoterInitials: initials,
        customerType: resData['customerIdentifier']?.toString() ?? 'Walk-in Customer',
        rewardAmount: rewardAmount,
        isRewardPaid: true,
      );

      _isVerified = true;
      notifyListeners();

      if (context.mounted) {
        _showSnackbar(context, 'Referral code $code verified & recorded successfully!');
      }
    } else {
      _isVerified = false;
      notifyListeners();

      if (context.mounted) {
        final errorMsg = response.message.isNotEmpty
            ? response.message
            : 'Referral code not found or invalid for this business.';
        _showSnackbar(context, errorMsg, isError: true);
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
        duration: const Duration(seconds: 4),
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
