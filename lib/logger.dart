import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

class Logger {
  static void d(String message) {
    if (kDebugMode) {
      developer.log(message, name: 'DEBUG');
    }
  }
}
