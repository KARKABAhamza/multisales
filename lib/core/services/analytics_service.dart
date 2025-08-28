import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Service pour gérer Firebase Analytics dans l'application MultiSales
/// Suit les événements utilisateur et les métriques de performance
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Obtenir l'instance Firebase Analytics
  FirebaseAnalytics get analytics => _analytics;

  /// Obtenir l'observateur pour GoRouter
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // Événements d'authentification

  /// Suivre la connexion utilisateur
  Future<void> logLogin({String? method}) async {
    try {
      await _analytics.logLogin(loginMethod: method ?? 'email');
      if (kDebugMode) {
        print('Analytics: User login tracked');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error logging login event: $e');
      }
    }
  }

  /// Suivre l'inscription utilisateur
  Future<void> logSignUp({String? method}) async {
    try {
      await _analytics.logSignUp(signUpMethod: method ?? 'email');
      if (kDebugMode) {
        print('Analytics: User signup tracked');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error logging signup event: $e');
      }
    }
  }

  // Événements d'onboarding

  /// Suivre le début de l'onboarding
  Future<void> logOnboardingStart({String? userRole}) async {
    try {
      await _analytics.logEvent(
        name: 'onboarding_start',
        parameters: <String, Object>{
          'user_role': userRole ?? 'unknown',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      if (kDebugMode) {
        print('Analytics: Onboarding start tracked');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error logging onboarding start: $e');
      }
    }
  }

  /// Suivre la progression de l'onboarding
  Future<void> logOnboardingProgress({
    required String stepId,
    required int stepNumber,
    required int totalSteps,
    String? userRole,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'onboarding_progress',
        parameters: <String, Object>{
          'step_id': stepId,
          'step_number': stepNumber,
          'total_steps': totalSteps,
          'user_role': userRole ?? 'unknown',
          'progress_percentage': ((stepNumber / totalSteps) * 100).round(),
        },
      );
      if (kDebugMode) {
        print(
            'Analytics: Onboarding progress tracked - Step $stepNumber/$totalSteps');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error logging onboarding progress: $e');
      }
    }
  }

  /// Suivre la completion de l'onboarding
  Future<void> logOnboardingComplete({
    String? userRole,
    int? completionTimeMinutes,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'onboarding_complete',
        parameters: <String, Object>{
          'user_role': userRole ?? 'unknown',
          'completion_time_minutes': completionTimeMinutes ?? 0,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      if (kDebugMode) {
        print('Analytics: Onboarding completion tracked');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error logging onboarding completion: $e');
      }
    }
  }

  // Événements de formation

  /// Suivre le début d'un module de formation
  Future<void> logTrainingModuleStart({
    required String moduleId,
    required String moduleName,
    String? userRole,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'training_module_start',
        parameters: <String, Object>{
          'module_id': moduleId,
          'module_name': moduleName,
          'user_role': userRole ?? 'unknown',
        },
      );
      if (kDebugMode) {
        print('Analytics: Training module start tracked - $moduleName');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error logging training module start: $e');
      }
    }
  }

  /// Suivre la completion d'un module de formation
  Future<void> logTrainingModuleComplete({
    required String moduleId,
    required String moduleName,
    required int completionTimeMinutes,
    required double score,
    String? userRole,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'training_module_complete',
        parameters: <String, Object>{
          'module_id': moduleId,
          'module_name': moduleName,
          'completion_time_minutes': completionTimeMinutes,
          'score': score,
          'user_role': userRole ?? 'unknown',
        },
      );
      if (kDebugMode) {
        print(
            'Analytics: Training module completion tracked - $moduleName (Score: $score)');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error logging training module completion: $e');
      }
    }
  }

  // Événements de navigation et engagement

  /// Suivre la visite d'une page
  Future<void> logPageView({
    required String pageName,
    String? pageClass,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: pageName,
        screenClass: pageClass,
        parameters: parameters,
      );
      if (kDebugMode) {
        print('Analytics: Page view tracked - $pageName');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error logging page view: $e');
      }
    }
  }

  /// Suivre un événement personnalisé
  Future<void> logCustomEvent({
    required String eventName,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: eventName,
        parameters: parameters,
      );
      if (kDebugMode) {
        print('Analytics: Custom event tracked - $eventName');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error logging custom event: $e');
      }
    }
  }

  // Propriétés utilisateur

  /// Définir les propriétés de l'utilisateur
  Future<void> setUserProperties({
    String? userId,
    String? userRole,
    String? department,
    String? location,
  }) async {
    try {
      if (userId != null) {
        await _analytics.setUserId(id: userId);
      }

      await _analytics.setUserProperty(
        name: 'user_role',
        value: userRole ?? 'unknown',
      );

      if (department != null) {
        await _analytics.setUserProperty(
          name: 'department',
          value: department,
        );
      }

      if (location != null) {
        await _analytics.setUserProperty(
          name: 'location',
          value: location,
        );
      }

      if (kDebugMode) {
        print('Analytics: User properties set');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error setting user properties: $e');
      }
    }
  }

  /// Activer/désactiver la collecte d'analytics
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    try {
      await _analytics.setAnalyticsCollectionEnabled(enabled);
      if (kDebugMode) {
        print('Analytics: Collection ${enabled ? 'enabled' : 'disabled'}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error setting analytics collection: $e');
      }
    }
  }

  /// Réinitialiser les données analytics
  Future<void> resetAnalyticsData() async {
    try {
      await _analytics.resetAnalyticsData();
      if (kDebugMode) {
        print('Analytics: Data reset');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error resetting analytics data: $e');
      }
    }
  }
}
