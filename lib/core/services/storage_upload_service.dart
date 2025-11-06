// ignore: unnecessary_import
import 'dart:typed_data';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

/// Service to obtain a signed upload URL from Cloud Functions and upload bytes directly to Cloud Storage.
///
/// Callable function name: getSignedUploadUrl
class StorageUploadService {
  final FirebaseFunctions _functions;
  final Dio _dio;

  StorageUploadService({FirebaseFunctions? functions, Dio? dio})
      : _functions = functions ?? FirebaseFunctions.instanceFor(region: 'us-central1'),
        _dio = dio ?? Dio();

  /// Optionally point to the local Functions emulator.
  void useEmulator({String host = 'localhost', int port = 5001}) {
    try {
      _functions.useFunctionsEmulator(host, port);
      // ignore: avoid_print
      if (kDebugMode) print('StorageUploadService: Using Functions emulator at $host:$port');
    } catch (_) {
      // no-op if already configured
    }
  }

  /// Obtains a signed PUT URL for the given path/contentType and uploads the provided bytes.
  /// Returns the public URL after successful upload.
  Future<String> uploadBytes({
    required List<int> bytes,
    required String path,
    required String contentType,
    int expiresInSeconds = 300,
  }) async {
    final callable = _functions.httpsCallable('getSignedUploadUrl');
    final result = await callable.call({
      'path': path,
      'contentType': contentType,
      'expiresInSeconds': expiresInSeconds,
    });

    final data = Map<String, dynamic>.from(result.data as Map);
    final uploadUrl = data['uploadUrl'] as String;
    final publicUrl = data['publicUrl'] as String;

    final putRes = await http.put(
      Uri.parse(uploadUrl),
      headers: {'Content-Type': contentType},
      body: Uint8List.fromList(bytes),
    );

    if (putRes.statusCode != 200) {
      throw Exception('Upload failed: ${putRes.statusCode} ${putRes.body}');
    }

    return publicUrl;
  }

  /// Same flow as [uploadBytes] but uses Dio to report upload progress.
  /// The [onProgress] callback receives a value between 0.0 and 1.0.
  Future<String> uploadBytesWithProgress({
    required List<int> bytes,
    required String path,
    required String contentType,
    int expiresInSeconds = 300,
    void Function(double fraction)? onProgress,
  }) async {
    final callable = _functions.httpsCallable('getSignedUploadUrl');
    final result = await callable.call({
      'path': path,
      'contentType': contentType,
      'expiresInSeconds': expiresInSeconds,
    });

    final data = Map<String, dynamic>.from(result.data as Map);
    final uploadUrl = data['uploadUrl'] as String;
    final publicUrl = data['publicUrl'] as String;

    final body = Uint8List.fromList(bytes);

    final response = await _dio.put(
      uploadUrl,
      data: body,
      options: Options(
        headers: {
          'Content-Type': contentType,
          // Some environments benefit from explicit length during signed PUT
          'Content-Length': body.length,
        },
        // For very large files, you can tune timeouts here if needed.
      ),
      onSendProgress: (sent, total) {
        if (total <= 0) {
          onProgress?.call(0);
        } else {
          final frac = sent / total;
          onProgress?.call(frac.clamp(0.0, 1.0));
        }
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Upload failed: ${response.statusCode} ${response.statusMessage}');
    }

    return publicUrl;
  }
}
