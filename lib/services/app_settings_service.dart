import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App settings service for managing application configuration
/// 
/// This service handles persistent storage of app settings including
/// ASR mode preferences
class AppSettingsService extends ChangeNotifier {
  static const String _localAsrEnabledKey = 'local_asr_enabled';
  
  // Default settings
  bool _localAsrEnabled = false; // Hardcoded to false as requested
  
  // Getters
  bool get localAsrEnabled => _localAsrEnabled;
  bool get cloudAsrEnabled => !_localAsrEnabled;
  
  /// Initialize the settings service
  Future<void> initialize() async {
    try {
      debugPrint('AppSettingsService: Initializing settings service...');
      
      // Load settings from persistent storage
      await _loadSettings();
      
      debugPrint('AppSettingsService: Settings loaded - Local ASR: $_localAsrEnabled');
      notifyListeners();
      
    } catch (e) {
      debugPrint('AppSettingsService: Error initializing settings: $e');
      // Use default values if loading fails
      _localAsrEnabled = false;
    }
  }
  
  /// Toggle between local and cloud ASR modes
  Future<void> toggleAsrMode() async {
    _localAsrEnabled = !_localAsrEnabled;
    await _saveSettings();
    notifyListeners();
    
    debugPrint('AppSettingsService: ASR mode toggled - Local ASR: $_localAsrEnabled');
  }
  
  /// Set local ASR enabled/disabled
  Future<void> setLocalAsrEnabled(bool enabled) async {
    if (_localAsrEnabled != enabled) {
      _localAsrEnabled = enabled;
      await _saveSettings();
      notifyListeners();
      
      debugPrint('AppSettingsService: Local ASR setting changed to: $_localAsrEnabled');
    }
  }
  
  /// Load settings from persistent storage
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _localAsrEnabled = prefs.getBool(_localAsrEnabledKey) ?? false;
      
      debugPrint('AppSettingsService: Settings loaded from storage');
      
    } catch (e) {
      debugPrint('AppSettingsService: Error loading settings: $e');
      // Use default values if loading fails
      _localAsrEnabled = false;
    }
  }
  
  /// Save settings to persistent storage
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_localAsrEnabledKey, _localAsrEnabled);
      
      debugPrint('AppSettingsService: Settings saved to storage');
      
    } catch (e) {
      debugPrint('AppSettingsService: Error saving settings: $e');
    }
  }
  
  /// Get current settings summary
  Map<String, dynamic> getSettingsSummary() {
    return {
      'localAsrEnabled': _localAsrEnabled,
      'cloudAsrEnabled': cloudAsrEnabled,
      'currentMode': _localAsrEnabled ? 'Local ASR' : 'Cloud ASR',
    };
  }
  
  /// Reset settings to defaults
  Future<void> resetToDefaults() async {
    _localAsrEnabled = false;
    await _saveSettings();
    notifyListeners();
    
    debugPrint('AppSettingsService: Settings reset to defaults');
  }
}
