import 'package:flutter/foundation.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _currentUser;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  String? get userRole => (_currentUser?['role']?.toString() ?? StorageService.getRole())?.toUpperCase();
  bool get isBusinessOwner => userRole == 'BUSINESS_OWNER' || userRole == 'BUSINESS';
  bool get isPromoter => userRole == 'PROMOTER';

  AuthProvider() {
    _initAuthState();
  }

  void _initAuthState() {
    final token = StorageService.getAccessToken();
    final savedUser = StorageService.getUser();
    if (token != null && token.isNotEmpty) {
      _isAuthenticated = true;
      _currentUser = savedUser;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// 1. Login with email & password
  Future<ApiResponse<dynamic>> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError(null);

    final res = await ApiClient.post(
      ApiConstants.login,
      body: {
        'email': email.trim(),
        'password': password.trim(),
      },
    );

    _setLoading(false);

    if (res.success && res.data != null) {
      final token = res.data['accessToken']?.toString();
      if (token != null && token.isNotEmpty) {
        await StorageService.saveTokens(accessToken: token);
        _isAuthenticated = true;

        // Fetch latest profile details
        await fetchProfile();
      }
    } else {
      _setError(res.message);
    }

    return res;
  }

  /// 2. Register user (PROMOTER or BUSINESS_OWNER)
  Future<ApiResponse<dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
    String? businessName,
  }) async {
    _setLoading(true);
    _setError(null);

    final body = <String, dynamic>{
      'name': name.trim(),
      'email': email.trim().toLowerCase(),
      'phone': phone.trim(),
      'password': password,
      'role': role,
    };

    if (businessName != null && businessName.isNotEmpty) {
      body['businessName'] = businessName.trim();
    }

    final res = await ApiClient.post(
      ApiConstants.register,
      body: body,
    );

    _setLoading(false);
    if (!res.success) {
      _setError(res.message);
    }

    return res;
  }

  /// 3. Verify OTP
  Future<ApiResponse<dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    _setLoading(true);
    _setError(null);

    final cleanOtp = otp.trim();
    final otpNumber = int.tryParse(cleanOtp);

    final res = await ApiClient.post(
      ApiConstants.verifyOtp,
      body: {
        'email': email.trim().toLowerCase(),
        'oneTimeCode': otpNumber ?? cleanOtp,
        'otp': otpNumber ?? cleanOtp,
      },
    );

    _setLoading(false);

    if (res.success && res.data != null) {
      final token = res.data['accessToken']?.toString();
      if (token != null && token.isNotEmpty) {
        await StorageService.saveTokens(accessToken: token);
        _isAuthenticated = true;
        await fetchProfile();
      }
    } else {
      _setError(res.message);
    }

    return res;
  }

  /// 4. Resend OTP
  Future<ApiResponse<dynamic>> resendOtp({required String email}) async {
    _setLoading(true);
    final res = await ApiClient.post(
      ApiConstants.resendOtp,
      body: {'email': email.trim().toLowerCase()},
    );
    _setLoading(false);
    return res;
  }

  /// 5. Forgot Password
  Future<ApiResponse<dynamic>> forgotPassword({required String email}) async {
    _setLoading(true);
    _setError(null);

    final res = await ApiClient.post(
      ApiConstants.forgetPassword,
      body: {'email': email.trim().toLowerCase()},
    );

    _setLoading(false);
    if (!res.success) {
      _setError(res.message);
    }
    return res;
  }

  /// 6. Reset Password
  Future<ApiResponse<dynamic>> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    _setLoading(true);
    _setError(null);

    final res = await ApiClient.post(
      ApiConstants.resetPassword,
      body: {'newPassword': newPassword},
      withAuth: true,
    );

    _setLoading(false);
    if (!res.success) {
      _setError(res.message);
    }
    return res;
  }

  /// 7. Fetch current profile
  Future<void> fetchProfile() async {
    final res = await ApiClient.get(ApiConstants.me, withAuth: true);
    if (res.success && res.data != null) {
      final user = res.data is Map ? Map<String, dynamic>.from(res.data) : null;
      if (user != null) {
        _currentUser = user;
        await StorageService.saveUser(user);
        notifyListeners();
      }
    }
  }

  /// 8. Logout
  Future<void> logout() async {
    try {
      await ApiClient.post(ApiConstants.logout, withAuth: true);
    } catch (_) {}

    await StorageService.clearAll();
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
