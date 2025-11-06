import 'package:flutter/foundation.dart';

/// Document Provider for MultiSales Client App
/// Handles document upload, download, storage, and management
class DocumentProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> _clientDocuments = [];
  List<Map<String, dynamic>> _documentTemplates = [];
  Map<String, dynamic>? _currentUpload;
  double _uploadProgress = 0.0;

  String _selectedCategory = 'all';
  String _sortBy =
      'date_desc'; // date_desc, date_asc, name_asc, name_desc, size_desc

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get clientDocuments => _clientDocuments;
  List<Map<String, dynamic>> get documentTemplates => _documentTemplates;
  Map<String, dynamic>? get currentUpload => _currentUpload;
  double get uploadProgress => _uploadProgress;
  String get selectedCategory => _selectedCategory;
  String get sortBy => _sortBy;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Initialize Document System
  Future<bool> initializeDocumentSystem(String clientId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 700));

      await Future.wait([
        _loadClientDocuments(clientId),
        _loadDocumentTemplates(),
      ]);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to initialize document system: $e');
      _setLoading(false);
      return false;
    }
  }

  // Load Client Documents
  Future<bool> _loadClientDocuments(String clientId) async {
    try {
      _clientDocuments = [
        {
          'id': 'doc_001',
          'clientId': clientId,
          'name': 'Service_Contract_2025.pdf',
          'originalName': 'Service Contract 2025.pdf',
          'category': 'contracts',
          'type': 'application/pdf',
          'size': 2457600, // bytes (2.4 MB)
          'uploadDate': DateTime.now()
              .subtract(const Duration(days: 30))
              .toIso8601String(),
          'lastModified': DateTime.now()
              .subtract(const Duration(days: 15))
              .toIso8601String(),
          'description':
              'Annual service contract for fiber internet and mobile services',
          'status': 'active',
          'downloadUrl': 'https://storage.multisales.ma/documents/doc_001.pdf',
          'thumbnailUrl':
              'https://storage.multisales.ma/thumbnails/doc_001_thumb.jpg',
          'tags': ['contract', 'fiber', 'mobile', '2025'],
          'isPrivate': false,
          'expiryDate':
              DateTime.now().add(const Duration(days: 335)).toIso8601String(),
          'downloadCount': 3,
          'lastDownloaded': DateTime.now()
              .subtract(const Duration(days: 7))
              .toIso8601String(),
          'uploadedBy': 'system',
        },
        {
          'id': 'doc_002',
          'clientId': clientId,
          'name': 'Identity_Verification.pdf',
          'originalName': 'CIN_Copy_Ahmed_Bennani.pdf',
          'category': 'identity',
          'type': 'application/pdf',
          'size': 1234567, // bytes (1.2 MB)
          'uploadDate': DateTime.now()
              .subtract(const Duration(days: 45))
              .toIso8601String(),
          'lastModified': DateTime.now()
              .subtract(const Duration(days: 45))
              .toIso8601String(),
          'description': 'National identity card copy for account verification',
          'status': 'verified',
          'downloadUrl': 'https://storage.multisales.ma/documents/doc_002.pdf',
          'thumbnailUrl':
              'https://storage.multisales.ma/thumbnails/doc_002_thumb.jpg',
          'tags': ['identity', 'verification', 'cin'],
          'isPrivate': true,
          'expiryDate': null,
          'downloadCount': 1,
          'lastDownloaded': DateTime.now()
              .subtract(const Duration(days: 30))
              .toIso8601String(),
          'uploadedBy': 'client',
        },
        {
          'id': 'doc_003',
          'clientId': clientId,
          'name': 'Installation_Report_July2025.pdf',
          'originalName': 'Technical Installation Report.pdf',
          'category': 'technical',
          'type': 'application/pdf',
          'size': 567890, // bytes (554 KB)
          'uploadDate': DateTime.now()
              .subtract(const Duration(days: 15))
              .toIso8601String(),
          'lastModified': DateTime.now()
              .subtract(const Duration(days: 15))
              .toIso8601String(),
          'description':
              'Technical report from fiber installation on July 15, 2025',
          'status': 'completed',
          'downloadUrl': 'https://storage.multisales.ma/documents/doc_003.pdf',
          'thumbnailUrl':
              'https://storage.multisales.ma/thumbnails/doc_003_thumb.jpg',
          'tags': ['installation', 'technical', 'fiber', 'report'],
          'isPrivate': false,
          'expiryDate': null,
          'downloadCount': 2,
          'lastDownloaded': DateTime.now()
              .subtract(const Duration(days: 5))
              .toIso8601String(),
          'uploadedBy': 'technician',
        },
        {
          'id': 'doc_004',
          'clientId': clientId,
          'name': 'Monthly_Bills_2025.zip',
          'originalName': 'Bills Archive 2025.zip',
          'category': 'billing',
          'type': 'application/zip',
          'size': 3456789, // bytes (3.3 MB)
          'uploadDate': DateTime.now()
              .subtract(const Duration(days: 5))
              .toIso8601String(),
          'lastModified': DateTime.now()
              .subtract(const Duration(days: 5))
              .toIso8601String(),
          'description': 'Archive of all monthly bills for 2025',
          'status': 'active',
          'downloadUrl': 'https://storage.multisales.ma/documents/doc_004.zip',
          'thumbnailUrl':
              'https://storage.multisales.ma/thumbnails/doc_004_thumb.jpg',
          'tags': ['bills', 'archive', '2025', 'billing'],
          'isPrivate': false,
          'expiryDate': DateTime.now()
              .add(const Duration(days: 1095))
              .toIso8601String(), // 3 years
          'downloadCount': 0,
          'lastDownloaded': null,
          'uploadedBy': 'system',
        },
        {
          'id': 'doc_005',
          'clientId': clientId,
          'name': 'Support_Ticket_Screenshots.pdf',
          'originalName': 'Issue Screenshots.pdf',
          'category': 'support',
          'type': 'application/pdf',
          'size': 987654, // bytes (964 KB)
          'uploadDate': DateTime.now()
              .subtract(const Duration(days: 8))
              .toIso8601String(),
          'lastModified': DateTime.now()
              .subtract(const Duration(days: 8))
              .toIso8601String(),
          'description':
              'Screenshots and documentation for support ticket #TKT_123',
          'status': 'processed',
          'downloadUrl': 'https://storage.multisales.ma/documents/doc_005.pdf',
          'thumbnailUrl':
              'https://storage.multisales.ma/thumbnails/doc_005_thumb.jpg',
          'tags': ['support', 'screenshots', 'ticket', 'documentation'],
          'isPrivate': false,
          'expiryDate': null,
          'downloadCount': 4,
          'lastDownloaded': DateTime.now()
              .subtract(const Duration(days: 2))
              .toIso8601String(),
          'uploadedBy': 'client',
        },
      ];

      return true;
    } catch (e) {
      _setError('Failed to load client documents: $e');
      return false;
    }
  }

  // Load Document Templates
  Future<bool> _loadDocumentTemplates() async {
    try {
      _documentTemplates = [
        {
          'id': 'template_001',
          'name': 'Service Request Form',
          'description':
              'Template for requesting new services or service modifications',
          'category': 'requests',
          'type': 'application/pdf',
          'size': 234567,
          'downloadUrl':
              'https://storage.multisales.ma/templates/service_request_form.pdf',
          'thumbnailUrl':
              'https://storage.multisales.ma/thumbnails/template_001_thumb.jpg',
          'isRequired': false,
          'instructions':
              'Fill out this form to request new services or modifications to existing services.',
          'fields': [
            'client_info',
            'service_type',
            'preferred_date',
            'special_requirements'
          ],
        },
        {
          'id': 'template_002',
          'name': 'Technical Issue Report',
          'description':
              'Template for reporting technical issues with your services',
          'category': 'technical',
          'type': 'application/pdf',
          'size': 198765,
          'downloadUrl':
              'https://storage.multisales.ma/templates/technical_issue_report.pdf',
          'thumbnailUrl':
              'https://storage.multisales.ma/thumbnails/template_002_thumb.jpg',
          'isRequired': false,
          'instructions':
              'Use this form to provide detailed information about technical issues.',
          'fields': [
            'issue_description',
            'error_messages',
            'steps_taken',
            'contact_details'
          ],
        },
        {
          'id': 'template_003',
          'name': 'Identity Verification Form',
          'description': 'Required form for account verification and security',
          'category': 'identity',
          'type': 'application/pdf',
          'size': 156789,
          'downloadUrl':
              'https://storage.multisales.ma/templates/identity_verification.pdf',
          'thumbnailUrl':
              'https://storage.multisales.ma/thumbnails/template_003_thumb.jpg',
          'isRequired': true,
          'instructions':
              'Complete this form with copies of required identification documents.',
          'fields': [
            'full_name',
            'cin_number',
            'address',
            'phone_number',
            'document_copies'
          ],
        },
        {
          'id': 'template_004',
          'name': 'Payment Authorization Form',
          'description': 'Form for setting up automatic bill payments',
          'category': 'billing',
          'type': 'application/pdf',
          'size': 123456,
          'downloadUrl':
              'https://storage.multisales.ma/templates/payment_authorization.pdf',
          'thumbnailUrl':
              'https://storage.multisales.ma/thumbnails/template_004_thumb.jpg',
          'isRequired': false,
          'instructions':
              'Complete this form to authorize automatic bill payments from your bank account.',
          'fields': [
            'bank_details',
            'account_number',
            'authorization_signature',
            'payment_limit'
          ],
        },
      ];

      return true;
    } catch (e) {
      _setError('Failed to load document templates: $e');
      return false;
    }
  }

  // Upload Document
  Future<bool> uploadDocument({
    required String fileName,
    required String category,
    required List<int> fileBytes,
    String? description,
    List<String>? tags,
    bool isPrivate = false,
  }) async {
    _setLoading(true);
    _setError(null);
    _uploadProgress = 0.0;

    try {
      // Validate file size (max 10MB)
      if (fileBytes.length > 10 * 1024 * 1024) {
        _setError('File size exceeds 10MB limit');
        _setLoading(false);
        return false;
      }

      // Validate file type
      final allowedTypes = ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png', 'zip'];
      final fileExtension = fileName.split('.').last.toLowerCase();

      if (!allowedTypes.contains(fileExtension)) {
        _setError(
            'File type not supported. Allowed types: ${allowedTypes.join(', ')}');
        _setLoading(false);
        return false;
      }

      _currentUpload = {
        'fileName': fileName,
        'category': category,
        'size': fileBytes.length,
        'startTime': DateTime.now().toIso8601String(),
      };

      // Simulate upload progress
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 200));
        _uploadProgress = i / 100.0;
        notifyListeners();
      }

      // Create new document entry
      final newDocument = {
        'id': 'doc_${DateTime.now().millisecondsSinceEpoch}',
        'clientId': 'client_123',
        'name': _sanitizeFileName(fileName),
        'originalName': fileName,
        'category': category,
        'type': _getContentType(fileExtension),
        'size': fileBytes.length,
        'uploadDate': DateTime.now().toIso8601String(),
        'lastModified': DateTime.now().toIso8601String(),
        'description': description ?? '',
        'status': 'uploaded',
        'downloadUrl':
            'https://storage.multisales.ma/documents/${_sanitizeFileName(fileName)}',
        'thumbnailUrl': _supportsThumbnail(fileExtension)
            ? 'https://storage.multisales.ma/thumbnails/${_sanitizeFileName(fileName)}_thumb.jpg'
            : null,
        'tags': tags ?? [],
        'isPrivate': isPrivate,
        'expiryDate': null,
        'downloadCount': 0,
        'lastDownloaded': null,
        'uploadedBy': 'client',
      };

      _clientDocuments.insert(0, newDocument);
      _currentUpload = null;
      _uploadProgress = 0.0;

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to upload document: $e');
      _currentUpload = null;
      _uploadProgress = 0.0;
      _setLoading(false);
      return false;
    }
  }

  // Download Document
  Future<bool> downloadDocument(String documentId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final documentIndex =
          _clientDocuments.indexWhere((doc) => doc['id'] == documentId);

      if (documentIndex == -1) {
        _setError('Document not found');
        _setLoading(false);
        return false;
      }

      // Update download statistics
      _clientDocuments[documentIndex]['downloadCount']++;
      _clientDocuments[documentIndex]['lastDownloaded'] =
          DateTime.now().toIso8601String();

      // In a real implementation, this would trigger the actual download
      debugPrint(
          'Downloading: ${_clientDocuments[documentIndex]['downloadUrl']}');

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to download document: $e');
      _setLoading(false);
      return false;
    }
  }

  // Delete Document
  Future<bool> deleteDocument(String documentId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final documentIndex =
          _clientDocuments.indexWhere((doc) => doc['id'] == documentId);

      if (documentIndex == -1) {
        _setError('Document not found');
        _setLoading(false);
        return false;
      }

      // Check if document can be deleted
      final document = _clientDocuments[documentIndex];
      if (document['status'] == 'required' ||
          document['category'] == 'identity') {
        _setError('This document is required and cannot be deleted');
        _setLoading(false);
        return false;
      }

      _clientDocuments.removeAt(documentIndex);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to delete document: $e');
      _setLoading(false);
      return false;
    }
  }

  // Update Document Details
  Future<bool> updateDocumentDetails({
    required String documentId,
    String? name,
    String? description,
    List<String>? tags,
    bool? isPrivate,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 400));

      final documentIndex =
          _clientDocuments.indexWhere((doc) => doc['id'] == documentId);

      if (documentIndex == -1) {
        _setError('Document not found');
        _setLoading(false);
        return false;
      }

      // Update document details
      if (name != null) {
        _clientDocuments[documentIndex]['originalName'] = name;
      }
      if (description != null) {
        _clientDocuments[documentIndex]['description'] = description;
      }
      if (tags != null) {
        _clientDocuments[documentIndex]['tags'] = tags;
      }
      if (isPrivate != null) {
        _clientDocuments[documentIndex]['isPrivate'] = isPrivate;
      }

      _clientDocuments[documentIndex]['lastModified'] =
          DateTime.now().toIso8601String();

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update document: $e');
      _setLoading(false);
      return false;
    }
  }

  // Get Documents by Category
  List<Map<String, dynamic>> getDocumentsByCategory(String category) {
    if (category == 'all') return _clientDocuments;
    return _clientDocuments
        .where((doc) => doc['category'] == category)
        .toList();
  }

  // Search Documents
  List<Map<String, dynamic>> searchDocuments(String query) {
    if (query.isEmpty) return _clientDocuments;

    final lowerQuery = query.toLowerCase();
    return _clientDocuments.where((doc) {
      return doc['originalName']
              .toString()
              .toLowerCase()
              .contains(lowerQuery) ||
          doc['description'].toString().toLowerCase().contains(lowerQuery) ||
          (doc['tags'] as List)
              .any((tag) => tag.toString().toLowerCase().contains(lowerQuery));
    }).toList();
  }

  // Get Documents by Status
  List<Map<String, dynamic>> getDocumentsByStatus(String status) {
    return _clientDocuments.where((doc) => doc['status'] == status).toList();
  }

  // Set Category Filter
  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Set Sort Order
  void setSortOrder(String sortBy) {
    _sortBy = sortBy;
    _sortDocuments();
    notifyListeners();
  }

  // Sort Documents
  void _sortDocuments() {
    switch (_sortBy) {
      case 'date_desc':
        _clientDocuments.sort((a, b) => DateTime.parse(b['uploadDate'])
            .compareTo(DateTime.parse(a['uploadDate'])));
        break;
      case 'date_asc':
        _clientDocuments.sort((a, b) => DateTime.parse(a['uploadDate'])
            .compareTo(DateTime.parse(b['uploadDate'])));
        break;
      case 'name_asc':
        _clientDocuments.sort((a, b) => a['originalName']
            .toString()
            .compareTo(b['originalName'].toString()));
        break;
      case 'name_desc':
        _clientDocuments.sort((a, b) => b['originalName']
            .toString()
            .compareTo(a['originalName'].toString()));
        break;
      case 'size_desc':
        _clientDocuments
            .sort((a, b) => (b['size'] as int).compareTo(a['size'] as int));
        break;
    }
  }

  // Get Available Categories
  List<String> getDocumentCategories() {
    final categories = _clientDocuments
        .map((doc) => doc['category'].toString())
        .toSet()
        .toList();
    categories.insert(0, 'all');
    return categories;
  }

  // Get Storage Statistics
  Map<String, dynamic> getStorageStatistics() {
    final totalDocuments = _clientDocuments.length;
    final totalSize =
        _clientDocuments.fold(0, (sum, doc) => sum + (doc['size'] as int));
    final privateDocuments =
        _clientDocuments.where((doc) => doc['isPrivate']).length;
    final recentUploads = _clientDocuments.where((doc) {
      final uploadDate = DateTime.parse(doc['uploadDate']);
      return uploadDate
          .isAfter(DateTime.now().subtract(const Duration(days: 30)));
    }).length;

    return {
      'totalDocuments': totalDocuments,
      'totalSize': totalSize,
      'formattedSize': _formatFileSize(totalSize),
      'privateDocuments': privateDocuments,
      'recentUploads': recentUploads,
      'averageFileSize': totalDocuments > 0 ? totalSize / totalDocuments : 0,
    };
  }

  // Private helper methods
  String _sanitizeFileName(String fileName) {
    // Remove special characters and spaces
    return fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
  }

  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'zip':
        return 'application/zip';
      default:
        return 'application/octet-stream';
    }
  }

  bool _supportsThumbnail(String extension) {
    return ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx']
        .contains(extension.toLowerCase());
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Cancel Current Upload
  void cancelUpload() {
    _currentUpload = null;
    _uploadProgress = 0.0;
    _setLoading(false);
    notifyListeners();
  }

  // Get Expired Documents
  List<Map<String, dynamic>> getExpiredDocuments() {
    final now = DateTime.now();
    return _clientDocuments.where((doc) {
      final expiryDate = doc['expiryDate'];
      return expiryDate != null && DateTime.parse(expiryDate).isBefore(now);
    }).toList();
  }

  // Get Documents Expiring Soon (next 30 days)
  List<Map<String, dynamic>> getDocumentsExpiringSoon() {
    final now = DateTime.now();
    final thirtyDaysFromNow = now.add(const Duration(days: 30));

    return _clientDocuments.where((doc) {
      final expiryDate = doc['expiryDate'];
      if (expiryDate == null) return false;

      final expiry = DateTime.parse(expiryDate);
      return expiry.isAfter(now) && expiry.isBefore(thirtyDaysFromNow);
    }).toList();
  }
}
