import 'package:flutter/foundation.dart';

/// App settings service for managing application configuration
///
/// This service handles persistent storage of app settings.
/// Cloud ASR is the only supported audio processing mode.
class AppSettingsService extends ChangeNotifier {

  // Cloud ASR is the only supported mode
  bool get cloudAsrEnabled => true;

  /// Initialize the settings service
  Future<void> initialize() async {
    try {
      debugPrint('AppSettingsService: Initializing settings service...');
      debugPrint('AppSettingsService: Cloud ASR enabled (single mode)');
      notifyListeners();
    } catch (e) {
      debugPrint('AppSettingsService: Error initializing settings: $e');
    }
  }

  /// Get current settings summary
  Map<String, dynamic> getSettingsSummary() {
    return {
      'cloudAsrEnabled': cloudAsrEnabled,
      'currentMode': 'Cloud ASR',
    };
  }
}