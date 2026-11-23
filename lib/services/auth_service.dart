import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class AuthService {
  static const String _keyToken = 'auth_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyUserRole = 'user_role';

  /// Register customer with Name, Phone Number and Password
  Future<Map<String, dynamic>> register({
    required String name,
    required String phoneNumber,
    required String password,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final body = jsonEncode({
      'name': name.trim(),
      'phoneNumber': phoneNumber.trim(),
      'password': password,
    });

    http.Response? response;
    final candidates = ApiConfig.candidateUrls;

    for (final base in candidates) {
      try {
        final url = Uri.parse('$base/auth/register');
        response = await http
            .post(url, headers: headers, body: body)
            .timeout(const Duration(seconds: 4));
        ApiConfig.setActiveBaseUrl(base);
        break;
      } catch (_) {
        continue;
      }
    }

    if (response == null) {
      return {
        'success': false,
        'message': 'Unable to connect to server. Check your connection.',
      };
    }

    Map<String, dynamic> data = {};
    try {
      data = jsonDecode(response.body);
    } catch (_) {}

    if (response.statusCode == 201 || response.statusCode == 200) {
      if (data['token'] != null) {
        await _saveSession(data);
      }
      return {'success': true, 'data': data};
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Registration failed (${response.statusCode})',
      };
    }
  }

  /// Customer Login using Phone Number and Password
  Future<Map<String, dynamic>> login({
    required String phoneNumber,
    required String password,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final body = jsonEncode({
      'phoneNumber': phoneNumber.trim(),
      'password': password.trim(),
    });

    http.Response? response;
    final candidates = ApiConfig.candidateUrls;

    for (final base in candidates) {
      try {
        final url = Uri.parse('$base/auth/login');
        response = await http
            .post(url, headers: headers, body: body)
            .timeout(const Duration(seconds: 4));
        ApiConfig.setActiveBaseUrl(base);
        break;
      } catch (e) {
        debugPrint('Host $base failed: $e');
        continue;
      }
    }

    // If initial pass didn't connect, retry once in case backend was booting
    if (response == null) {
      await Future.delayed(const Duration(milliseconds: 1000));
      for (final base in candidates) {
        try {
          final url = Uri.parse('$base/auth/login');
          response = await http
              .post(url, headers: headers, body: body)
              .timeout(const Duration(seconds: 5));
          ApiConfig.setActiveBaseUrl(base);
          break;
        } catch (_) {
          continue;
        }
      }
    }

    if (response == null) {
      return {
        'success': false,
        'message': 'Unable to connect to server. Please ensure the backend is running.',
      };
    }

    Map<String, dynamic> data = {};
    try {
      data = jsonDecode(response.body);
    } catch (_) {}

    if (response.statusCode == 200) {
      await _saveSession(data);
      return {'success': true, 'data': data};
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Invalid phone number or password',
      };
    }
  }

  /// Reset Password using Phone Number and New Password
  Future<Map<String, dynamic>> resetPassword({
    required String phoneNumber,
    required String newPassword,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final body = jsonEncode({
      'phoneNumber': phoneNumber.trim(),
      'newPassword': newPassword,
    });

    http.Response? response;
    final candidates = ApiConfig.candidateUrls;

    for (final base in candidates) {
      try {
        final url = Uri.parse('$base/auth/reset-password');
        response = await http
            .post(url, headers: headers, body: body)
            .timeout(const Duration(seconds: 4));
        ApiConfig.setActiveBaseUrl(base);
        break;
      } catch (_) {
        continue;
      }
    }

    if (response == null) {
      return {'success': false, 'message': 'Unable to connect to server. Please ensure the backend is running.'};
    }

    Map<String, dynamic> data = {};
    try {
      data = jsonDecode(response.body);
    } catch (_) {}

    if (response.statusCode == 200) {
      return {'success': true, 'message': data['message'] ?? 'Password reset successfully'};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Failed to reset password'};
    }
  }

  /// Save session details to persistent storage
  Future<void> _saveSession(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    if (data['token'] != null) {
      await prefs.setString(_keyToken, data['token']);
    }
    if (data['id'] != null) {
      await prefs.setInt(_keyUserId, data['id']);
    }
    if (data['name'] != null) {
      await prefs.setString(_keyUserName, data['name']);
    }
    if (data['phoneNumber'] != null) {
      await prefs.setString(_keyUserPhone, data['phoneNumber']);
    }
    if (data['role'] != null) {
      await prefs.setString(_keyUserRole, data['role']);
    }
  }

  /// Check whether user is logged in (Auto Login)
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyToken);
    return token != null && token.isNotEmpty;
  }

  /// Get current JWT token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  /// Get locally stored user data
  Future<Map<String, dynamic>> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getInt(_keyUserId),
      'name': prefs.getString(_keyUserName) ?? '',
      'phoneNumber': prefs.getString(_keyUserPhone) ?? '',
      'role': prefs.getString(_keyUserRole) ?? 'CUSTOMER',
    };
  }

  /// Fetch Customer Profile from backend using Bearer token
  Future<Map<String, dynamic>> fetchProfile() async {
    try {
      final token = await getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not logged in'};
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/customer/profile');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Failed to load profile'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error'};
    }
  }

  /// Logout and clear stored session
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
