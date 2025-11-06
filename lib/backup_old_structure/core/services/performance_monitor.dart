// lib/core/services/performance_monitor.dart
import 'package:flutter/foundation.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// Performance monitoring service for authentication flows
class PerformanceMonitor {
  static final FirebasePerformance _performance = FirebasePerformance.instance;
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static final Map<String, Stopwatch> _activeTraces = {};
  static final Map<String, int> _operationCounts = {};

  /// Start a performance trace
  static Future<Trace> startTrace(String name) async {
    final trace = _performance.newTrace(name);
    await trace.start();

    // Start local stopwatch for additional metrics
    _activeTraces[name] = Stopwatch()..start();

    return trace;
  }

  /// Stop a performance trace with metrics
  static Future<void> stopTrace(
    String name,
    Trace trace, {
    Map<String, int>? customMetrics,
    bool success = true,
  }) async {
    final stopwatch = _activeTraces.remove(name);

    if (stopwatch != null) {
      stopwatch.stop();

      // Set success metric
      trace.setMetric('success', success ? 1 : 0);

      // Set duration metric
      trace.setMetric('duration_ms', stopwatch.elapsedMilliseconds);

      // Set custom metrics
      if (customMetrics != null) {
        for (final entry in customMetrics.entries) {
          trace.setMetric(entry.key, entry.value);
        }
      }

      // Increment operation count
      _operationCounts[name] = (_operationCounts[name] ?? 0) + 1;
      trace.setMetric('operation_count', _operationCounts[name]!);
    }

    await trace.stop();
  }

  /// Track authentication flow performance
  static Future<T> trackAuthFlow<T>(
    String flowName,
    Future<T> Function() operation, {
    Map<String, dynamic>? customAttributes,
  }) async {
    final trace = await startTrace('auth_$flowName');
    final stopwatch = Stopwatch()..start();

    try {
      final result = await operation();

      stopwatch.stop();
      await stopTrace('auth_$flowName', trace, success: true);

      // Log analytics event
      await _analytics.logEvent(
        name: 'auth_performance',
        parameters: {
          'flow_name': flowName,
          'duration_ms': stopwatch.elapsedMilliseconds,
          'success': true,
          ...?customAttributes,
        },
      );

      return result;
    } catch (error) {
      stopwatch.stop();
      await stopTrace('auth_$flowName', trace, success: false);

      // Log error analytics
      await _analytics.logEvent(
        name: 'auth_performance',
        parameters: {
          'flow_name': flowName,
          'duration_ms': stopwatch.elapsedMilliseconds,
          'success': false,
          'error_type': error.runtimeType.toString(),
          ...?customAttributes,
        },
      );

      rethrow;
    }
  }

  /// Track individual authentication phases
  static Future<void> trackAuthPhases({
    required Future<void> Function() validation,
    required Future<void> Function() authentication,
    required Future<void> Function() profileLoad,
    required Future<void> Function() securityChecks,
  }) async {
    final overallTrace = await startTrace('auth_complete_flow');
    final overallStopwatch = Stopwatch()..start();

    try {
      // Track each phase
      await _trackPhase('validation', validation);
      await _trackPhase('authentication', authentication);
      await _trackPhase('profile_load', profileLoad);
      await _trackPhase('security_checks', securityChecks);

      overallStopwatch.stop();
      await stopTrace('auth_complete_flow', overallTrace, customMetrics: {
        'total_phases': 4,
        'overall_duration_ms': overallStopwatch.elapsedMilliseconds,
      });
    } catch (error) {
      overallStopwatch.stop();
      await stopTrace('auth_complete_flow', overallTrace,
          success: false,
          customMetrics: {
            'total_phases': 4,
            'overall_duration_ms': overallStopwatch.elapsedMilliseconds,
          });
      rethrow;
    }
  }

  /// Track individual phase
  static Future<void> _trackPhase(
    String phaseName,
    Future<void> Function() operation,
  ) async {
    final trace = await startTrace('auth_$phaseName');

    try {
      await operation();
      await stopTrace('auth_$phaseName', trace, success: true);
    } catch (error) {
      await stopTrace('auth_$phaseName', trace, success: false);
      rethrow;
    }
  }

  /// Track API call performance
  static Future<T> trackApiCall<T>(
    String apiName,
    Future<T> Function() apiCall, {
    Map<String, dynamic>? parameters,
  }) async {
    final trace = await startTrace('api_$apiName');
    final stopwatch = Stopwatch()..start();

    try {
      final result = await apiCall();

      stopwatch.stop();
      await stopTrace('api_$apiName', trace, customMetrics: {
        'response_time_ms': stopwatch.elapsedMilliseconds,
      });

      // Log API performance
      await _analytics.logEvent(
        name: 'api_performance',
        parameters: {
          'api_name': apiName,
          'response_time_ms': stopwatch.elapsedMilliseconds,
          'success': true,
          ...?parameters,
        },
      );

      return result;
    } catch (error) {
      stopwatch.stop();
      await stopTrace('api_$apiName', trace, success: false, customMetrics: {
        'response_time_ms': stopwatch.elapsedMilliseconds,
      });

      await _analytics.logEvent(
        name: 'api_performance',
        parameters: {
          'api_name': apiName,
          'response_time_ms': stopwatch.elapsedMilliseconds,
          'success': false,
          'error_type': error.runtimeType.toString(),
          ...?parameters,
        },
      );

      rethrow;
    }
  }

  /// Track memory usage
  static Future<void> trackMemoryUsage(String context) async {
    if (kDebugMode) {
      // In debug mode, track memory usage
      final usage = _getMemoryUsage();

      await _analytics.logEvent(
        name: 'memory_usage',
        parameters: {
          'context': context,
          'memory_usage_mb': usage,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    }
  }

  /// Get current memory usage (approximate)
  static double _getMemoryUsage() {
    // This is a simplified approximation
    // In a real app, you might use platform-specific memory APIs
    return 0.0; // Placeholder
  }

  /// Get performance summary
  static Map<String, dynamic> getPerformanceSummary() {
    return {
      'active_traces': _activeTraces.length,
      'operation_counts': Map.from(_operationCounts),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Clear performance data
  static void clearPerformanceData() {
    _activeTraces.clear();
    _operationCounts.clear();
  }

  /// Log custom performance metric
  static Future<void> logCustomMetric(
    String metricName,
    double value, {
    Map<String, dynamic>? attributes,
  }) async {
    await _analytics.logEvent(
      name: 'custom_performance_metric',
      parameters: {
        'metric_name': metricName,
        'metric_value': value,
        'timestamp': DateTime.now().toIso8601String(),
        ...?attributes,
      },
    );
  }

  /// Track user experience metrics
  static Future<void> trackUserExperience({
    required String screen,
    required int loadTimeMs,
    required bool successful,
    Map<String, dynamic>? context,
  }) async {
    await _analytics.logEvent(
      name: 'user_experience',
      parameters: {
        'screen': screen,
        'load_time_ms': loadTimeMs,
        'successful': successful,
        'timestamp': DateTime.now().toIso8601String(),
        ...?context,
      },
    );
  }
}
