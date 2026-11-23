import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String localHost = 'localhost';
  static const String emulatorHost = '10.0.2.2';
  static const String lanHost = '192.168.1.8';

  /// In-memory cache of the verified working base URL
  static String? _activeBaseUrl;

  /// Base API URL for Spring Boot backend.
  static String get baseUrl {
    if (_activeBaseUrl != null) return _activeBaseUrl!;

    if (kIsWeb) {
      return 'http://$localHost:8080/api';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      // Default to LAN IP for real devices; will fallback to emulator if needed
      return 'http://$lanHost:8080/api';
    }
    return 'http://$localHost:8080/api';
  }

  static void setActiveBaseUrl(String url) {
    _activeBaseUrl = url;
  }

  /// List of candidate base URLs to try in priority order
  static List<String> get candidateUrls {
    if (kIsWeb) {
      return [
        'http://$localHost:8080/api',
        'http://$lanHost:8080/api',
      ];
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return [
        'http://$lanHost:8080/api',
        'http://$emulatorHost:8080/api',
        'http://$localHost:8080/api',
      ];
    }
    return [
      'http://$localHost:8080/api',
      'http://$lanHost:8080/api',
    ];
  }
}
