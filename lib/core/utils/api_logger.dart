import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// A utility class for logging API requests and responses in a clean and structured way.
class ApiLogger {
  // Configuration
  static bool _enabled = true;
  static bool _detailedMode = true;

  /// Enable or disable API logging
  static void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// Enable or disable detailed logging
  static void setDetailedMode(bool detailed) {
    _detailedMode = detailed;
  }

  /// Log a HTTP request
  static void logRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    dynamic body,
  }) {
    if (!_enabled) return;

    final StringBuffer logMessage = StringBuffer();

    logMessage.writeln('┌─────────────── HTTP REQUEST ───────────────');
    logMessage.writeln('│ $method $url');

    if (_detailedMode && headers != null && headers.isNotEmpty) {
      logMessage.writeln('├─── Headers ───');
      _logMap(headers, logMessage);
    }

    if (_detailedMode && body != null) {
      logMessage.writeln('├─── Body ───');
      final String bodyStr = _prettyPrintJson(body);
      _logMultiLine(bodyStr, logMessage);
    }

    logMessage.writeln('└─────────────────────────────────────────');

    _log(logMessage.toString());
  }

  /// Log a HTTP response
  static void logResponse({
    required int statusCode,
    required String url,
    Map<String, String>? headers,
    dynamic body,
    int? responseTime,
  }) {
    if (!_enabled) return;

    final StringBuffer logMessage = StringBuffer();

    logMessage.writeln('┌─────────────── HTTP RESPONSE ──────────────');

    if (statusCode >= 200 && statusCode < 300) {
      logMessage.writeln('│ ✅ $statusCode $url');
    } else {
      logMessage.writeln('│ ❌ $statusCode $url');
    }

    if (responseTime != null) {
      logMessage.writeln('│ ⏱ ${responseTime}ms');
    }

    if (_detailedMode && headers != null && headers.isNotEmpty) {
      logMessage.writeln('├─── Headers ───');
      _logMap(headers, logMessage);
    }

    if (body != null) {
      logMessage.writeln('├─── Body ───');
      final String bodyStr = _prettyPrintJson(body);
      _logMultiLine(bodyStr, logMessage);
    }

    logMessage.writeln('└─────────────────────────────────────────');

    _log(logMessage.toString());
  }

  /// Log an error
  static void logError(String url, dynamic error, StackTrace? stackTrace) {
    if (!_enabled) return;

    final StringBuffer logMessage = StringBuffer();

    logMessage.writeln('┌─────────────── API ERROR ─────────────────');
    logMessage.writeln('│ ❌ $url');
    logMessage.writeln('├─── Error ───');
    logMessage.writeln('│ ${error.toString()}');

    if (_detailedMode && stackTrace != null) {
      logMessage.writeln('├─── Stack Trace ───');
      _logMultiLine(stackTrace.toString(), logMessage);
    }

    logMessage.writeln('└─────────────────────────────────────────');

    _log(logMessage.toString(), isError: true);
  }

  // Helper method to log a map
  static void _logMap(Map<String, dynamic> map, StringBuffer logMessage) {
    map.forEach((key, value) {
      // Skip logging authorization token details
      if (key.toLowerCase() == 'authorization' && !kDebugMode) {
        logMessage.writeln('│ $key: Token hidden for security');
      } else {
        logMessage.writeln('│ $key: $value');
      }
    });
  }

  // Helper method to log multi-line text
  static void _logMultiLine(String text, StringBuffer logMessage) {
    for (final line in text.split('\n')) {
      logMessage.writeln('│ $line');
    }
  }

  // Helper method to pretty print JSON
  static String _prettyPrintJson(dynamic json) {
    try {
      if (json is String) {
        // Try to parse the string as JSON
        final dynamic parsedJson = jsonDecode(json);
        return const JsonEncoder.withIndent('  ').convert(parsedJson);
      } else if (json is Map || json is List) {
        return const JsonEncoder.withIndent('  ').convert(json);
      }
    } catch (e) {
      // If it's not valid JSON, return as is
    }
    return json.toString();
  }

  // Log to console with appropriate styling
  static void _log(String message, {bool isError = false}) {
    if (isError) {
      developer.log(message, name: 'API_ERROR');
    } else {
      developer.log(message, name: 'API_DEBUG');
    }
  }
}
