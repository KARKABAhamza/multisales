import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TrainingModule {
  final String id;
  final String title;
  final String description;
  final Duration estimatedDuration;
  final bool isCompleted;
  final double progress; // 0.0 to 1.0
  final List<String> videoUrls;
  final List<String> documentUrls;

  TrainingModule({
    required this.id,
    required this.title,
    required this.description,
    required this.estimatedDuration,
    this.isCompleted = false,
    this.progress = 0.0,
    this.videoUrls = const [],
    this.documentUrls = const [],
  });

  TrainingModule copyWith({
    String? id,
    String? title,
    String? description,
    Duration? estimatedDuration,
    bool? isCompleted,
    double? progress,
    List<String>? videoUrls,
    List<String>? documentUrls,
  }) {
    return TrainingModule(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      isCompleted: isCompleted ?? this.isCompleted,
      progress: progress ?? this.progress,
      videoUrls: videoUrls ?? this.videoUrls,
      documentUrls: documentUrls ?? this.documentUrls,
    );
  }

  // Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'estimatedDurationMinutes': estimatedDuration.inMinutes,
      'isCompleted': isCompleted,
      'progress': progress,
      'videoUrls': videoUrls,
      'documentUrls': documentUrls,
    };
  }

  // Create from JSON
  factory TrainingModule.fromJson(Map<String, dynamic> json) {
    return TrainingModule(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      estimatedDuration:
          Duration(minutes: json['estimatedDurationMinutes'] ?? 0),
      isCompleted: json['isCompleted'] ?? false,
      progress: (json['progress'] ?? 0.0).toDouble(),
      videoUrls: List<String>.from(json['videoUrls'] ?? []),
      documentUrls: List<String>.from(json['documentUrls'] ?? []),
    );
  }
}

class TrainingProvider with ChangeNotifier {
  List<TrainingModule> _modules = [];
  String? _currentModuleId;
  bool _isLoading = false;
  String? _errorMessage;

  // Firebase service (public-only)

  // Getters
  List<TrainingModule> get modules => _modules;
  String? get currentModuleId => _currentModuleId;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  TrainingModule? get currentModule {
    if (_currentModuleId == null) return null;

    try {
      return _modules.firstWhere((module) => module.id == _currentModuleId);
    } catch (e) {
      return _modules.isNotEmpty ? _modules.first : null;
    }
  }

  double get overallProgress {
    if (_modules.isEmpty) return 0.0;
    final totalProgress = _modules.fold<double>(
      0.0,
      (sum, module) => sum + module.progress,
    );
    return totalProgress / _modules.length;
  }

  int get completedModulesCount =>
      _modules.where((module) => module.isCompleted).length;

  TrainingProvider() {
    _loadTrainingModules();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Load training modules (simulated data for now)
  Future<void> _loadTrainingModules() async {
    _setLoading(true);

    try {
      // Simulate loading from API or local storage
      await Future.delayed(const Duration(milliseconds: 500));

      _modules = [
        TrainingModule(
          id: 'intro_multisales',
          title: 'Introduction to MultiSales',
          description: 'Learn the basics of our platform and company culture',
          estimatedDuration: const Duration(minutes: 30),
          videoUrls: ['assets/videos/intro.mp4'],
          documentUrls: ['assets/documents/company_handbook.pdf'],
        ),
        TrainingModule(
          id: 'product_knowledge',
          title: 'Product Knowledge',
          description: 'Comprehensive overview of our products and services',
          estimatedDuration: const Duration(hours: 2),
          videoUrls: [
            'assets/videos/product_overview.mp4',
            'assets/videos/product_demo.mp4',
          ],
          documentUrls: [
            'assets/documents/product_catalog.pdf',
            'assets/documents/pricing_guide.pdf',
          ],
        ),
        TrainingModule(
          id: 'customer_service',
          title: 'Customer Service Excellence',
          description: 'Best practices for customer interaction and support',
          estimatedDuration: const Duration(minutes: 45),
          videoUrls: ['assets/videos/customer_service.mp4'],
          documentUrls: ['assets/documents/service_standards.pdf'],
        ),
        TrainingModule(
          id: 'compliance_training',
          title: 'Compliance and Legal Requirements',
          description: 'Understanding legal requirements and company policies',
          estimatedDuration: const Duration(hours: 1),
          videoUrls: ['assets/videos/compliance.mp4'],
          documentUrls: [
            'assets/documents/compliance_guide.pdf',
            'assets/documents/legal_requirements.pdf',
          ],
        ),
        TrainingModule(
          id: 'technology_tools',
          title: 'Technology and Tools',
          description: 'Master the tools and systems you\'ll use daily',
          estimatedDuration: const Duration(hours: 1, minutes: 30),
          videoUrls: [
            'assets/videos/crm_tutorial.mp4',
            'assets/videos/tools_overview.mp4',
          ],
          documentUrls: ['assets/documents/tools_manual.pdf'],
        ),
      ];

      // Load saved progress after loading modules
      await _loadSavedProgress();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load training modules: ${e.toString()}');
      _setLoading(false);
    }
  }

  // Start a training module
  Future<void> startModule(String moduleId) async {
    final moduleIndex = _modules.indexWhere((module) => module.id == moduleId);
    if (moduleIndex != -1) {
      _currentModuleId = moduleId;
      notifyListeners();
    }
  }

  // Update module progress
  Future<void> updateModuleProgress(String moduleId, double progress) async {
    final moduleIndex = _modules.indexWhere((module) => module.id == moduleId);
    if (moduleIndex != -1) {
      final updatedModule = _modules[moduleIndex].copyWith(
        progress: progress.clamp(0.0, 1.0),
        isCompleted: progress >= 1.0,
      );

      _modules[moduleIndex] = updatedModule;
      notifyListeners();

      // Save progress (implement persistence later)
      await _saveProgress();
    }
  }

  // Complete a training module
  Future<void> completeModule(String moduleId) async {
    await updateModuleProgress(moduleId, 1.0);
  }

  // Reset a module's progress
  Future<void> resetModuleProgress(String moduleId) async {
    final moduleIndex = _modules.indexWhere((module) => module.id == moduleId);
    if (moduleIndex != -1) {
      final resetModule = _modules[moduleIndex].copyWith(
        progress: 0.0,
        isCompleted: false,
      );

      _modules[moduleIndex] = resetModule;
      notifyListeners();

      await _saveProgress();
    }
  }

  // Reset all training progress
  Future<void> resetAllProgress() async {
    _modules = _modules
        .map((module) => module.copyWith(progress: 0.0, isCompleted: false))
        .toList();

    _currentModuleId = null;
    notifyListeners();

    await _saveProgress();
  }

  // Get modules by completion status
  List<TrainingModule> getModulesByStatus({required bool completed}) {
    return _modules.where((module) => module.isCompleted == completed).toList();
  }

  // Search modules by title or description
  List<TrainingModule> searchModules(String query) {
    if (query.isEmpty) return _modules;

    final lowerQuery = query.toLowerCase();
    return _modules
        .where(
          (module) =>
              module.title.toLowerCase().contains(lowerQuery) ||
              module.description.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  // Save progress to SharedPreferences and Firebase
  Future<void> _saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert modules to JSON for storage
      final modulesJson = _modules.map((module) => module.toJson()).toList();
      final progressData = {
        'modules': modulesJson,
        'currentModuleId': _currentModuleId,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      // Save to SharedPreferences
      await prefs.setString('training_progress', jsonEncode(progressData));

      // Save to Firebase for cross-device sync
      await _saveProgressToFirebase(progressData);
    } catch (e) {
      _setError('Failed to save progress: ${e.toString()}');
    }
  }

  // Load saved progress from SharedPreferences and Firebase
  Future<void> _loadSavedProgress() async {
    try {
      // First try to load from Firebase (for cross-device sync)
      await _loadProgressFromFirebase();

      // Also load from SharedPreferences as fallback
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('training_progress');

      if (savedData != null) {
        final progressData = jsonDecode(savedData) as Map<String, dynamic>;
        final modulesList = progressData['modules'] as List<dynamic>?;

        if (modulesList != null && _modules.isNotEmpty) {
          // Update existing modules with saved progress
          for (final savedModuleJson in modulesList) {
            final savedModule = TrainingModule.fromJson(savedModuleJson);
            final moduleIndex =
                _modules.indexWhere((m) => m.id == savedModule.id);

            if (moduleIndex != -1) {
              _modules[moduleIndex] = _modules[moduleIndex].copyWith(
                progress: savedModule.progress,
                isCompleted: savedModule.isCompleted,
              );
            }
          }

          // Restore current module
          _currentModuleId = progressData['currentModuleId'];
          notifyListeners();
        }
      }
    } catch (e) {
      // Silently fail for progress loading - don't show error to user
      if (kDebugMode) {
        print('Failed to load saved progress: $e');
      }
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear saved progress from local storage and Firebase
  Future<void> clearSavedProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('training_progress');

      // Also clear Firebase data (public-only, no user context)
      // If you want to clear all training progress for all users, implement admin logic here.
    } catch (e) {
      if (kDebugMode) {
        print('Failed to clear saved progress: $e');
      }
    }
  }

  // Export progress data (useful for debugging or data transfer)
  Map<String, dynamic> exportProgressData() {
    return {
      'modules': _modules.map((module) => module.toJson()).toList(),
      'currentModuleId': _currentModuleId,
      'overallProgress': overallProgress,
      'completedModulesCount': completedModulesCount,
      'exportedAt': DateTime.now().toIso8601String(),
    };
  }

  // Import progress data
  Future<void> importProgressData(Map<String, dynamic> data) async {
    try {
      final modulesList = data['modules'] as List<dynamic>?;

      if (modulesList != null && _modules.isNotEmpty) {
        for (final moduleJson in modulesList) {
          final importedModule = TrainingModule.fromJson(moduleJson);
          final moduleIndex =
              _modules.indexWhere((m) => m.id == importedModule.id);

          if (moduleIndex != -1) {
            _modules[moduleIndex] = _modules[moduleIndex].copyWith(
              progress: importedModule.progress,
              isCompleted: importedModule.isCompleted,
            );
          }
        }

        _currentModuleId = data['currentModuleId'];
        notifyListeners();

        // Save the imported progress
        await _saveProgress();
      }
    } catch (e) {
      _setError('Failed to import progress data: ${e.toString()}');
    }
  }

  // Firebase integration methods
  Future<void> _saveProgressToFirebase(
      Map<String, dynamic> progressData) async {
    // Public-only: No user context, so skip per-user Firebase sync
    // If you want to sync all progress for all users, implement admin logic here.
  }

  Future<void> _loadProgressFromFirebase() async {
    // Public-only: No user context, so skip per-user Firebase sync
    // If you want to load all progress for all users, implement admin logic here.
  }

  // Refresh training modules and sync with Firebase
  Future<void> refreshModules() async {
    await _loadTrainingModules();
  }

  // Manually sync progress with Firebase
  Future<void> syncWithFirebase() async {
    _setLoading(true);
    try {
      // First try to load latest from Firebase
      await _loadProgressFromFirebase();

      // Then save current state to Firebase to ensure sync
      await _saveProgress();

      _setLoading(false);
    } catch (e) {
      _setError('Failed to sync with Firebase: ${e.toString()}');
      _setLoading(false);
    }
  }
}
