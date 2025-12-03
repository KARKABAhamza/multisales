import 'package:cloud_firestore/cloud_firestore.dart';

/// Small helpers to normalize Firestore Timestamp/FieldValue usage across the
/// codebase during migration to newer FlutterFire versions.

DateTime? timestampToDate(Object? value) {
  if (value == null) return null;
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }
  return null;
}

/// Convert a [DateTime] to a Firestore-friendly value. If [dt] is null,
/// returns [FieldValue.serverTimestamp()] so server will set the value.
Object dateToFirestore(DateTime? dt) {
  if (dt == null) return FieldValue.serverTimestamp();
  return Timestamp.fromDate(dt);
}

/// Explicit helper for server timestamp placeholder.
FieldValue serverTimestamp() => FieldValue.serverTimestamp();
