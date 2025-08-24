import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import 'package:nirva_app/models/s3_credentials.dart';
import 'package:nirva_app/hive_helper.dart';
import 'package:nirva_app/nirva_api.dart';
import 'package:logger/logger.dart';

class S3TokenService {
  static const String _s3CredentialsBox = 's3_credentials_box';
  static const String _s3CredentialsKey = 's3_credentials';
  static final Logger _logger = Logger();
  
  static S3TokenService? _instance;
  static S3TokenService get instance {
    _instance ??= S3TokenService._();
    return _instance!;
  }
  
  S3TokenService._();
  
  S3Credentials? _cachedCredentials;
  
  /// Initialize Hive box for S3 credentials
  static Future<void> initialize() async {
    try {
      _logger.i('S3TokenService: Initializing...');
      
      if (!Hive.isAdapterRegistered(20)) {
        Hive.registerAdapter(S3CredentialsAdapter());
        _logger.i('S3TokenService: Registered S3CredentialsAdapter');
      }
      
      if (!Hive.isBoxOpen(_s3CredentialsBox)) {
        await Hive.openBox<S3Credentials>(_s3CredentialsBox);
        _logger.i('S3TokenService: Opened S3 credentials box');
      }
      
      _logger.i('S3TokenService: Initialization complete');
    } catch (e) {
      _logger.e('S3TokenService: Error during initialization: $e');
      // Don't throw - let app continue
    }
  }
  
  /// Get valid S3 credentials (fetch if needed)
  Future<S3Credentials?> getCredentials({bool forceRefresh = false}) async {
    try {
      debugPrint('S3TokenService: getCredentials called (forceRefresh: $forceRefresh)');
      
      // Check cached credentials first
      if (!forceRefresh && _cachedCredentials != null && !_cachedCredentials!.isExpired) {
        debugPrint('S3TokenService: Using cached S3 credentials (remaining: ${_cachedCredentials!.remainingHours.toStringAsFixed(1)} hours)');
        _logger.i('Using cached S3 credentials (remaining: ${_cachedCredentials!.remainingHours.toStringAsFixed(1)} hours)');
        return _cachedCredentials;
      }
      
      // Check stored credentials in Hive
      debugPrint('S3TokenService: Checking Hive for stored credentials...');
      final box = Hive.box<S3Credentials>(_s3CredentialsBox);
      final storedCredentials = box.get(_s3CredentialsKey);
      
      if (storedCredentials != null) {
        debugPrint('S3TokenService: Found stored credentials, expired: ${storedCredentials.isExpired}, shouldRefresh: ${storedCredentials.shouldRefresh}');
      } else {
        debugPrint('S3TokenService: No stored credentials found');
      }
      
      if (!forceRefresh && storedCredentials != null && !storedCredentials.isExpired) {
        // Check 12-hour cooldown
        if (!storedCredentials.shouldRefresh) {
          debugPrint('S3TokenService: Using stored S3 credentials (remaining: ${storedCredentials.remainingHours.toStringAsFixed(1)} hours)');
          _logger.i('Using stored S3 credentials (remaining: ${storedCredentials.remainingHours.toStringAsFixed(1)} hours)');
          _cachedCredentials = storedCredentials;
          return storedCredentials;
        }
        
        // Credentials are valid but older than 12 hours, optionally refresh
        _logger.i('S3 credentials are ${DateTime.now().difference(storedCredentials.fetchedAt).inHours} hours old, considering refresh');
      }
      
      // Fetch new credentials
      debugPrint('S3TokenService: Need to fetch new S3 credentials from server');
      _logger.i('Fetching new S3 credentials from server');
      final newCredentials = await _fetchCredentialsFromServer();
      
      if (newCredentials != null) {
        // Save to Hive
        await box.put(_s3CredentialsKey, newCredentials);
        _cachedCredentials = newCredentials;
        _logger.i('S3 credentials fetched and saved (valid for ${newCredentials.durationSeconds / 3600} hours)');
      }
      
      return newCredentials;
      
    } catch (e) {
      _logger.e('Error getting S3 credentials: $e');
      return null;
    }
  }
  
  /// Fetch credentials from server
  Future<S3Credentials?> _fetchCredentialsFromServer() async {
    try {
      _logger.i('S3TokenService: Attempting to fetch credentials from server...');
      
      // Get JWT token
      final userToken = HiveHelper.getUserToken();
      debugPrint('S3TokenService: Got user token from Hive, access_token length: ${userToken.access_token.length}');
      
      if (userToken.access_token.isEmpty) {
        debugPrint('S3TokenService: No JWT token available - user may not be logged in yet');
        _logger.w('S3TokenService: No JWT token available - user may not be logged in yet');
        return null;
      }
      
      debugPrint('S3TokenService: JWT token available (first 20 chars): ${userToken.access_token.substring(0, userToken.access_token.length > 20 ? 20 : userToken.access_token.length)}...');
      _logger.i('S3TokenService: JWT token available, calling S3 upload token endpoint...');
      
      // Call S3 upload token endpoint
      final response = await NirvaAPI.dio.post(
        '/action/auth/s3-upload-token/v1/',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${userToken.access_token}',
          },
        ),
      );
      
      if (response.statusCode == 200 && response.data != null) {
        _logger.i('S3TokenService: Successfully received S3 credentials from server');
        return S3Credentials.fromJson(response.data);
      }
      
      _logger.e('S3TokenService: Failed to fetch S3 credentials - status: ${response.statusCode}');
      return null;
      
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        _logger.w('S3TokenService: JWT token expired or invalid (401)');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        _logger.e('S3TokenService: Connection timeout fetching S3 credentials');
      } else if (e.type == DioExceptionType.connectionError) {
        _logger.e('S3TokenService: Connection error - server may be unreachable');
      } else {
        _logger.e('S3TokenService: DioException - ${e.type}: ${e.message}');
        if (e.response != null) {
          _logger.e('S3TokenService: Response status: ${e.response?.statusCode}');
          _logger.e('S3TokenService: Response data: ${e.response?.data}');
        }
      }
      return null;
    } catch (e) {
      _logger.e('S3TokenService: Unexpected error fetching S3 credentials: $e');
      return null;
    }
  }
  
  /// Clear stored credentials (e.g., on logout)
  Future<void> clearCredentials() async {
    try {
      final box = Hive.box<S3Credentials>(_s3CredentialsBox);
      await box.delete(_s3CredentialsKey);
      _cachedCredentials = null;
      _logger.i('S3 credentials cleared');
    } catch (e) {
      _logger.e('Error clearing S3 credentials: $e');
    }
  }
  
  /// Get credentials status for debugging
  Map<String, dynamic> getStatus() {
    final credentials = _cachedCredentials;
    if (credentials == null) {
      return {'status': 'No credentials cached'};
    }
    
    return {
      'status': credentials.isExpired ? 'Expired' : 'Valid',
      'remainingHours': credentials.remainingHours.toStringAsFixed(1),
      'fetchedAt': credentials.fetchedAt.toIso8601String(),
      'shouldRefresh': credentials.shouldRefresh,
      'bucket': credentials.bucket,
      'prefix': credentials.prefix,
    };
  }
}