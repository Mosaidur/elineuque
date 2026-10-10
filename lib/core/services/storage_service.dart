import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService {
  static final Map<String, dynamic> _testStorage = {};
  static GetStorage? _boxInstance;
  static GetStorage get _box {
    _boxInstance ??= GetStorage();
    return _boxInstance!;
  }

  static bool get _isTest => Get.testMode;

  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUser = 'current_user';
  static const String _keyRole = 'user_role';
  static const String _keyIsLoggedIn = 'is_logged_in';

  static Future<void> init() async {
    if (!_isTest) {
      await GetStorage.init();
    }
  }

  /// Decode JWT payload safely without external dependencies
  static Map<String, dynamic>? decodeJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      var payload = parts[1];
      // Normalize base64Url padding
      while (payload.length % 4 != 0) {
        payload += '=';
      }
      final decodedBytes = base64Url.decode(payload);
      final jsonString = utf8.decode(decodedBytes);
      final map = json.decode(jsonString);
      if (map is Map) {
        return Map<String, dynamic>.from(map);
      }
    } catch (_) {}
    return null;
  }

  // Tokens
  static Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    String? explicitRole,
  }) async {
    if (_isTest) {
      _testStorage[_keyAccessToken] = accessToken;
      if (refreshToken != null) {
        _testStorage[_keyRefreshToken] = refreshToken;
      }
      _testStorage[_keyIsLoggedIn] = true;
    } else {
      await _box.write(_keyAccessToken, accessToken);
      if (refreshToken != null) {
        await _box.write(_keyRefreshToken, refreshToken);
      }
      await _box.write(_keyIsLoggedIn, true);
    }

    // Automatically decode token to extract role and user details
    final payload = decodeJwt(accessToken);
    if (payload != null) {
      final tokenRole = payload['role']?.toString();
      if (tokenRole != null && tokenRole.isNotEmpty) {
        await saveRole(tokenRole);
      }

      // Seed initial user profile from token if not already stored
      final existingUser = getUser();
      if (existingUser == null) {
        if (_isTest) {
          _testStorage[_keyUser] = payload;
        } else {
          await _box.write(_keyUser, payload);
        }
      }
    }

    if (explicitRole != null && explicitRole.isNotEmpty) {
      await saveRole(explicitRole);
    }
  }

  static String? getAccessToken() {
    if (_isTest) {
      return _testStorage[_keyAccessToken] as String?;
    }
    return _box.read<String>(_keyAccessToken);
  }

  static String? getRefreshToken() {
    if (_isTest) {
      return _testStorage[_keyRefreshToken] as String?;
    }
    return _box.read<String>(_keyRefreshToken);
  }

  static bool isLoggedIn() {
    final flag = _isTest
        ? (_testStorage[_keyIsLoggedIn] as bool? ?? false)
        : (_box.read<bool>(_keyIsLoggedIn) ?? false);
    final token = getAccessToken();
    return flag && token != null && token.isNotEmpty;
  }

  // User Profile
  static Future<void> saveUser(Map<String, dynamic> user) async {
    if (_isTest) {
      _testStorage[_keyUser] = user;
    } else {
      await _box.write(_keyUser, user);
    }
    if (user['role'] != null) {
      await saveRole(user['role'].toString());
    }
  }

  static Map<String, dynamic>? getUser() {
    final data = _isTest ? _testStorage[_keyUser] : _box.read(_keyUser);
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  // Role
  static Future<void> saveRole(String role) async {
    if (_isTest) {
      _testStorage[_keyRole] = role.toUpperCase();
    } else {
      await _box.write(_keyRole, role.toUpperCase());
    }
  }

  static String? getRole() {
    final stored = _isTest
        ? (_testStorage[_keyRole] as String?)
        : _box.read<String>(_keyRole);
    if (stored != null && stored.isNotEmpty) {
      return stored.toUpperCase();
    }
    // Fallback: extract from token if available
    final token = getAccessToken();
    if (token != null) {
      final payload = decodeJwt(token);
      final role = payload?['role']?.toString();
      if (role != null && role.isNotEmpty) {
        return role.toUpperCase();
      }
    }
    // Fallback 2: check user object
    final user = getUser();
    final userRole = user?['role']?.toString();
    if (userRole != null && userRole.isNotEmpty) {
      return userRole.toUpperCase();
    }
    return null;
  }

  // Clear Session
  static Future<void> clearAll() async {
    if (_isTest) {
      _testStorage.clear();
    } else {
      await _box.erase();
    }
  }

  static Future<void> clear() async {
    await clearAll();
  }

  static Future<void> clearAuth() async {
    await clearAll();
  }
}
