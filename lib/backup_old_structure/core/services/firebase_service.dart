import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Service Firebase Master - Initialise et gère tous les services Firebase
/// Centralise l'accès à tous les SDKs Firebase pour MultiSales
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Instances des services Firebase
  FirebaseApp? _app;
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;
  FirebaseStorage? _storage;
  FirebaseAnalytics? _analytics;
  FirebaseCrashlytics? _crashlytics;
  FirebasePerformance? _performance;
  FirebaseRemoteConfig? _remoteConfig;
  FirebaseMessaging? _messaging;

  bool _isInitialized = false;

  // Getters pour accéder aux services
  FirebaseApp get app => _app!;
  FirebaseAuth get auth => _auth!;
  FirebaseFirestore get firestore => _firestore!;
  FirebaseStorage get storage => _storage!;
  FirebaseAnalytics get analytics => _analytics!;
  FirebaseCrashlytics get crashlytics => _crashlytics!;
  FirebasePerformance get performance => _performance!;
  FirebaseRemoteConfig get remoteConfig => _remoteConfig!;
  FirebaseMessaging get messaging => _messaging!;

  bool get isInitialized => _isInitialized;

  /// Initialisation complète de Firebase avec tous les services
  Future<void> initializeFirebase({
    required FirebaseOptions options,
    bool enableCrashlytics = true,
    bool enablePerformance = true,
    bool enableAnalytics = true,
    bool enableRemoteConfig = true,
    bool enableMessaging = true,
    bool enableAppCheck =
        false, // Désactivé par défaut car nécessite configuration supplémentaire
  }) async {
    try {
      if (_isInitialized) {
        if (kDebugMode) {
          print('Firebase: Already initialized');
        }
        return;
      }

      // 1. Initialiser Firebase Core
      _app = await Firebase.initializeApp(options: options);
      if (kDebugMode) {
        print('Firebase: Core initialized ✓');
      }

      // 2. Initialiser App Check (optionnel, pour la sécurité)
      if (enableAppCheck) {
        await _initializeAppCheck();
      }

      // 3. Initialiser les services principaux
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _storage = FirebaseStorage.instance;

      // 4. Initialiser Analytics
      if (enableAnalytics) {
        await _initializeAnalytics();
      }

      // 5. Initialiser Crashlytics
      if (enableCrashlytics) {
        await _initializeCrashlytics();
      }

      // 6. Initialiser Performance Monitoring
      if (enablePerformance) {
        await _initializePerformance();
      }

      // 7. Initialiser Remote Config
      if (enableRemoteConfig) {
        await _initializeRemoteConfig();
      }

      // 8. Initialiser Cloud Messaging
      if (enableMessaging) {
        await _initializeMessaging();
      }

      // 9. Configuration Firestore
      await _configureFirestore();

      _isInitialized = true;

      if (kDebugMode) {
        print('Firebase: Complete initialization successful ✓');
      }

      // Log de l'initialisation réussie avec nom d'événement valide
      await analytics.logEvent(
        name: 'app_initialized',
        parameters: {
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'services_enabled': _getEnabledServices(),
        },
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Firebase: Initialization error: $e');
        print('Stack trace: $stackTrace');
      }

      // Log l'erreur si Crashlytics est disponible
      if (_crashlytics != null) {
        await _crashlytics!.recordError(e, stackTrace);
      }

      rethrow;
    }
  }

  /// Initialiser Firebase Analytics
  Future<void> _initializeAnalytics() async {
    try {
      _analytics = FirebaseAnalytics.instance;
      await _analytics!.setAnalyticsCollectionEnabled(true);

      // Configuration des propriétés par défaut (skip pour web)
      if (!kIsWeb) {
        try {
          await _analytics!.setDefaultEventParameters({
            'app_version': '1.0.0', // À remplacer par la vraie version
            'platform': defaultTargetPlatform.name,
          });
        } catch (e) {
          if (kDebugMode) {
            print(
                'Firebase: Analytics default parameters not supported on this platform');
          }
        }
      }

      if (kDebugMode) {
        print('Firebase: Analytics initialized ✓');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Firebase: Analytics initialization failed: $e');
      }
    }
  }

  /// Initialiser Firebase Crashlytics
  Future<void> _initializeCrashlytics() async {
    // Crashlytics n'est pas supporté sur web
    if (kIsWeb) {
      if (kDebugMode) {
        print('Firebase: Crashlytics skipped (not supported on web)');
      }
      return;
    }

    try {
      _crashlytics = FirebaseCrashlytics.instance;

      // Activer la collecte automatique en production uniquement
      await _crashlytics!.setCrashlyticsCollectionEnabled(!kDebugMode);

      // Configurer l'utilisateur (sera mis à jour lors de la connexion)
      await _crashlytics!.setUserIdentifier('anonymous');

      if (kDebugMode) {
        print('Firebase: Crashlytics initialized ✓');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Firebase: Crashlytics initialization failed: $e');
      }
    }
  }

  /// Initialiser Firebase Performance
  Future<void> _initializePerformance() async {
    try {
      _performance = FirebasePerformance.instance;

      // Activer la collecte automatique
      await _performance!.setPerformanceCollectionEnabled(true);

      if (kDebugMode) {
        print('Firebase: Performance initialized ✓');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Firebase: Performance initialization failed: $e');
      }
    }
  }

  /// Initialiser Firebase Remote Config
  Future<void> _initializeRemoteConfig() async {
    try {
      _remoteConfig = FirebaseRemoteConfig.instance;

      // Configuration par défaut
      await _remoteConfig!.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      // Valeurs par défaut
      await _remoteConfig!.setDefaults({
        'welcome_message': 'Bienvenue dans MultiSales!',
        'min_app_version': '1.0.0',
        'maintenance_mode': false,
        'feature_new_onboarding': true,
        'support_email': 'support@multisales.com',
      });

      // Fetch initial
      await _remoteConfig!.fetchAndActivate();

      if (kDebugMode) {
        print('Firebase: Remote Config initialized ✓');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Firebase: Remote Config initialization failed: $e');
      }
    }
  }

  /// Initialiser Firebase Cloud Messaging
  Future<void> _initializeMessaging() async {
    try {
      _messaging = FirebaseMessaging.instance;

      // Demander la permission pour les notifications
      NotificationSettings settings = await _messaging!.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        if (kDebugMode) {
          print('Firebase: Messaging permissions granted ✓');
        }

        // Obtenir le token FCM (peut échouer sur web sans service worker)
        try {
          String? token = await _messaging!.getToken();
          if (kDebugMode) {
            if (kDebugMode) {
              print(
                token != null
                    ? 'Firebase: FCM Token obtained (${token.substring(0, 20)}...)'
                    : 'Firebase: FCM Token is null');
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('Firebase: FCM token unavailable (service worker issue): $e');
          }
        }

        // Configurer les handlers de messages
        await _configureMessagingHandlers();
      }

      if (kDebugMode) {
        print('Firebase: Messaging initialized ✓');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Firebase: Messaging initialization failed: $e');
      }
    }
  }

  /// Initialiser Firebase App Check
  Future<void> _initializeAppCheck() async {
    try {
      await FirebaseAppCheck.instance.activate(
        webProvider: ReCaptchaV3Provider('your-recaptcha-site-key'),
        androidProvider: AndroidProvider.debug, // À changer en production
      );

      if (kDebugMode) {
        print('Firebase: App Check initialized ✓');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Firebase: App Check initialization failed: $e');
      }
    }
  }

  /// Configurer Firestore
  Future<void> _configureFirestore() async {
    try {
      // Configurer les paramètres avec la nouvelle API
      _firestore!.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      if (kDebugMode) {
        print('Firebase: Firestore configured ✓');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Firebase: Firestore configuration failed: $e');
      }
    }
  }

  /// Configurer les handlers de messages
  Future<void> _configureMessagingHandlers() async {
    // Handler pour les messages en foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print(
            'Firebase: Message received in foreground: ${message.notification?.title}');
      }

      // Log analytics
      analytics.logEvent(
        name: 'notification_received',
        parameters: {
          'message_id': message.messageId ?? 'unknown',
          'title': message.notification?.title ?? 'no_title',
        },
      );
    });

    // Handler pour les messages en background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Firebase: Message opened app: ${message.notification?.title}');
      }

      // Log analytics
      analytics.logEvent(
        name: 'notification_opened',
        parameters: {
          'message_id': message.messageId ?? 'unknown',
          'title': message.notification?.title ?? 'no_title',
        },
      );
    });
  }

  /// Obtenir la liste des services activés
  String _getEnabledServices() {
    List<String> services = [];
    if (_auth != null) services.add('auth');
    if (_firestore != null) services.add('firestore');
    if (_storage != null) services.add('storage');
    if (_analytics != null) services.add('analytics');
    if (_crashlytics != null) services.add('crashlytics');
    if (_performance != null) services.add('performance');
    if (_remoteConfig != null) services.add('remote_config');
    if (_messaging != null) services.add('messaging');
    return services.join(',');
  }

  /// Méthodes utilitaires publiques

  /// Créer une trace de performance personnalisée
  Future<Trace> createTrace(String name) async {
    final trace = performance.newTrace(name);
    await trace.start();
    return trace;
  }

  /// Log un crash personnalisé
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    bool fatal = false,
    Map<String, dynamic>? customKeys,
  }) async {
    if (_crashlytics != null) {
      // Ajouter des clés personnalisées
      if (customKeys != null) {
        for (final entry in customKeys.entries) {
          await _crashlytics!.setCustomKey(entry.key, entry.value);
        }
      }

      await _crashlytics!.recordError(error, stackTrace, fatal: fatal);
    }
  }

  /// Obtenir une valeur de Remote Config
  T getRemoteConfigValue<T>(String key, T defaultValue) {
    if (_remoteConfig == null) return defaultValue;

    try {
      final value = _remoteConfig!.getValue(key);
      if (T == String) {
        return value.asString() as T;
      } else if (T == bool) {
        return value.asBool() as T;
      } else if (T == int) {
        return value.asInt() as T;
      } else if (T == double) {
        return value.asDouble() as T;
      } else {
        return defaultValue;
      }
    } catch (e) {
      return defaultValue;
    }
  }

  /// Mettre à jour les informations utilisateur pour Crashlytics
  Future<void> setUserInfo({
    required String userId,
    String? email,
    String? name,
  }) async {
    if (_crashlytics != null) {
      await _crashlytics!.setUserIdentifier(userId);
      if (email != null) {
        await _crashlytics!.setCustomKey('user_email', email);
      }
      if (name != null) {
        await _crashlytics!.setCustomKey('user_name', name);
      }
    }
  }

  /// Obtenir le token FCM
  Future<String?> getMessagingToken() async {
    return await _messaging?.getToken();
  }

  /// S'abonner à un topic de notification
  Future<void> subscribeToTopic(String topic) async {
    await _messaging?.subscribeToTopic(topic);
  }

  /// Se désabonner d'un topic de notification
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging?.unsubscribeFromTopic(topic);
  }

  /// Forcer un refresh de Remote Config
  Future<bool> refreshRemoteConfig() async {
    if (_remoteConfig == null) return false;

    try {
      return await _remoteConfig!.fetchAndActivate();
    } catch (e) {
      return false;
    }
  }
}
