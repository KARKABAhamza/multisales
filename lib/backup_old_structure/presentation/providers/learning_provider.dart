import 'package:flutter/foundation.dart';

/// Learning Provider for MultiSales Client App
/// Handles user onboarding, tutorials, and learning modules
class LearningProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool _hasCompletedOnboarding = false;
  Map<String, dynamic>? _currentOnboardingStep;
  List<Map<String, dynamic>> _onboardingSteps = [];
  int _currentStepIndex = 0;

  List<Map<String, dynamic>> _tutorialModules = [];
  final Map<String, bool> _completedTutorials = {};
  final Map<String, double> _tutorialProgress = {};

  bool _showWelcomeGuide = true;
  final Map<String, bool> _featureIntroductions = {};

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  Map<String, dynamic>? get currentOnboardingStep => _currentOnboardingStep;
  List<Map<String, dynamic>> get onboardingSteps => _onboardingSteps;
  int get currentStepIndex => _currentStepIndex;
  List<Map<String, dynamic>> get tutorialModules => _tutorialModules;
  Map<String, bool> get completedTutorials => _completedTutorials;
  Map<String, double> get tutorialProgress => _tutorialProgress;
  bool get showWelcomeGuide => _showWelcomeGuide;
  Map<String, bool> get featureIntroductions => _featureIntroductions;

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

  // Initialize Learning System
  Future<bool> initializeLearningSystem(String clientId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      // Load onboarding progress
      await _loadOnboardingProgress(clientId);

      // Load tutorial modules
      await _loadTutorialModules();

      // Initialize feature introductions
      _initializeFeatureIntroductions();

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to initialize learning system: $e');
      _setLoading(false);
      return false;
    }
  }

  // Load Onboarding Steps
  Future<bool> _loadOnboardingProgress(String clientId) async {
    try {
      _onboardingSteps = [
        {
          'id': 'welcome',
          'title': 'Welcome to MultiSales',
          'subtitle': 'Your digital partner in Morocco',
          'description':
              'Discover all the services and features available to enhance your experience with MultiSales.',
          'type': 'welcome',
          'icon': '👋',
          'duration': 30, // seconds
          'isCompleted': false,
          'content': {
            'videoUrl': null,
            'imageUrl': 'assets/images/onboarding_welcome.png',
            'bullets': [
              'Manage your account anytime, anywhere',
              'Get instant support and assistance',
              'Access exclusive offers and promotions',
              'Track your services and appointments',
            ],
          },
        },
        {
          'id': 'account_setup',
          'title': 'Complete Your Profile',
          'subtitle': 'Personalize your experience',
          'description':
              'Complete your profile information to get personalized recommendations and better service.',
          'type': 'profile',
          'icon': '👤',
          'duration': 60,
          'isCompleted': false,
          'content': {
            'videoUrl': null,
            'imageUrl': 'assets/images/onboarding_profile.png',
            'bullets': [
              'Add your contact information',
              'Set your preferences',
              'Choose your language',
              'Enable notifications',
            ],
          },
        },
        {
          'id': 'service_overview',
          'title': 'Explore Our Services',
          'subtitle': 'Internet, TV, Mobile & More',
          'description':
              'Learn about our comprehensive range of services designed for your digital lifestyle.',
          'type': 'services',
          'icon': '🌐',
          'duration': 45,
          'isCompleted': false,
          'content': {
            'videoUrl': 'assets/videos/services_overview.mp4',
            'imageUrl': 'assets/images/onboarding_services.png',
            'bullets': [
              'High-speed fiber internet',
              'Premium TV packages',
              'Mobile plans and devices',
              'Smart home solutions',
            ],
          },
        },
        {
          'id': 'app_navigation',
          'title': 'Navigate the App',
          'subtitle': 'Find everything easily',
          'description':
              'Get familiar with the app\'s main features and learn how to navigate efficiently.',
          'type': 'navigation',
          'icon': '🧭',
          'duration': 90,
          'isCompleted': false,
          'content': {
            'videoUrl': 'assets/videos/app_navigation.mp4',
            'imageUrl': 'assets/images/onboarding_navigation.png',
            'bullets': [
              'Dashboard and quick actions',
              'Service management',
              'Support and chat features',
              'Account settings',
            ],
          },
        },
        {
          'id': 'support_options',
          'title': 'Get Help When You Need It',
          'subtitle': '24/7 support available',
          'description':
              'Learn about all the ways to get support and assistance when you need help.',
          'type': 'support',
          'icon': '🆘',
          'duration': 45,
          'isCompleted': false,
          'content': {
            'videoUrl': null,
            'imageUrl': 'assets/images/onboarding_support.png',
            'bullets': [
              'Live chat support',
              'WhatsApp assistance',
              'Phone support hotline',
              'Email support',
              'Self-service help center',
            ],
          },
        },
        {
          'id': 'ready_to_start',
          'title': 'You\'re All Set!',
          'subtitle': 'Welcome to the MultiSales family',
          'description':
              'Congratulations! You\'re ready to enjoy all the benefits of your MultiSales services.',
          'type': 'completion',
          'icon': '🎉',
          'duration': 30,
          'isCompleted': false,
          'content': {
            'videoUrl': null,
            'imageUrl': 'assets/images/onboarding_complete.png',
            'bullets': [
              'Your account is ready',
              'Explore all features',
              'Contact us anytime',
              'Enjoy your services!',
            ],
          },
        },
      ];

      // Check if onboarding is completed
      _hasCompletedOnboarding =
          false; // Will be loaded from storage in real app
      _currentStepIndex = 0;
      _currentOnboardingStep = _onboardingSteps[_currentStepIndex];

      return true;
    } catch (e) {
      _setError('Failed to load onboarding progress: $e');
      return false;
    }
  }

  // Load Tutorial Modules
  Future<bool> _loadTutorialModules() async {
    try {
      _tutorialModules = [
        {
          'id': 'account_management',
          'title': 'Account Management',
          'description':
              'Learn how to manage your account, update information, and track usage.',
          'category': 'basics',
          'difficulty': 'beginner',
          'estimatedTime': 10, // minutes
          'videoUrl': 'assets/videos/account_management.mp4',
          'thumbnailUrl': 'assets/images/tutorial_account.png',
          'steps': [
            'Access your account dashboard',
            'Update personal information',
            'View service details',
            'Check usage and billing',
            'Manage payment methods',
          ],
          'isAvailable': true,
          'prerequisites': [],
        },
        {
          'id': 'service_requests',
          'title': 'Service Requests & Orders',
          'description':
              'Discover how to request new services, upgrades, and track your orders.',
          'category': 'services',
          'difficulty': 'beginner',
          'estimatedTime': 15,
          'videoUrl': 'assets/videos/service_requests.mp4',
          'thumbnailUrl': 'assets/images/tutorial_services.png',
          'steps': [
            'Browse available services',
            'Request quotes and information',
            'Place new orders',
            'Track order status',
            'Schedule installations',
          ],
          'isAvailable': true,
          'prerequisites': ['account_management'],
        },
        {
          'id': 'support_system',
          'title': 'Getting Support',
          'description':
              'Master all the ways to get help and support for your services.',
          'category': 'support',
          'difficulty': 'beginner',
          'estimatedTime': 12,
          'videoUrl': 'assets/videos/support_system.mp4',
          'thumbnailUrl': 'assets/images/tutorial_support.png',
          'steps': [
            'Access the help center',
            'Start a live chat',
            'Create support tickets',
            'Contact via WhatsApp',
            'Schedule appointments',
          ],
          'isAvailable': true,
          'prerequisites': [],
        },
        {
          'id': 'mobile_features',
          'title': 'Mobile App Features',
          'description':
              'Explore advanced mobile features and shortcuts for better productivity.',
          'category': 'advanced',
          'difficulty': 'intermediate',
          'estimatedTime': 20,
          'videoUrl': 'assets/videos/mobile_features.mp4',
          'thumbnailUrl': 'assets/images/tutorial_mobile.png',
          'steps': [
            'Use quick actions',
            'Set up notifications',
            'Offline capabilities',
            'Location-based features',
            'Integration with other apps',
          ],
          'isAvailable': true,
          'prerequisites': ['account_management', 'service_requests'],
        },
        {
          'id': 'troubleshooting',
          'title': 'Basic Troubleshooting',
          'description':
              'Learn to resolve common issues with your services independently.',
          'category': 'technical',
          'difficulty': 'intermediate',
          'estimatedTime': 25,
          'videoUrl': 'assets/videos/troubleshooting.mp4',
          'thumbnailUrl': 'assets/images/tutorial_troubleshooting.png',
          'steps': [
            'Identify common problems',
            'Router and modem resets',
            'Connection diagnostics',
            'Speed testing',
            'When to contact support',
          ],
          'isAvailable': true,
          'prerequisites': ['support_system'],
        },
        {
          'id': 'advanced_settings',
          'title': 'Advanced Account Settings',
          'description':
              'Configure advanced settings for optimal service experience.',
          'category': 'advanced',
          'difficulty': 'advanced',
          'estimatedTime': 30,
          'videoUrl': 'assets/videos/advanced_settings.mp4',
          'thumbnailUrl': 'assets/images/tutorial_advanced.png',
          'steps': [
            'Network configuration',
            'Parental controls',
            'Bandwidth management',
            'Security settings',
            'Backup and restore',
          ],
          'isAvailable': false, // Unlocked after completing prerequisites
          'prerequisites': [
            'account_management',
            'mobile_features',
            'troubleshooting'
          ],
        },
      ];

      // Initialize progress tracking
      for (var module in _tutorialModules) {
        _completedTutorials[module['id']] = false;
        _tutorialProgress[module['id']] = 0.0;
      }

      return true;
    } catch (e) {
      _setError('Failed to load tutorial modules: $e');
      return false;
    }
  }

  // Initialize Feature Introductions
  void _initializeFeatureIntroductions() {
    _featureIntroductions.clear();
    _featureIntroductions.addAll({
      'dashboard': true,
      'services': true,
      'support_chat': true,
      'appointments': true,
      'notifications': true,
      'location_services': true,
      'account_settings': true,
    });
  }

  // Progress to Next Onboarding Step
  Future<bool> nextOnboardingStep() async {
    if (_currentStepIndex < _onboardingSteps.length - 1) {
      // Mark current step as completed
      _onboardingSteps[_currentStepIndex]['isCompleted'] = true;

      _currentStepIndex++;
      _currentOnboardingStep = _onboardingSteps[_currentStepIndex];

      notifyListeners();
      return true;
    } else {
      // Complete onboarding
      return await completeOnboarding();
    }
  }

  // Go to Previous Onboarding Step
  bool previousOnboardingStep() {
    if (_currentStepIndex > 0) {
      _currentStepIndex--;
      _currentOnboardingStep = _onboardingSteps[_currentStepIndex];
      notifyListeners();
      return true;
    }
    return false;
  }

  // Skip Onboarding
  Future<bool> skipOnboarding() async {
    _hasCompletedOnboarding = true;
    _currentOnboardingStep = null;
    notifyListeners();
    return true;
  }

  // Complete Onboarding
  Future<bool> completeOnboarding() async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // Mark all steps as completed
      for (var step in _onboardingSteps) {
        step['isCompleted'] = true;
      }

      _hasCompletedOnboarding = true;
      _currentOnboardingStep = null;

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to complete onboarding: $e');
      _setLoading(false);
      return false;
    }
  }

  // Start Tutorial Module
  Future<bool> startTutorial(String tutorialId) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final tutorial = _tutorialModules.firstWhere(
        (t) => t['id'] == tutorialId,
        orElse: () => {},
      );

      if (tutorial.isEmpty) {
        _setError('Tutorial not found');
        _setLoading(false);
        return false;
      }

      if (!tutorial['isAvailable']) {
        _setError('Tutorial not available. Complete prerequisites first.');
        _setLoading(false);
        return false;
      }

      // Check prerequisites
      final prerequisites = tutorial['prerequisites'] as List<String>;
      for (String prereq in prerequisites) {
        if (!(_completedTutorials[prereq] ?? false)) {
          _setError('Please complete the required tutorials first.');
          _setLoading(false);
          return false;
        }
      }

      _tutorialProgress[tutorialId] = 0.1; // Started
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to start tutorial: $e');
      _setLoading(false);
      return false;
    }
  }

  // Update Tutorial Progress
  bool updateTutorialProgress(String tutorialId, double progress) {
    if (progress < 0.0 || progress > 1.0) return false;

    _tutorialProgress[tutorialId] = progress;

    // Mark as completed if progress is 100%
    if (progress >= 1.0) {
      _completedTutorials[tutorialId] = true;
      _checkForUnlockedTutorials();
    }

    notifyListeners();
    return true;
  }

  // Complete Tutorial
  Future<bool> completeTutorial(String tutorialId) async {
    try {
      _completedTutorials[tutorialId] = true;
      _tutorialProgress[tutorialId] = 1.0;

      _checkForUnlockedTutorials();
      notifyListeners();

      return true;
    } catch (e) {
      _setError('Failed to complete tutorial: $e');
      return false;
    }
  }

  // Check for Unlocked Tutorials
  void _checkForUnlockedTutorials() {
    for (var tutorial in _tutorialModules) {
      if (!tutorial['isAvailable']) {
        final prerequisites = tutorial['prerequisites'] as List<String>;
        bool allPrerequisitesMet = prerequisites.every(
          (prereq) => _completedTutorials[prereq] ?? false,
        );

        if (allPrerequisitesMet) {
          tutorial['isAvailable'] = true;
        }
      }
    }
  }

  // Dismiss Feature Introduction
  void dismissFeatureIntroduction(String featureId) {
    _featureIntroductions[featureId] = false;
    notifyListeners();
  }

  // Show Welcome Guide
  void showWelcomeGuideAgain() {
    _showWelcomeGuide = true;
    notifyListeners();
  }

  // Hide Welcome Guide
  void hideWelcomeGuide() {
    _showWelcomeGuide = false;
    notifyListeners();
  }

  // Get Available Tutorials
  List<Map<String, dynamic>> getAvailableTutorials() {
    return _tutorialModules.where((t) => t['isAvailable'] == true).toList();
  }

  // Get Tutorials by Category
  List<Map<String, dynamic>> getTutorialsByCategory(String category) {
    return _tutorialModules
        .where((t) => t['category'] == category && t['isAvailable'] == true)
        .toList();
  }

  // Get Learning Progress Summary
  Map<String, dynamic> getLearningProgressSummary() {
    final totalTutorials = _tutorialModules.length;
    final completedCount =
        _completedTutorials.values.where((completed) => completed).length;
    final overallProgress =
        totalTutorials > 0 ? completedCount / totalTutorials : 0.0;

    return {
      'totalTutorials': totalTutorials,
      'completedTutorials': completedCount,
      'overallProgress': overallProgress,
      'onboardingCompleted': _hasCompletedOnboarding,
      'availableTutorials': getAvailableTutorials().length,
    };
  }

  // Reset Learning Progress (for testing)
  void resetLearningProgress() {
    _hasCompletedOnboarding = false;
    _currentStepIndex = 0;
    _currentOnboardingStep =
        _onboardingSteps.isNotEmpty ? _onboardingSteps[0] : null;

    for (var tutorial in _tutorialModules) {
      _completedTutorials[tutorial['id']] = false;
      _tutorialProgress[tutorial['id']] = 0.0;
      tutorial['isAvailable'] = (tutorial['prerequisites'] as List).isEmpty;
    }

    _initializeFeatureIntroductions();
    _showWelcomeGuide = true;

    notifyListeners();
  }
}
