import 'package:flutter/material.dart';

/// Utility class for time parsing and timezone conversion
/// Provides centralized time handling logic used across the app
class TimeUtils {
  /// Parse a time range string and return the start time
  /// Handles formats like "2:30 PM - 4:15 PM", "08:00-08:30", "8:00-8:30"
  static TimeOfDay parseTimeRange(String timeRange) {
    try {
      // Handle multiple formats
      if (timeRange.contains(' - ')) {
        // Format: "2:30 PM - 4:15 PM"
        final parts = timeRange.split(' - ');
        if (parts.isNotEmpty) {
          return parseTimeString(parts[0].trim());
        }
      } else if (timeRange.contains('-')) {
        // Format: "08:00-08:30" or "8:00-8:30"
        final parts = timeRange.split('-');
        if (parts.isNotEmpty) {
          return parseTimeString(parts[0].trim());
        }
      } else {
        // Single time format
        return parseTimeString(timeRange.trim());
      }
    } catch (e) {
      // Silent failure, return default
    }

    return const TimeOfDay(hour: 0, minute: 0);
  }

  /// Parse a time range string and return the end time
  /// Handles formats like "2:30 PM - 4:15 PM", "08:00-08:30", "8:00-8:30"
  static TimeOfDay parseEndTime(String timeRange) {
    try {
      // Handle multiple formats
      if (timeRange.contains(' - ')) {
        // Format: "2:30 PM - 4:15 PM"
        final parts = timeRange.split(' - ');
        if (parts.length > 1) {
          return parseTimeString(parts[1].trim());
        }
      } else if (timeRange.contains('-')) {
        // Format: "08:00-08:30" or "8:00-8:30"
        final parts = timeRange.split('-');
        if (parts.length > 1) {
          return parseTimeString(parts[1].trim());
        }
      }
    } catch (e) {
      // Silent failure, return default
    }

    return const TimeOfDay(hour: 0, minute: 0);
  }

  /// Check if a time range has an end time
  static bool hasEndTime(String timeRange) {
    return timeRange.contains(' - ') || timeRange.contains('-');
  }

  /// Parse individual time string handling multiple formats and timezone conversion
  /// Handles both 12-hour (AM/PM) and 24-hour formats
  static TimeOfDay parseTimeString(String timeStr) {
    try {
      // Remove extra whitespace
      timeStr = timeStr.trim();

      // Handle AM/PM format (12-hour)
      if (timeStr.toUpperCase().contains('AM') || timeStr.toUpperCase().contains('PM')) {
        final isPM = timeStr.toUpperCase().contains('PM');

        // Remove AM/PM and parse the time part
        final timePart = timeStr.replaceAll(RegExp(r'\s*(AM|PM)', caseSensitive: false), '');
        final timeParts = timePart.split(':');

        if (timeParts.length == 2) {
          int hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);

          // Convert 12-hour to 24-hour format
          if (isPM && hour != 12) {
            hour += 12;
          } else if (!isPM && hour == 12) {
            hour = 0;
          }

          // Apply timezone conversion (assuming server times are in a different timezone)
          return convertToUserTimezone(TimeOfDay(hour: hour, minute: minute));
        }
      } else {
        // Handle 24-hour format or simple format without AM/PM
        final timeParts = timeStr.split(':');
        if (timeParts.length == 2) {
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);

          // Apply timezone conversion
          return convertToUserTimezone(TimeOfDay(hour: hour, minute: minute));
        }
      }
    } catch (e) {
      // Silent failure, return default
    }

    return const TimeOfDay(hour: 0, minute: 0);
  }

  /// Convert server time to user's local timezone
  /// This is a simplified conversion - in a real app you'd want to know the server's timezone
  static TimeOfDay convertToUserTimezone(TimeOfDay serverTime) {
    try {
      // Create a DateTime for today with the server time
      final now = DateTime.now();

      // For now, we'll assume server times are in UTC and convert to local time
      // In a production app, you'd want to know the server's actual timezone
      final utcDateTime = DateTime.utc(
        now.year,
        now.month,
        now.day,
        serverTime.hour,
        serverTime.minute,
      );

      final localDateTime = utcDateTime.toLocal();

      return TimeOfDay.fromDateTime(localDateTime);

    } catch (e) {
      return serverTime; // Return original time if conversion fails
    }
  }

  /// Format a time range string in local timezone for display
  /// Converts UTC times to local and formats them properly
  static String formatLocalTimeRange(String timeRange, BuildContext context) {
    try {
      if (hasEndTime(timeRange)) {
        final startTime = parseTimeRange(timeRange);
        final endTime = parseEndTime(timeRange);

        return '${startTime.format(context)} - ${endTime.format(context)}';
      } else {
        final time = parseTimeString(timeRange);
        return time.format(context);
      }
    } catch (e) {
      // Fall back to original if parsing fails
      return timeRange;
    }
  }
}