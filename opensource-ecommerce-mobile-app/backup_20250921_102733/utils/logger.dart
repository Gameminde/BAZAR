/*
 * Logger utility for BAZAR Marketplace
 * Replaces print() statements with proper logging levels
 */

import 'package:flutter/foundation.dart';

/// Centralized logging utility for BAZAR Marketplace
class Logger {
  static const String _tag = 'BAZAR';

  /// Log debug messages (only in debug mode)
  static void debug(String message, [String? tag]) {
    if (kDebugMode) {
      final logTag = tag != null ? '$_tag-$tag' : _tag;
      debugPrint('🔍 [$logTag] $message');
    }
  }

  /// Log info messages
  static void info(String message, [String? tag]) {
    final logTag = tag != null ? '$_tag-$tag' : _tag;
    debugPrint('ℹ️ [$logTag] $message');
  }

  /// Log warning messages
  static void warning(String message, [String? tag]) {
    final logTag = tag != null ? '$_tag-$tag' : _tag;
    debugPrint('⚠️ [$logTag] $message');
  }

  /// Log error messages
  static void error(
    String message, [
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    final logTag = tag != null ? '$_tag-$tag' : _tag;
    debugPrint('❌ [$logTag] $message');
    if (error != null) {
      debugPrint('❌ [$logTag] Error: $error');
    }
    if (stackTrace != null && kDebugMode) {
      debugPrint('❌ [$logTag] StackTrace: $stackTrace');
    }
  }

  /// Log network requests
  static void networkRequest(
    String method,
    String path, [
    Map<String, dynamic>? data,
  ]) {
    if (kDebugMode) {
      debugPrint('🚀 [$_tag-NETWORK] $method $path');
      if (data != null) {
        debugPrint('📦 [$_tag-NETWORK] Data: $data');
      }
    }
  }

  /// Log network responses
  static void networkResponse(int statusCode, String path, [dynamic data]) {
    if (kDebugMode) {
      debugPrint('✅ [$_tag-NETWORK] $statusCode $path');
      if (data != null) {
        debugPrint('📦 [$_tag-NETWORK] Response: $data');
      }
    }
  }

  /// Log network errors
  static void networkError(int? statusCode, String path, String message) {
    debugPrint('❌ [$_tag-NETWORK] $statusCode $path - $message');
  }
}
