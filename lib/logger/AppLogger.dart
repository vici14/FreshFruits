import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

Logger logger = Logger(
  filter: Filter(),
);

class AppLogger {
  /// Debug message
  static void d(dynamic msg) {
    logger.d(msg);
  }

  /// Information message
  static void i(dynamic msg) {
    logger.i(msg);
  }

  /// Error message
  static void e(dynamic msg, {String? extraMessage}) {
    logger.e('$msg ${extraMessage ?? ''}');
  }

  /// Warning message
  static void w(dynamic msg) {
    logger.w(msg);
  }

  /// Verbose message
  static void v(dynamic msg) {
    logger.v(msg);
  }
}

class Filter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
