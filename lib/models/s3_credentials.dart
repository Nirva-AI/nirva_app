import 'package:hive/hive.dart';

part 's3_credentials.g.dart';

@HiveType(typeId: 20) // Make sure this typeId is unique in your app
class S3Credentials extends HiveObject {
  @HiveField(0)
  final String accessKeyId;
  
  @HiveField(1)
  final String secretAccessKey;
  
  @HiveField(2)
  final String sessionToken;
  
  @HiveField(3)
  final String expiration; // ISO format string
  
  @HiveField(4)
  final String bucket;
  
  @HiveField(5)
  final String prefix;
  
  @HiveField(6)
  final String region;
  
  @HiveField(7)
  final int durationSeconds;
  
  @HiveField(8)
  final DateTime fetchedAt; // Track when we fetched these credentials
  
  S3Credentials({
    required this.accessKeyId,
    required this.secretAccessKey,
    required this.sessionToken,
    required this.expiration,
    required this.bucket,
    required this.prefix,
    required this.region,
    required this.durationSeconds,
    required this.fetchedAt,
  });
  
  /// Check if credentials are expired
  bool get isExpired {
    try {
      final expirationDate = DateTime.parse(expiration);
      return DateTime.now().isAfter(expirationDate);
    } catch (e) {
      return true; // Consider expired if we can't parse
    }
  }
  
  /// Check if we should refresh (12-hour cooldown)
  // COMMENTED OUT: Removing 12-hour cooldown to refresh credentials on every app foreground
  bool get shouldRefresh {
    // final twelveHoursAgo = DateTime.now().subtract(const Duration(hours: 12));
    // return fetchedAt.isBefore(twelveHoursAgo);
    return true; // Always refresh when app comes to foreground
  }
  
  /// Get remaining validity in hours
  double get remainingHours {
    try {
      final expirationDate = DateTime.parse(expiration);
      final remaining = expirationDate.difference(DateTime.now());
      return remaining.inMinutes / 60.0;
    } catch (e) {
      return 0;
    }
  }
  
  /// Convert to map for native platform
  Map<String, dynamic> toMap() {
    return {
      'accessKeyId': accessKeyId,
      'secretAccessKey': secretAccessKey,
      'sessionToken': sessionToken,
      'expiration': expiration,
      'bucket': bucket,
      'prefix': prefix,
      'region': region,
      'durationSeconds': durationSeconds,
      'fetchedAt': fetchedAt.toIso8601String(),
    };
  }
  
  /// Create from server response
  factory S3Credentials.fromJson(Map<String, dynamic> json) {
    return S3Credentials(
      accessKeyId: json['access_key_id'] ?? '',
      secretAccessKey: json['secret_access_key'] ?? '',
      sessionToken: json['session_token'] ?? '',
      expiration: json['expiration'] ?? '',
      bucket: json['bucket'] ?? '',
      prefix: json['prefix'] ?? '',
      region: json['region'] ?? 'us-east-1',
      durationSeconds: json['duration_seconds'] ?? 129600, // 36 hours default
      fetchedAt: DateTime.now(),
    );
  }
}