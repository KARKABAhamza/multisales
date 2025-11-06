import 'package:flutter/foundation.dart';
import '../services/storage_upload_service.dart';

class StorageUploadProvider with ChangeNotifier {
  final StorageUploadService _service;

  StorageUploadProvider({StorageUploadService? service})
      : _service = service ?? StorageUploadService();

  bool _isLoading = false;
  String? _errorMessage;
  String? _lastPublicUrl;
  double _progress = 0.0;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get lastPublicUrl => _lastPublicUrl;
  double get progress => _progress;

  void resetError() {
    _errorMessage = null;
    _progress = 0.0;
    notifyListeners();
  }

  /// For local testing, you can wire the functions emulator.
  void useEmulator({String host = 'localhost', int port = 5001}) {
    _service.useEmulator(host: host, port: port);
  }

  Future<String?> uploadBytes({
    required List<int> bytes,
    required String path,
    required String contentType,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _progress = 0.0;
    notifyListeners();

    try {
      final url = await _service.uploadBytes(bytes: bytes, path: path, contentType: contentType);
      _lastPublicUrl = url;
      return url;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Upload with client-side progress reporting (0.0..1.0).
  Future<String?> uploadBytesWithProgress({
    required List<int> bytes,
    required String path,
    required String contentType,
    void Function(double progress)? onProgress,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _progress = 0.0;
    notifyListeners();

    try {
      final url = await _service.uploadBytesWithProgress(
        bytes: bytes,
        path: path,
        contentType: contentType,
        onProgress: (p) {
          _progress = p;
          notifyListeners();
          onProgress?.call(p);
        },
      );
      _lastPublicUrl = url;
      return url;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
