import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nirva_app/models/s3_credentials.dart';
import 'package:nirva_app/services/s3_token_service.dart';
import 'package:nirva_app/hive_helper.dart';
import 'package:logger/logger.dart';

class NativeS3Bridge {
  static const MethodChannel _channel = MethodChannel('com.nirva.ble_audio_v2');
  static final Logger _logger = Logger();
  
  static NativeS3Bridge? _instance;
  static NativeS3Bridge get instance {
    _instance ??= NativeS3Bridge._();
    return _instance!;
  }
  
  NativeS3Bridge._();
  
  /// Initialize and send credentials to native side
  Future<void> initialize() async {
    try {
      debugPrint('NativeS3Bridge: Starting initialization...');
      _logger.i('NativeS3Bridge: Starting initialization...');
      
      // Initialize S3 token service
      await S3TokenService.initialize();
      debugPrint('NativeS3Bridge: S3TokenService initialized');
      _logger.i('NativeS3Bridge: S3TokenService initialized');
      
      // Set up periodic credential refresh (every 6 hours)
      _setupPeriodicRefresh();
      debugPrint('NativeS3Bridge: Periodic refresh configured');
      _logger.i('NativeS3Bridge: Periodic refresh configured');
      
      // Fetch credentials asynchronously to not block app startup
      _fetchAndSendCredentialsAsync();
      
    } catch (e) {
      debugPrint('Error initializing NativeS3Bridge: $e');
      _logger.e('Error initializing NativeS3Bridge: $e');
      // Don't throw - let app continue without S3 credentials
    }
  }
  
  /// Fetch and send credentials asynchronously
  Future<void> _fetchAndSendCredentialsAsync() async {
    try {
      debugPrint('NativeS3Bridge: Fetching S3 credentials asynchronously...');
      _logger.i('NativeS3Bridge: Fetching S3 credentials asynchronously...');
      
      // Wait a bit for app to fully initialize
      await Future.delayed(const Duration(seconds: 2));
      
      // Get or fetch credentials
      debugPrint('NativeS3Bridge: Calling S3TokenService.getCredentials()...');
      final credentials = await S3TokenService.instance.getCredentials();
      
      if (credentials != null) {
        debugPrint('NativeS3Bridge: Got credentials, sending to native...');
        await sendCredentialsToNative(credentials);
        debugPrint('S3 credentials sent to native side successfully');
        _logger.i('S3 credentials sent to native side');
      } else {
        debugPrint('NativeS3Bridge: No S3 credentials available - will retry in 30s');
        _logger.w('No S3 credentials available - will retry later');
        // Retry after 30 seconds
        Future.delayed(const Duration(seconds: 30), () {
          _fetchAndSendCredentialsAsync();
        });
      }
    } catch (e) {
      debugPrint('NativeS3Bridge: Error fetching S3 credentials: $e');
      _logger.e('Error fetching S3 credentials: $e');
      // Retry after 30 seconds
      Future.delayed(const Duration(seconds: 30), () {
        _fetchAndSendCredentialsAsync();
      });
    }
  }
  
  /// Send S3 credentials to native iOS
  Future<bool> sendCredentialsToNative(S3Credentials credentials) async {
    try {
      // Get user info
      final userToken = HiveHelper.getUserToken();
      final userId = userToken.access_token.isNotEmpty ? 
        _extractUserIdFromToken(userToken.access_token) : 'default_user';
      
      // Prepare credentials map
      final credentialsMap = credentials.toMap();
      credentialsMap['userId'] = userId;
      
      // Send to native
      final result = await _channel.invokeMethod('setS3Credentials', credentialsMap);
      
      _logger.i('S3 credentials updated on native side');
      
      // After sending credentials, trigger processing of any queued uploads
      // This is important for first launch when uploads may have been queued before credentials were available
      try {
        await processQueuedUploads();
        _logger.i('Triggered processing of queued uploads after credentials update');
      } catch (e) {
        _logger.w('Failed to trigger queued uploads processing: $e');
      }
      
      return result == true;
      
    } catch (e) {
      _logger.e('Error sending credentials to native: $e');
      return false;
    }
  }
  
  /// Get upload queue status from native
  Future<Map<String, dynamic>> getUploadQueueStatus() async {
    try {
      final result = await _channel.invokeMethod('getUploadQueueStatus');
      return Map<String, dynamic>.from(result ?? {});
    } catch (e) {
      _logger.e('Error getting upload queue status: $e');
      return {};
    }
  }
  
  /// Manually trigger processing of queued uploads
  Future<void> processQueuedUploads() async {
    try {
      await _channel.invokeMethod('processQueuedUploads');
      _logger.i('Triggered processing of queued uploads');
    } catch (e) {
      _logger.e('Error processing queued uploads: $e');
    }
  }
  
  /// Refresh credentials if needed (called after login)
  Future<void> refreshCredentialsIfNeeded() async {
    try {
      _logger.i('NativeS3Bridge: Refreshing credentials after login...');
      
      // First try to get existing credentials
      var credentials = await S3TokenService.instance.getCredentials();
      
      // If no credentials exist or they're expired, force fetch new ones
      if (credentials == null || credentials.isExpired) {
        _logger.i('NativeS3Bridge: No valid credentials, fetching new ones...');
        credentials = await S3TokenService.instance.getCredentials(forceRefresh: true);
      }
      
      if (credentials != null) {
        await sendCredentialsToNative(credentials);
        _logger.i('S3 credentials sent to native side after login');
      } else {
        _logger.w('Failed to fetch S3 credentials after login');
        // Schedule retry
        Future.delayed(const Duration(seconds: 10), () {
          _fetchAndSendCredentialsAsync();
        });
      }
    } catch (e) {
      _logger.e('Error refreshing credentials: $e');
      // Schedule retry
      Future.delayed(const Duration(seconds: 10), () {
        _fetchAndSendCredentialsAsync();
      });
    }
  }
  
  /// Set up periodic credential refresh
  void _setupPeriodicRefresh() {
    // Check every 6 hours
    Stream.periodic(const Duration(hours: 6)).listen((_) {
      refreshCredentialsIfNeeded();
    });
    
    // Also refresh on app resume
    WidgetsBinding.instance.addObserver(_AppLifecycleObserver(this));
  }
  
  /// Extract user ID from JWT token (basic implementation)
  String _extractUserIdFromToken(String token) {
    try {
      // JWT tokens have 3 parts separated by dots
      final parts = token.split('.');
      if (parts.length != 3) return 'default_user';
      
      // Decode the payload (second part)
      // Note: This is a simplified extraction, you might need to properly decode the JWT
      // For now, we'll use the token as a unique identifier
      return token.substring(0, 8); // Use first 8 chars as user ID
      
    } catch (e) {
      return 'default_user';
    }
  }
}

/// App lifecycle observer to refresh credentials on resume
class _AppLifecycleObserver extends WidgetsBindingObserver {
  final NativeS3Bridge bridge;
  
  _AppLifecycleObserver(this.bridge);
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh credentials when app comes to foreground
      bridge.refreshCredentialsIfNeeded();
    }
  }
}