import 'package:flutter/foundation.dart';
import '../services/firebase_service.dart';

/// Provider pour gérer l'état Firebase global dans l'application
/// Fournit un accès centralisé aux services Firebase et leur état
class FirebaseProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  bool _isInitialized = false;
  bool _isInitializing = false;
  String? _errorMessage;
  Map<String, dynamic> _remoteConfigValues = {};
  String? _fcmToken;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isInitializing => _isInitializing;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic> get remoteConfigValues => _remoteConfigValues;
  String? get fcmToken => _fcmToken;
  FirebaseService get firebaseService => _firebaseService;

  /// Initialiser Firebase avec tous les services
  Future<void> initializeFirebase() async {
    if (_isInitialized || _isInitializing) return;

    _setInitializing(true);
    _setError(null);

    try {
      // L'initialisation est déjà faite dans main.dart
      // Ici on récupère juste l'état
      _isInitialized = _firebaseService.isInitialized;

      if (_isInitialized) {
        await _loadRemoteConfigValues();
        await _loadFCMToken();
      }

      notifyListeners();
    } catch (e) {
      _setError('Erreur d\'initialisation Firebase: ${e.toString()}');
      if (kDebugMode) {
        print('FirebaseProvider: Error initializing: $e');
      }
    } finally {
      _setInitializing(false);
    }
  }

  /// Charger les valeurs Remote Config
  Future<void> _loadRemoteConfigValues() async {
    try {
      _remoteConfigValues = {
        'welcome_message': _firebaseService.getRemoteConfigValue(
            'welcome_message', 'Bienvenue!'),
        'min_app_version':
            _firebaseService.getRemoteConfigValue('min_app_version', '1.0.0'),
        'maintenance_mode':
            _firebaseService.getRemoteConfigValue('maintenance_mode', false),
        'feature_new_onboarding': _firebaseService.getRemoteConfigValue(
            'feature_new_onboarding', true),
        'support_email': _firebaseService.getRemoteConfigValue(
            'support_email', 'support@multisales.com'),
      };
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('FirebaseProvider: Error loading remote config: $e');
      }
    }
  }

  /// Charger le token FCM
  Future<void> _loadFCMToken() async {
    try {
      _fcmToken = await _firebaseService.getMessagingToken();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('FirebaseProvider: Error loading FCM token: $e');
      }
    }
  }

  /// Actualiser Remote Config
  Future<bool> refreshRemoteConfig() async {
    try {
      final success = await _firebaseService.refreshRemoteConfig();
      if (success) {
        await _loadRemoteConfigValues();
      }
      return success;
    } catch (e) {
      _setError('Erreur lors de l\'actualisation: ${e.toString()}');
      return false;
    }
  }

  /// S'abonner aux notifications pour un rôle
  Future<void> subscribeToRoleNotifications(String role) async {
    try {
      await _firebaseService.subscribeToTopic('role_$role');
      await _firebaseService.subscribeToTopic('all_users');

      if (kDebugMode) {
        print('FirebaseProvider: Subscribed to role notifications: $role');
      }
    } catch (e) {
      _setError('Erreur d\'abonnement: ${e.toString()}');
    }
  }

  /// Se désabonner des notifications
  Future<void> unsubscribeFromRoleNotifications(String role) async {
    try {
      await _firebaseService.unsubscribeFromTopic('role_$role');

      if (kDebugMode) {
        print('FirebaseProvider: Unsubscribed from role notifications: $role');
      }
    } catch (e) {
      _setError('Erreur de désabonnement: ${e.toString()}');
    }
  }

  /// Enregistrer une erreur dans Crashlytics
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    bool fatal = false,
    Map<String, dynamic>? customKeys,
  }) async {
    try {
      await _firebaseService.recordError(
        error,
        stackTrace,
        fatal: fatal,
        customKeys: customKeys,
      );
    } catch (e) {
      if (kDebugMode) {
        print('FirebaseProvider: Error recording crash: $e');
      }
    }
  }

  /// Créer une trace de performance
  Future<void> startPerformanceTrace(String name) async {
    try {
      await _firebaseService.createTrace(name);
    } catch (e) {
      if (kDebugMode) {
        print('FirebaseProvider: Error creating trace: $e');
      }
    }
  }

  /// Mettre à jour les informations utilisateur
  Future<void> updateUserInfo({
    required String userId,
    String? email,
    String? name,
    String? role,
  }) async {
    try {
      await _firebaseService.setUserInfo(
        userId: userId,
        email: email,
        name: name,
      );

      // S'abonner aux notifications du rôle
      if (role != null) {
        await subscribeToRoleNotifications(role);
      }

      if (kDebugMode) {
        print('FirebaseProvider: User info updated');
      }
    } catch (e) {
      _setError('Erreur de mise à jour utilisateur: ${e.toString()}');
    }
  }

  /// Vérifier si l'app est en mode maintenance
  bool get isMaintenanceMode {
    return _remoteConfigValues['maintenance_mode'] ?? false;
  }

  /// Obtenir le message de bienvenue
  String get welcomeMessage {
    return _remoteConfigValues['welcome_message'] ??
        'Bienvenue dans MultiSales!';
  }

  /// Vérifier si la nouvelle fonctionnalité d'onboarding est activée
  bool get isNewOnboardingEnabled {
    return _remoteConfigValues['feature_new_onboarding'] ?? true;
  }

  /// Obtenir l'email de support
  String get supportEmail {
    return _remoteConfigValues['support_email'] ?? 'support@multisales.com';
  }

  // Méthodes privées
  void _setInitializing(bool initializing) {
    _isInitializing = initializing;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }
}
