import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../services/storage_service.dart';
import 'api_constants.dart';

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int statusCode;
  final Map<String, dynamic>? raw;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    required this.statusCode,
    this.raw,
  });
}

class ApiClient {
  static const _jsonEncoder = JsonEncoder.withIndent('  ');

  static Map<String, String> _getHeaders({bool withAuth = true}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (withAuth) {
      final token = StorageService.getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // ─────────────────────────────────────────────────────────────
  // Pretty Terminal Logger
  // ─────────────────────────────────────────────────────────────
  static void _logRequest({
    required String method,
    required Uri url,
    required Map<String, String> headers,
    Map<String, dynamic>? body,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('\n┌───────────────────────────────────────────────────────────────');
    buffer.writeln('│ 🚀 [API REQUEST] $method ${url.path}');
    buffer.writeln('│ 🌐 Full URL: $url');

    final authHeader = headers['Authorization'];
    if (authHeader != null && authHeader.isNotEmpty) {
      final tokenPreview = authHeader.length > 25
          ? '${authHeader.substring(0, 15)}...${authHeader.substring(authHeader.length - 8)}'
          : authHeader;
      buffer.writeln('│ 🔑 Auth: $tokenPreview');
    }

    if (body != null && body.isNotEmpty) {
      // Safely sanitize sensitive fields in log display
      final sanitized = Map<String, dynamic>.from(body);
      if (sanitized.containsKey('password')) {
        sanitized['password'] = '••••••••';
      }
      buffer.writeln('│ 📦 Payload:');
      try {
        final prettyJson = _jsonEncoder.convert(sanitized);
        for (final line in prettyJson.split('\n')) {
          buffer.writeln('│   $line');
        }
      } catch (_) {
        buffer.writeln('│   $sanitized');
      }
    }
    buffer.write('└───────────────────────────────────────────────────────────────');
    debugPrint(buffer.toString());
  }

  static void _logResponse({
    required String method,
    required Uri url,
    required int statusCode,
    required Duration duration,
    required String responseBody,
  }) {
    final buffer = StringBuffer();
    final isSuccess = statusCode >= 200 && statusCode < 300;
    final statusIcon = isSuccess ? '✅' : (statusCode >= 500 ? '🔥' : '⚠️');

    buffer.writeln('\n┌───────────────────────────────────────────────────────────────');
    buffer.writeln('│ $statusIcon [API RESPONSE $statusCode] $method ${url.path} (${duration.inMilliseconds}ms)');

    try {
      final decoded = jsonDecode(responseBody);
      if (decoded is Map<String, dynamic>) {
        final msg = decoded['message']?.toString();
        if (msg != null && msg.isNotEmpty) {
          buffer.writeln('│ 💬 Message: $msg');
        }

        final errs = decoded['errorMessages'];
        if (errs is List && errs.isNotEmpty) {
          buffer.writeln('│ 🚨 Errors:');
          for (final e in errs) {
            buffer.writeln('│   • $e');
          }
        }

        final data = decoded['data'];
        if (data != null) {
          buffer.writeln('│ 📄 Data:');
          final prettyData = _jsonEncoder.convert(data);
          // Limit print length if payload is excessively long
          final lines = prettyData.split('\n');
          if (lines.length > 35) {
            for (final line in lines.take(35)) {
              buffer.writeln('│   $line');
            }
            buffer.writeln('│   ... [truncated ${lines.length - 35} lines]');
          } else {
            for (final line in lines) {
              buffer.writeln('│   $line');
            }
          }
        }
      } else {
        buffer.writeln('│ 📄 Response: $responseBody');
      }
    } catch (_) {
      buffer.writeln('│ 📄 Raw: $responseBody');
    }

    buffer.write('└───────────────────────────────────────────────────────────────');
    debugPrint(buffer.toString());
  }

  static void _logError({
    required String method,
    required Uri url,
    required Object error,
    required Duration duration,
  }) {
    debugPrint(
      '\n┌───────────────────────────────────────────────────────────────\n'
      '│ ❌ [API NETWORK ERROR] $method ${url.path} (${duration.inMilliseconds}ms)\n'
      '│ 🌐 URL: $url\n'
      '│ ⚠️ Exception: $error\n'
      '└───────────────────────────────────────────────────────────────',
    );
  }

  // ─────────────────────────────────────────────────────────────
  // HTTP Methods
  // ─────────────────────────────────────────────────────────────
  static Future<ApiResponse<dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool withAuth = false,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = _getHeaders(withAuth: withAuth);
    _logRequest(method: 'POST', url: url, headers: headers, body: body);

    final stopwatch = Stopwatch()..start();
    try {
      final response = await http
          .post(
            url,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 15));

      stopwatch.stop();
      _logResponse(
        method: 'POST',
        url: url,
        statusCode: response.statusCode,
        duration: stopwatch.elapsed,
        responseBody: response.body,
      );

      return _handleResponse(response);
    } catch (e) {
      stopwatch.stop();
      _logError(method: 'POST', url: url, error: e, duration: stopwatch.elapsed);
      return ApiResponse(
        success: false,
        message: 'Network error: Please check your internet connection and server status.',
        statusCode: 0,
      );
    }
  }

  static Future<ApiResponse<dynamic>> get(
    String endpoint, {
    bool withAuth = true,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = _getHeaders(withAuth: withAuth);
    _logRequest(method: 'GET', url: url, headers: headers);

    final stopwatch = Stopwatch()..start();
    try {
      final response = await http
          .get(
            url,
            headers: headers,
          )
          .timeout(const Duration(seconds: 15));

      stopwatch.stop();
      _logResponse(
        method: 'GET',
        url: url,
        statusCode: response.statusCode,
        duration: stopwatch.elapsed,
        responseBody: response.body,
      );

      return _handleResponse(response);
    } catch (e) {
      stopwatch.stop();
      _logError(method: 'GET', url: url, error: e, duration: stopwatch.elapsed);
      return ApiResponse(
        success: false,
        message: 'Network error: Unable to connect to server.',
        statusCode: 0,
      );
    }
  }

  static Future<ApiResponse<dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = _getHeaders(withAuth: withAuth);
    _logRequest(method: 'PUT', url: url, headers: headers, body: body);

    final stopwatch = Stopwatch()..start();
    try {
      final response = await http
          .put(
            url,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 15));

      stopwatch.stop();
      _logResponse(
        method: 'PUT',
        url: url,
        statusCode: response.statusCode,
        duration: stopwatch.elapsed,
        responseBody: response.body,
      );

      return _handleResponse(response);
    } catch (e) {
      stopwatch.stop();
      _logError(method: 'PUT', url: url, error: e, duration: stopwatch.elapsed);
      return ApiResponse(
        success: false,
        message: 'Network error: Unable to connect to server.',
        statusCode: 0,
      );
    }
  }

  static Future<ApiResponse<dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = _getHeaders(withAuth: withAuth);
    _logRequest(method: 'PATCH', url: url, headers: headers, body: body);

    final stopwatch = Stopwatch()..start();
    try {
      final response = await http
          .patch(
            url,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 15));

      stopwatch.stop();
      _logResponse(
        method: 'PATCH',
        url: url,
        statusCode: response.statusCode,
        duration: stopwatch.elapsed,
        responseBody: response.body,
      );

      return _handleResponse(response);
    } catch (e) {
      stopwatch.stop();
      _logError(method: 'PATCH', url: url, error: e, duration: stopwatch.elapsed);
      return ApiResponse(
        success: false,
        message: 'Network error: Unable to connect to server.',
        statusCode: 0,
      );
    }
  }

  static Future<ApiResponse<dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = _getHeaders(withAuth: withAuth);
    _logRequest(method: 'DELETE', url: url, headers: headers, body: body);

    final stopwatch = Stopwatch()..start();
    try {
      final response = await http
          .delete(
            url,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 15));

      stopwatch.stop();
      _logResponse(
        method: 'DELETE',
        url: url,
        statusCode: response.statusCode,
        duration: stopwatch.elapsed,
        responseBody: response.body,
      );

      return _handleResponse(response);
    } catch (e) {
      stopwatch.stop();
      _logError(method: 'DELETE', url: url, error: e, duration: stopwatch.elapsed);
      return ApiResponse(
        success: false,
        message: 'Network error: Unable to connect to server.',
        statusCode: 0,
      );
    }
  }

  static Future<ApiResponse<dynamic>> patchMultipart(
    String endpoint, {
    Map<String, String>? fields,
    String? fileField,
    String? filePath,
    List<int>? fileBytes,
    String? fileName,
    bool withAuth = true,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final stopwatch = Stopwatch()..start();

    try {
      final request = http.MultipartRequest('PATCH', url);

      if (withAuth) {
        final token = StorageService.getAccessToken();
        if (token != null && token.isNotEmpty) {
          request.headers['Authorization'] = 'Bearer $token';
        }
      }
      request.headers['Accept'] = 'application/json';

      if (fields != null) {
        request.fields.addAll(fields);
      }

      if (fileField != null) {
        if (filePath != null && filePath.isNotEmpty) {
          request.files.add(await http.MultipartFile.fromPath(fileField, filePath));
        } else if (fileBytes != null && fileName != null) {
          request.files.add(http.MultipartFile.fromBytes(fileField, fileBytes, filename: fileName));
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      stopwatch.stop();

      _logResponse(
        method: 'PATCH (MULTIPART)',
        url: url,
        statusCode: response.statusCode,
        duration: stopwatch.elapsed,
        responseBody: response.body,
      );

      return _handleResponse(response);
    } catch (e) {
      stopwatch.stop();
      _logError(method: 'PATCH (MULTIPART)', url: url, error: e, duration: stopwatch.elapsed);
      return ApiResponse(
        success: false,
        message: 'Network error: $e',
        statusCode: 0,
      );
    }
  }

  static ApiResponse<dynamic> _handleResponse(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final success = decoded['success'] == true;
        var message = decoded['message']?.toString() ??
            (success ? 'Request successful' : 'Something went wrong');

        if (!success &&
            decoded['errorMessages'] is List &&
            (decoded['errorMessages'] as List).isNotEmpty) {
          final first = (decoded['errorMessages'] as List).first;
          if (first is Map && first['message'] != null && first['message'].toString().isNotEmpty) {
            message = first['message'].toString();
          } else if (first is String && first.isNotEmpty) {
            message = first;
          }
        }

        return ApiResponse(
          success: success,
          message: message,
          data: decoded['data'],
          statusCode: response.statusCode,
          raw: decoded,
        );
      }
      return ApiResponse(
        success: response.statusCode >= 200 && response.statusCode < 300,
        message: 'Response received',
        data: decoded,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse(
        success: response.statusCode >= 200 && response.statusCode < 300,
        message: response.reasonPhrase ?? 'Unknown response format',
        statusCode: response.statusCode,
      );
    }
  }
}
