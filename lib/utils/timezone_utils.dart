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
      
      _logger.i('Device timezone offset: ${offset.inHours} hours');
      
      // Try to find the timezone by offset and DST rules
      final String timezoneName = _findTimezoneByOffset(offset, now);
      
      _logger.i('Device timezone: $timezoneName');
      return timezoneName;
    } catch (e) {
      _logger.e('Error getting device timezone: $e');
      // Fallback to UTC if there's any issue
      return 'UTC';
    }
  }
  
  /// Find timezone name by offset and current time (to account for DST)
  static String _findTimezoneByOffset(Duration offset, DateTime now) {
    // First, try to get the system timezone directly
    try {
      final String systemTimezone = tz.local.name;
      if (systemTimezone.isNotEmpty && systemTimezone != 'Local') {
        _logger.i('Using system timezone: $systemTimezone');
        return systemTimezone;
      }
    } catch (e) {
      _logger.w('Could not get system timezone: $e');
    }
    
    // If system timezone fails, fall back to offset-based detection
    final int offsetHours = offset.inHours;
    final bool isDST = _isDaylightSavingTime(now);
    
    _logger.i('Falling back to offset-based detection: ${offsetHours}h, DST: $isDST');
    
    // Comprehensive timezone mapping by offset
    final Map<int, List<String>> timezonesByOffset = {
      -12: ['Pacific/Kwajalein'],
      -11: ['Pacific/Midway', 'Pacific/Niue', 'Pacific/Pago_Pago'],
      -10: ['Pacific/Honolulu', 'Pacific/Tahiti'],
      -9: ['America/Anchorage', 'Pacific/Gambier'],
      -8: ['America/Los_Angeles', 'America/Tijuana', 'Pacific/Pitcairn'],
      -7: isDST ? ['America/Los_Angeles'] : ['America/Denver', 'America/Phoenix'],
      -6: isDST ? ['America/Denver'] : ['America/Chicago', 'America/Mexico_City'],
      -5: isDST ? ['America/Chicago'] : ['America/New_York', 'America/Lima'],
      -4: isDST ? ['America/New_York'] : ['America/Santiago', 'Atlantic/Bermuda'],
      -3: ['America/Sao_Paulo', 'America/Argentina/Buenos_Aires'],
      -2: ['Atlantic/South_Georgia'],
      -1: ['Atlantic/Azores', 'Atlantic/Cape_Verde'],
      0: ['UTC', 'Europe/London', 'Africa/Casablanca'],
      1: ['Europe/Paris', 'Europe/Berlin', 'Africa/Lagos'],
      2: ['Europe/Helsinki', 'Africa/Cairo', 'Asia/Jerusalem'],
      3: ['Europe/Moscow', 'Asia/Baghdad', 'Africa/Nairobi'],
      4: ['Asia/Dubai', 'Asia/Baku', 'Indian/Mauritius'],
      5: ['Asia/Karachi', 'Asia/Tashkent'],
      6: ['Asia/Dhaka', 'Asia/Almaty'],
      7: ['Asia/Bangkok', 'Asia/Jakarta'],
      8: ['Asia/Shanghai', 'Asia/Singapore', 'Australia/Perth'],
      9: ['Asia/Tokyo', 'Asia/Seoul', 'Pacific/Palau'],
      10: ['Australia/Sydney', 'Pacific/Guam'],
      11: ['Pacific/Norfolk', 'Asia/Magadan'],
      12: ['Pacific/Auckland', 'Pacific/Fiji'],
      13: ['Pacific/Tongatapu'],
      14: ['Pacific/Kiritimati'],
    };
    
    // Get possible timezones for this offset
    final List<String>? possibleTimezones = timezonesByOffset[offsetHours];
    
    if (possibleTimezones != null && possibleTimezones.isNotEmpty) {
      // Use the first (most common) timezone for this offset
      final String selectedTimezone = possibleTimezones.first;
      _logger.i('Selected timezone: $selectedTimezone for offset ${offsetHours}h');
      return selectedTimezone;
    }
    
    // If we still can't find it, use UTC as fallback
    _logger.w('Unknown timezone offset: ${offsetHours}h, using UTC');
    return 'UTC';
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