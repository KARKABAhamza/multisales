import 'dart:developer' as dev;

class TracingService {
  static void startSpan(String name, {Map<String, Object?>? attributes}) {
    dev.Timeline.startSync(name, arguments: attributes ?? const {});
  }

  static void endSpan() {
    dev.Timeline.finishSync();
  }

  static void log(String message, {Map<String, Object?>? attributes}) {
    dev.log(message, name: 'Tracing', error: attributes);
  }
}