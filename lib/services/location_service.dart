import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RouteDetails {
  final List<LatLng> polylinePoints;
  final double distanceKm;
  final String distanceText;
  final String durationText;

  const RouteDetails({
    required this.polylinePoints,
    required this.distanceKm,
    required this.distanceText,
    required this.durationText,
  });
}

class LocationResult {
  final String displayName;
  final String shortName;
  final double latitude;
  final double longitude;

  LocationResult({
    required this.displayName,
    required this.shortName,
    required this.latitude,
    required this.longitude,
  });

  factory LocationResult.fromJson(Map<String, dynamic> json) {
    final double lat = double.tryParse(json['lat']?.toString() ?? '0.0') ?? 0.0;
    final double lon = double.tryParse(json['lon']?.toString() ?? '0.0') ?? 0.0;
    final String full = json['display_name'] ?? '';

    String short = full;
    if (json.containsKey('address') && json['address'] is Map) {
      final addr = json['address'] as Map<String, dynamic>;
      final road = addr['road'] ?? addr['suburb'] ?? addr['neighbourhood'] ?? addr['commercial'];
      final city = addr['city'] ?? addr['town'] ?? addr['village'] ?? addr['county'];
      if (road != null && city != null) {
        short = '$road, $city';
      } else if (road != null) {
        short = '$road';
      } else if (city != null) {
        short = '$city';
      }
    }

    return LocationResult(
      displayName: full,
      shortName: short,
      latitude: lat,
      longitude: lon,
    );
  }
}

class LocationService {
  static const String googleMapsApiKey = 'AIzaSyBwvYyfR1gnz2zzG-l4Fd43PfqUGEIjUeU';

  // Default coordinates (Pune, Maharashtra as central reference)
  static const LatLng defaultLocation = LatLng(18.5204, 73.8567);

  static BitmapDescriptor? _pickupMarkerIcon;
  static BitmapDescriptor? _destinationMarkerIcon;
  static BitmapDescriptor? _autoMarkerIcon;

  /// Custom yellow auto-rickshaw circular marker
  static Future<BitmapDescriptor> getAutoMarkerIcon() async {
    if (_autoMarkerIcon != null) return _autoMarkerIcon!;
    try {
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      const double size = 64.0;

      // Shadow
      final Paint shadowPaint = Paint()
        ..color = const Color(0x33000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(const Offset(size / 2, size / 2 + 2), size * 0.42, shadowPaint);

      // Yellow circle body
      final Paint circlePaint = Paint()
        ..color = const Color(0xFFFFD329)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(const Offset(size / 2, size / 2), size * 0.42, circlePaint);

      // Dark border
      final Paint borderPaint = Paint()
        ..color = const Color(0xFF1D1B20)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;
      canvas.drawCircle(const Offset(size / 2, size / 2), size * 0.42, borderPaint);

      // Inner dot
      final Paint innerDot = Paint()
        ..color = const Color(0xFF1D1B20)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(const Offset(size / 2, size / 2), size * 0.16, innerDot);

      final ui.Image image = await pictureRecorder.endRecording().toImage(size.toInt(), size.toInt());
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        _autoMarkerIcon = BitmapDescriptor.bytes(
          byteData.buffer.asUint8List(),
          width: 26,
          height: 26,
        );
        return _autoMarkerIcon!;
      }
    } catch (e) {
      debugPrint('Failed to generate auto marker: $e');
    }
    _autoMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    return _autoMarkerIcon!;
  }

  /// Custom green marker for pickup locations (compact, mobile-optimized size)
  static Future<BitmapDescriptor> getPickupMarkerIcon() async {
    if (_pickupMarkerIcon != null) return _pickupMarkerIcon!;
    try {
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      const double width = 60.0;
      const double height = 75.0;

      // Drop shadow under tip
      final Paint shadowPaint = Paint()
        ..color = const Color(0x38000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
      canvas.drawOval(
        Rect.fromCenter(center: const Offset(width / 2, height - 3), width: 14, height: 6),
        shadowPaint,
      );

      // Pin body in vibrant green
      final Paint pinPaint = Paint()
        ..color = const Color(0xFF2ECC71)
        ..style = PaintingStyle.fill;

      final Path path = Path();
      path.moveTo(width / 2, height - 5);
      path.quadraticBezierTo(width * 0.1, height * 0.55, width * 0.1, height * 0.35);
      path.arcToPoint(
        const Offset(width * 0.9, height * 0.35),
        radius: const Radius.circular(width * 0.4),
        clockwise: true,
      );
      path.quadraticBezierTo(width * 0.9, height * 0.55, width / 2, height - 5);
      path.close();

      canvas.drawPath(path, pinPaint);

      // Dark green border outline
      final Paint borderPaint = Paint()
        ..color = const Color(0xFF1E824C)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawPath(path, borderPaint);

      // White inner circle
      final Paint whiteDot = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(const Offset(width / 2, height * 0.35), width * 0.14, whiteDot);

      final ui.Image image = await pictureRecorder.endRecording().toImage(width.toInt(), height.toInt());
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        _pickupMarkerIcon = BitmapDescriptor.bytes(
          byteData.buffer.asUint8List(),
          width: 25,
          height: 31,
        );
        return _pickupMarkerIcon!;
      }
    } catch (e) {
      debugPrint('Failed to generate pickup marker: $e');
    }
    _pickupMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    return _pickupMarkerIcon!;
  }

  /// Custom red marker for destination locations (compact, mobile-optimized size)
  static Future<BitmapDescriptor> getDestinationMarkerIcon() async {
    if (_destinationMarkerIcon != null) return _destinationMarkerIcon!;
    try {
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      const double width = 60.0;
      const double height = 75.0;

      // Drop shadow under tip
      final Paint shadowPaint = Paint()
        ..color = const Color(0x38000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
      canvas.drawOval(
        Rect.fromCenter(center: const Offset(width / 2, height - 3), width: 14, height: 6),
        shadowPaint,
      );

      // Pin body in vibrant red
      final Paint pinPaint = Paint()
        ..color = const Color(0xFFE74C3C)
        ..style = PaintingStyle.fill;

      final Path path = Path();
      path.moveTo(width / 2, height - 5);
      path.quadraticBezierTo(width * 0.1, height * 0.55, width * 0.1, height * 0.35);
      path.arcToPoint(
        const Offset(width * 0.9, height * 0.35),
        radius: const Radius.circular(width * 0.4),
        clockwise: true,
      );
      path.quadraticBezierTo(width * 0.9, height * 0.55, width / 2, height - 5);
      path.close();

      canvas.drawPath(path, pinPaint);

      // Dark red border outline
      final Paint borderPaint = Paint()
        ..color = const Color(0xFFC0392B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawPath(path, borderPaint);

      // White inner circle
      final Paint whiteDot = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(const Offset(width / 2, height * 0.35), width * 0.14, whiteDot);

      final ui.Image image = await pictureRecorder.endRecording().toImage(width.toInt(), height.toInt());
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        _destinationMarkerIcon = BitmapDescriptor.bytes(
          byteData.buffer.asUint8List(),
          width: 25,
          height: 31,
        );
        return _destinationMarkerIcon!;
      }
    } catch (e) {
      debugPrint('Failed to generate destination marker: $e');
    }
    _destinationMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    return _destinationMarkerIcon!;
  }

  /// Fetch user's current GPS location with permission checks
  static Future<LatLng> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint("Location services are disabled. Using default location.");
        return defaultLocation;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint("Location permission denied. Using default location.");
          return defaultLocation;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint("Location permission permanently denied. Using default location.");
        return defaultLocation;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint("Error fetching GPS location: $e");
      return defaultLocation;
    }
  }

  /// Reverse geocode latitude and longitude to a human-readable address
  static Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    // 1. Attempt Google Geocoding API with API key
    try {
      final googleUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleMapsApiKey',
      );
      final res = await http.get(googleUrl).timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['status'] == 'OK' && data['results'] != null && (data['results'] as List).isNotEmpty) {
          final formatted = data['results'][0]['formatted_address'];
          if (formatted != null && formatted.toString().isNotEmpty) {
            final parts = formatted.toString().split(',');
            if (parts.length >= 3) {
              return '${parts[0].trim()}, ${parts[1].trim()}, ${parts[2].trim()}';
            }
            return formatted.toString();
          }
        }
      }
    } catch (_) {}

    // 2. Fallback to Nominatim
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1',
      );

      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'MeterSayCustomerApp/1.0 (contact@metersay.com)',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          if (data.containsKey('address') && data['address'] is Map) {
            final addr = data['address'] as Map<String, dynamic>;
            final parts = <String>[];

            final name = addr['amenity'] ?? addr['building'] ?? addr['road'];
            if (name != null) parts.add(name.toString());

            final sub = addr['suburb'] ?? addr['neighbourhood'] ?? addr['residential'];
            if (sub != null && !parts.contains(sub.toString())) parts.add(sub.toString());

            final city = addr['city'] ?? addr['town'] ?? addr['village'] ?? addr['city_district'];
            if (city != null && !parts.contains(city.toString())) parts.add(city.toString());

            if (parts.isNotEmpty) {
              return parts.join(', ');
            }
          }

          if (data['display_name'] != null) {
            final String full = data['display_name'];
            final split = full.split(',');
            if (split.length >= 3) {
              return '${split[0].trim()}, ${split[1].trim()}, ${split[2].trim()}';
            }
            return full;
          }
        }
      }
    } catch (e) {
      debugPrint("Error reverse geocoding: $e");
    }

    return 'Location (${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)})';
  }

  /// Search locations matching a query string
  static Future<List<LocationResult>> searchLocations(String query) async {
    if (query.trim().isEmpty) return [];

    // 1. Attempt Google Geocoding API with user's Google Maps API key
    try {
      final googleUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(query)}&components=country:in&key=$googleMapsApiKey',
      );
      final response = await http.get(googleUrl).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK' && data['results'] != null && (data['results'] as List).isNotEmpty) {
          final List results = data['results'];
          return results.map<LocationResult>((item) {
            final full = item['formatted_address']?.toString() ?? '';
            final loc = item['geometry']?['location'] ?? {};
            final lat = (loc['lat'] as num?)?.toDouble() ?? 0.0;
            final lon = (loc['lng'] as num?)?.toDouble() ?? 0.0;

            String short = full;
            if (item['address_components'] is List) {
              final comps = item['address_components'] as List;
              String? sublocality;
              String? locality;
              for (var c in comps) {
                final types = (c['types'] as List?) ?? [];
                if (types.contains('sublocality') ||
                    types.contains('neighborhood') ||
                    types.contains('point_of_interest') ||
                    types.contains('route')) {
                  sublocality ??= c['long_name'];
                } else if (types.contains('locality')) {
                  locality ??= c['long_name'];
                }
              }
              if (sublocality != null && locality != null) {
                short = '$sublocality, $locality';
              } else if (sublocality != null) {
                short = sublocality;
              } else if (locality != null) {
                short = locality;
              }
            }

            if (short == full) {
              final parts = full.split(',');
              if (parts.length >= 2) {
                short = '${parts[0].trim()}, ${parts[1].trim()}';
              }
            }

            return LocationResult(
              displayName: full,
              shortName: short,
              latitude: lat,
              longitude: lon,
            );
          }).toList();
        }
      }
    } catch (e) {
      debugPrint("Google Geocoding search error: $e");
    }

    // 2. Fallback to Nominatim
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/search?format=json&q=${Uri.encodeComponent(query)}&countrycodes=in&limit=6&addressdetails=1',
      );

      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'MeterSayCustomerApp/1.0 (contact@metersay.com)',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final List list = jsonDecode(response.body);
        return list.map((item) => LocationResult.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint("Error searching locations: $e");
    }

    return [];
  }

  /// Fetch shortest driving route coordinates, distance in km, and duration
  static Future<RouteDetails> getShortestRoute(LatLng start, LatLng destination) async {
    // 1. Attempt Google Directions API with user's Google Maps API key
    try {
      final googleUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${destination.latitude},${destination.longitude}&mode=driving&key=$googleMapsApiKey',
      );
      final response = await http.get(googleUrl).timeout(const Duration(seconds: 6));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK' && data['routes'] != null && (data['routes'] as List).isNotEmpty) {
          final route = data['routes'][0];
          final polylineStr = route['overview_polyline']['points'];
          final legs = route['legs'][0];
          final double distanceMeters = (legs['distance']['value'] as num).toDouble();
          final double distanceKm = distanceMeters / 1000.0;
          final String distanceText = legs['distance']['text'] ?? '${distanceKm.toStringAsFixed(1)} km';
          final String durationText = legs['duration']['text'] ?? '10 mins';

          final List<LatLng> points = decodePolyline(polylineStr);
          return RouteDetails(
            polylinePoints: points,
            distanceKm: distanceKm,
            distanceText: distanceText,
            durationText: durationText,
          );
        }
      }
    } catch (e) {
      debugPrint("Google Directions API error: $e");
    }

    // 2. High-speed OSRM routing fallback (computes exact road geometry and distance)
    try {
      final uri = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=geojson',
      );

      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'MeterSayCustomerApp/1.0 (contact@metersay.com)',
        },
      ).timeout(const Duration(seconds: 7));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['routes'] != null && (data['routes'] as List).isNotEmpty) {
          final route = data['routes'][0];
          final coordinates = route['geometry']['coordinates'] as List;
          final List<LatLng> points = coordinates.map<LatLng>((coord) {
            return LatLng(
              (coord[1] as num).toDouble(),
              (coord[0] as num).toDouble(),
            );
          }).toList();

          final double distanceMeters = (route['distance'] as num).toDouble();
          final double distanceKm = distanceMeters / 1000.0;
          final double durationSeconds = (route['duration'] as num).toDouble();
          final int minutes = max(2, (durationSeconds / 60.0).round());

          return RouteDetails(
            polylinePoints: points,
            distanceKm: distanceKm,
            distanceText: '${distanceKm.toStringAsFixed(1)} km',
            durationText: '$minutes mins',
          );
        }
      }
    } catch (e) {
      debugPrint("Error fetching road route: $e");
    }

    // 3. Fallback Haversine straight line
    final double distKm = calculateHaversineKm(start.latitude, start.longitude, destination.latitude, destination.longitude);
    final int etaMin = max(2, (distKm / 25.0 * 60.0).round());
    return RouteDetails(
      polylinePoints: [start, destination],
      distanceKm: distKm,
      distanceText: '${distKm.toStringAsFixed(1)} km',
      durationText: '$etaMin mins',
    );
  }

  /// Decode Google encoded polyline string
  static List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  /// Haversine formula in kilometers
  static double calculateHaversineKm(double lat1, double lon1, double lat2, double lon2) {
    const double p = 0.017453292519943295;
    final double a = 0.5 - cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  /// Backward compatible wrapper
  static Future<List<LatLng>> getRouteCoordinates(LatLng start, LatLng destination) async {
    final details = await getShortestRoute(start, destination);
    return details.polylinePoints;
  }
}
