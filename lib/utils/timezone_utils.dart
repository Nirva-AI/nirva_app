import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:logger/logger.dart';

/// Utility class for handling timezone operations
class TimezoneUtils {
  static final Logger _logger = Logger();
  static bool _initialized = false;

  /// Get the device's timezone as a proper IANA timezone name
  /// Returns names like "America/Los_Angeles" instead of abbreviations like "PDT"
  static String getDeviceTimezone() {
    try {
      // Ensure timezone data is initialized
      if (!_initialized) {
        initialize();
      }
      
      // Get the device's current timezone offset
      final DateTime now = DateTime.now();
      final Duration offset = now.timeZoneOffset;
      final DateTime utcNow = now.toUtc();
      
      // Try to find the timezone by offset and DST rules
      final String timezoneName = _findTimezoneByOffset(offset, now);
      return timezoneName;
    } catch (e) {
_logger.e('Error getting device timezone: $e');
      // Fallback to UTC if there's any issue
      return 'UTC';
    }
  }
  
  /// Find timezone name by offset and current time (to account for DST)
  static String _findTimezoneByOffset(Duration offset, DateTime now) {
    // First, try to get the system timezone directly using multiple methods
    try {
      // Method 1: tz.local.name
      final String systemTimezone = tz.local.name;
      // Method 2: Try to get timezone from DateTime.now() zone name (if available)
      try {
        final String zoneName = now.timeZoneName;
        
        // If we get a proper IANA name from the system, use it
        if (systemTimezone.isNotEmpty && 
            systemTimezone != 'Local' && 
            systemTimezone.contains('/')) {
          return systemTimezone;
        }
        
        // Try to convert timezone abbreviation to IANA name
        if (zoneName.isNotEmpty) {
          final String? convertedTz = _convertAbbreviationToIANA(zoneName, offset);
          if (convertedTz != null) {
            return convertedTz;
          }
        }
      } catch (e) {
_logger.w('Error getting timeZoneName: $e');
      }
      
    } catch (e) {
_logger.w('Could not get system timezone: $e');
    }
    
    // If system timezone fails, fall back to offset-based detection
    final int offsetHours = offset.inHours;
    final bool isDST = _isDaylightSavingTime(now);
    
    
    // Global timezone mapping by offset - one representative timezone per offset
    final Map<int, String> timezonesByOffset = {
      -12: 'Pacific/Kwajalein',
      -11: 'Pacific/Midway',
      -10: 'Pacific/Honolulu',
      -9: 'America/Anchorage',
      -8: 'America/Los_Angeles',
      -7: 'America/Denver',
      -6: 'America/Chicago',
      -5: 'America/New_York',
      -4: 'America/Santiago',
      -3: 'America/Sao_Paulo',
      -2: 'Atlantic/South_Georgia',
      -1: 'Atlantic/Azores',
      0: 'Europe/London',
      1: 'Europe/Paris',
      2: 'Europe/Helsinki',
      3: 'Europe/Moscow',
      4: 'Asia/Dubai',
      5: 'Asia/Karachi',
      6: 'Asia/Dhaka',
      7: 'Asia/Bangkok',
      8: 'Asia/Shanghai',
      9: 'Asia/Tokyo',
      10: 'Australia/Sydney',
      11: 'Asia/Magadan',
      12: 'Pacific/Auckland',
      13: 'Pacific/Tongatapu',
      14: 'Pacific/Kiritimati',
    };
    
    // Get timezone for this offset
    final String? selectedTimezone = timezonesByOffset[offsetHours];
    
    if (selectedTimezone != null) {
      return selectedTimezone;
    }
    
    // If we still can't find it, use UTC as fallback
    _logger.w('Unknown timezone offset: ${offsetHours}h, using UTC');
    return 'UTC';
  }
  
  /// Convert timezone abbreviation to IANA timezone name
  static String? _convertAbbreviationToIANA(String abbreviation, Duration offset) {
    final int offsetHours = offset.inHours;
    
    // Map common timezone abbreviations to IANA names based on offset
    final Map<String, Map<int, String>> abbreviationMap = {
      'PST': {-8: 'America/Los_Angeles'},
      'PDT': {-7: 'America/Los_Angeles'},
      'MST': {-7: 'America/Denver'},
      'MDT': {-6: 'America/Denver'},
      'CST': {-6: 'America/Chicago'},
      'CDT': {-5: 'America/Chicago'},
      'EST': {-5: 'America/New_York'},
      'EDT': {-4: 'America/New_York'},
      'GMT': {0: 'UTC'},
      'UTC': {0: 'UTC'},
    };
    
    final Map<int, String>? offsetMap = abbreviationMap[abbreviation];
    if (offsetMap != null && offsetMap.containsKey(offsetHours)) {
      return offsetMap[offsetHours];
    }
    
    return null;
  }

  /// Simple DST detection for US (not perfect but good enough)
  static bool _isDaylightSavingTime(DateTime now) {
    // In the US, DST typically runs from second Sunday in March to first Sunday in November
    // This is a simplified check
    final int month = now.month;
    return month >= 3 && month <= 10; // Rough approximation
  }
  
  /// Initialize timezone data (should be called once at app startup)
  static void initialize() {
    try {
      if (!_initialized) {
        tz.initializeTimeZones();
        _logger.i('Timezone data initialized successfully');
        _initialized = true;
      }
    } catch (e) {
      _logger.e('Error initializing timezone data: $e');
    }
  }
}