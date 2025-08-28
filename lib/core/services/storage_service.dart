import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload file to Firebase Storage
  Future<String?> uploadFile(String path, File file) async {
    try {
      Reference ref = _storage.ref().child(path);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading file: $e');
      }
      return null;
    }
  }

  // Upload multiple files
  Future<List<String>> uploadMultipleFiles(
    String basePath,
    List<File> files,
  ) async {
    List<String> urls = [];
    try {
      for (int i = 0; i < files.length; i++) {
        String fileName = '${DateTime.now().millisecondsSinceEpoch}_$i';
        String? url = await uploadFile('$basePath/$fileName', files[i]);
        if (url != null) {
          urls.add(url);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading multiple files: $e');
      }
    }
    return urls;
  }

  // Delete file from Firebase Storage
  Future<bool> deleteFile(String path) async {
    try {
      Reference ref = _storage.ref().child(path);
      await ref.delete();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting file: $e');
      }
      return false;
    }
  }

  // Get download URL of a file
  Future<String?> getDownloadURL(String path) async {
    try {
      Reference ref = _storage.ref().child(path);
      return await ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting download URL: $e');
      }
      return null;
    }
  }

  // List all files in a directory
  Future<List<String>> listFiles(String path) async {
    try {
      Reference ref = _storage.ref().child(path);
      ListResult result = await ref.listAll();
      List<String> urls = [];
      for (Reference item in result.items) {
        String url = await item.getDownloadURL();
        urls.add(url);
      }
      return urls;
    } catch (e) {
      if (kDebugMode) {
        print('Error listing files: $e');
      }
      return [];
    }
  }
}
