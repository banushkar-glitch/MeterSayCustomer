import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'auth_service.dart';

class RideService {
  final AuthService _authService = AuthService();

  /// Book a new ride
  Future<Map<String, dynamic>> bookRide({
    required String pickupAddress,
    required double pickupLatitude,
    required double pickupLongitude,
    required String dropAddress,
    required double dropLatitude,
    required double dropLongitude,
  }) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'User is not logged in. Please login first.',
        };
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/rides/book');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'pickupAddress': pickupAddress.trim(),
          'pickupLatitude': pickupLatitude,
          'pickupLongitude': pickupLongitude,
          'dropAddress': dropAddress.trim(),
          'dropLatitude': dropLatitude,
          'dropLongitude': dropLongitude,
        }),
      );

      Map<String, dynamic> data = {};
      try {
        data = jsonDecode(response.body);
      } catch (_) {}

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'data': data,
          'rideId': data['rideId'],
          'status': data['status'],
          'searchRadiusMeters': (data['searchRadiusMeters'] as num?)?.toDouble() ?? 500.0,
          'nearbyDriversCount': data['nearbyDriversCount'] ?? 0,
          'message': data['message'] ?? 'Ride booked successfully',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Booking failed (${response.statusCode})',
        };
      }
    } catch (e) {
      debugPrint('RideService bookRide error: $e');
      return {
        'success': false,
        'message': 'Unable to connect to server. Check your connection.',
      };
    }
  }

  /// Get current active ride for customer
  Future<Map<String, dynamic>> getActiveRide() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not logged in'};
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/rides/active');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 204) {
        return {'success': true, 'hasActiveRide': false, 'data': null};
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'hasActiveRide': true, 'data': data};
      }

      return {'success': false, 'message': 'Failed to fetch active ride'};
    } catch (e) {
      debugPrint('RideService getActiveRide error: $e');
      return {'success': false, 'message': 'Network error'};
    }
  }

  /// Get details of a specific ride by ID
  Future<Map<String, dynamic>> getRideDetails(int rideId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not logged in'};
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/rides/$rideId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      }

      return {'success': false, 'message': 'Failed to fetch ride details'};
    } catch (e) {
      debugPrint('RideService getRideDetails error: $e');
      return {'success': false, 'message': 'Network error'};
    }
  }

  /// Cancel a ride by ID with optional reason
  Future<Map<String, dynamic>> cancelRide(int rideId, {String? reason}) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not logged in'};
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/rides/$rideId/cancel');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          if (reason != null && reason.trim().isNotEmpty) 'reason': reason.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      }

      return {'success': false, 'message': 'Failed to cancel ride'};
    } catch (e) {
      debugPrint('RideService cancelRide error: $e');
      return {'success': false, 'message': 'Network error'};
    }
  }

  /// Complete a ride by ID (for driver completion testing)
  Future<Map<String, dynamic>> completeRide(int rideId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not logged in'};
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/rides/$rideId/complete-ride');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      }

      return {'success': false, 'message': 'Failed to complete ride'};
    } catch (e) {
      debugPrint('RideService completeRide error: $e');
      return {'success': false, 'message': 'Network error'};
    }
  }

  /// Verify 4-digit OTP and start ride
  Future<Map<String, dynamic>> verifyOtp(int rideId, String otp) async {
    try {
      final token = await _authService.getToken();
      final url = Uri.parse('${ApiConfig.baseUrl}/rides/$rideId/verify-otp?otp=$otp');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      }

      Map<String, dynamic> err = {};
      try {
        err = jsonDecode(response.body);
      } catch (_) {}
      return {
        'success': false,
        'message': err['message'] ?? 'OTP verification failed',
      };
    } catch (e) {
      debugPrint('RideService verifyOtp error: $e');
      return {'success': false, 'message': 'Network error'};
    }
  }

  /// Submit customer rating and review for completed ride
  Future<Map<String, dynamic>> submitRating(int rideId, int rating, String? review) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'Not logged in'};
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/rides/$rideId/rate');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'rating': rating,
          if (review != null && review.trim().isNotEmpty) 'review': review.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      }

      Map<String, dynamic> err = {};
      try {
        err = jsonDecode(response.body);
      } catch (_) {}
      return {'success': false, 'message': err['message'] ?? 'Failed to submit rating'};
    } catch (e) {
      debugPrint('RideService submitRating error: $e');
      return {'success': false, 'message': 'Network error'};
    }
  }
}

