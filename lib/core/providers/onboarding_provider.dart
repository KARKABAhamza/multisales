import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserRole { sales, support, technician }

class OnboardingStep {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final UserRole role;

  OnboardingStep({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.role,
  });

  OnboardingStep copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    UserRole? role,
  }) {
    return OnboardingStep(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      role: role ?? this.role,
    );
  }
}

class OnboardingProvider with ChangeNotifier {
  UserRole? _currentUserRole;
  List<OnboardingStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserRole? get currentUserRole => _currentUserRole;
  List<OnboardingStep> get steps => _steps;
  int get currentStepIndex => _currentStepIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isOnboardingComplete =>
      _steps.isNotEmpty && _steps.every((step) => step.isCompleted);
  OnboardingStep? get currentStep =>
      _steps.isNotEmpty && _currentStepIndex < _steps.length
      ? _steps[_currentStepIndex]
      : null;

  OnboardingProvider() {
    _loadOnboardingState();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Initialize onboarding for a specific role
  Future<void> initializeOnboarding(UserRole role) async {
    _setLoading(true);
    _currentUserRole = role;
    _steps = _getStepsForRole(role);
    _currentStepIndex = 0;

    await _saveOnboardingState();
    _setLoading(false);
  }

  // Get steps based on user role
  List<OnboardingStep> _getStepsForRole(UserRole role) {
    switch (role) {
      case UserRole.sales:
        return [
          OnboardingStep(
            id: 'sales_welcome',
            title: 'Welcome to Sales Team',
            description:
                'Introduction to MultiSales platform and sales processes',
            role: role,
          ),
          OnboardingStep(
            id: 'product_catalog',
            title: 'Product Catalog Training',
            description: 'Learn about our products and services',
            role: role,
          ),
          OnboardingStep(
            id: 'crm_system',
            title: 'CRM System Overview',
            description:
                'Understanding the customer relationship management system',
            role: role,
          ),
          OnboardingStep(
            id: 'sales_techniques',
            title: 'Sales Techniques',
            description: 'Best practices and proven sales methodologies',
            role: role,
          ),
        ];
      case UserRole.support:
        return [
          OnboardingStep(
            id: 'support_welcome',
            title: 'Welcome to Support Team',
            description: 'Introduction to customer support processes',
            role: role,
          ),
          OnboardingStep(
            id: 'ticket_system',
            title: 'Ticket Management System',
            description: 'Learn how to handle customer tickets effectively',
            role: role,
          ),
          OnboardingStep(
            id: 'troubleshooting',
            title: 'Troubleshooting Guide',
            description: 'Common issues and their solutions',
            role: role,
          ),
          OnboardingStep(
            id: 'escalation_procedures',
            title: 'Escalation Procedures',
            description: 'When and how to escalate customer issues',
            role: role,
          ),
        ];
      case UserRole.technician:
        return [
          OnboardingStep(
            id: 'tech_welcome',
            title: 'Welcome to Technical Team',
            description: 'Introduction to technical processes and systems',
            role: role,
          ),
          OnboardingStep(
            id: 'system_architecture',
            title: 'System Architecture',
            description: 'Understanding our technical infrastructure',
            role: role,
          ),
          OnboardingStep(
            id: 'maintenance_procedures',
            title: 'Maintenance Procedures',
            description: 'Regular maintenance tasks and schedules',
            role: role,
          ),
          OnboardingStep(
            id: 'emergency_protocols',
            title: 'Emergency Response Protocols',
            description: 'How to handle system emergencies and outages',
            role: role,
          ),
        ];
    }
  }

  // Complete current step and move to next
  Future<void> completeCurrentStep() async {
    if (_currentStepIndex < _steps.length) {
      _steps[_currentStepIndex] = _steps[_currentStepIndex].copyWith(
        isCompleted: true,
      );

      if (_currentStepIndex < _steps.length - 1) {
        _currentStepIndex++;
      }

      await _saveOnboardingState();
      notifyListeners();
    }
  }

  // Go to specific step
  Future<void> goToStep(int stepIndex) async {
    if (stepIndex >= 0 && stepIndex < _steps.length) {
      _currentStepIndex = stepIndex;
      await _saveOnboardingState();
      notifyListeners();
    }
  }

  // Reset onboarding
  Future<void> resetOnboarding() async {
    _currentStepIndex = 0;
    _steps = _steps.map((step) => step.copyWith(isCompleted: false)).toList();
    await _saveOnboardingState();
    notifyListeners();
  }

  // Save onboarding state to SharedPreferences
  Future<void> _saveOnboardingState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_currentUserRole != null) {
        await prefs.setString('onboarding_role', _currentUserRole!.name);
        await prefs.setInt('onboarding_current_step', _currentStepIndex);

        // Save completed steps
        final completedSteps = _steps
            .asMap()
            .entries
            .where((entry) => entry.value.isCompleted)
            .map((entry) => entry.key)
            .toList();
        await prefs.setStringList(
          'onboarding_completed_steps',
          completedSteps.map((index) => index.toString()).toList(),
        );
      }
    } catch (e) {
      _setError('Failed to save onboarding progress: ${e.toString()}');
    }
  }

  // Load onboarding state from SharedPreferences
  Future<void> _loadOnboardingState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final roleString = prefs.getString('onboarding_role');

      if (roleString != null) {
        _currentUserRole = UserRole.values.firstWhere(
          (role) => role.name == roleString,
          orElse: () => UserRole.sales,
        );

        _steps = _getStepsForRole(_currentUserRole!);
        _currentStepIndex = prefs.getInt('onboarding_current_step') ?? 0;

        // Load completed steps
        final completedStepsStrings =
            prefs.getStringList('onboarding_completed_steps') ?? [];
        final completedStepIndices = completedStepsStrings
            .map((indexString) => int.tryParse(indexString))
            .where((index) => index != null)
            .cast<int>()
            .toList();

        // Mark completed steps
        for (int index in completedStepIndices) {
          if (index < _steps.length) {
            _steps[index] = _steps[index].copyWith(isCompleted: true);
          }
        }

        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to load onboarding progress: ${e.toString()}');
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
