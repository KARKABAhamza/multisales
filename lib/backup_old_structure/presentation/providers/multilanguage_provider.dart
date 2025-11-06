import 'package:flutter/material.dart';

/// Enhanced Multi-Language Provider for MultiSales Client App
/// Handles comprehensive localization for Morocco market (Arabic, French, English)
class MultiLanguageProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  // Current Language Settings
  Locale _currentLocale = const Locale('fr', 'MA'); // Default to French Morocco
  String _currentLanguageCode = 'fr';
  String _currentCountryCode = 'MA';
  bool _isRTL = false;

  // Language Preferences
  List<Map<String, dynamic>> _availableLanguages = [];
  List<Map<String, dynamic>> _recentLanguages = [];
  Map<String, dynamic>? _languagePreferences;

  // Translation Data
  Map<String, Map<String, String>> _translations = {};
  Map<String, dynamic>? _languageMetadata;

  // Regional Settings
  Map<String, dynamic>? _regionalSettings;
  String _dateFormat = 'dd/MM/yyyy';
  String _timeFormat = '24h';
  final String _numberFormat = 'european';
  String _currency = 'MAD';
  String _currencySymbol = 'DH';

  // Text Input Settings
  TextDirection _textDirection = TextDirection.ltr;
  bool _enableAutoTranslate = false;
  bool _showTransliterations = false;
  String _keyboardLayout = 'qwerty';

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Locale get currentLocale => _currentLocale;
  String get currentLanguageCode => _currentLanguageCode;
  String get currentCountryCode => _currentCountryCode;
  bool get isRTL => _isRTL;
  List<Map<String, dynamic>> get availableLanguages => _availableLanguages;
  List<Map<String, dynamic>> get recentLanguages => _recentLanguages;
  Map<String, dynamic>? get languagePreferences => _languagePreferences;
  Map<String, Map<String, String>> get translations => _translations;
  Map<String, dynamic>? get languageMetadata => _languageMetadata;
  Map<String, dynamic>? get regionalSettings => _regionalSettings;
  String get dateFormat => _dateFormat;
  String get timeFormat => _timeFormat;
  String get numberFormat => _numberFormat;
  String get currency => _currency;
  String get currencySymbol => _currencySymbol;
  TextDirection get textDirection => _textDirection;
  bool get enableAutoTranslate => _enableAutoTranslate;
  bool get showTransliterations => _showTransliterations;
  String get keyboardLayout => _keyboardLayout;

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

  // Initialize Multi-Language System
  Future<bool> initializeLanguageSystem() async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      await Future.wait([
        _loadAvailableLanguages(),
        _loadTranslations(),
        _loadLanguagePreferences(),
        _loadRegionalSettings(),
        _loadLanguageMetadata(),
      ]);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to initialize language system: $e');
      _setLoading(false);
      return false;
    }
  }

  // Load Available Languages
  Future<bool> _loadAvailableLanguages() async {
    try {
      _availableLanguages = [
        {
          'code': 'ar',
          'name': 'العربية',
          'nativeName': 'العربية',
          'englishName': 'Arabic',
          'countryCode': 'MA',
          'flag': '🇲🇦',
          'isRTL': true,
          'isDefault': false,
          'isEnabled': true,
          'completionPercentage': 95.0,
          'lastUpdate': DateTime.now()
              .subtract(const Duration(days: 2))
              .toIso8601String(),
          'localizedNames': {
            'ar': 'العربية',
            'fr': 'Arabe',
            'en': 'Arabic',
          },
          'region': 'Morocco',
          'script': 'Arab',
          'speakers': 32000000, // Morocco Arabic speakers
        },
        {
          'code': 'fr',
          'name': 'Français',
          'nativeName': 'Français',
          'englishName': 'French',
          'countryCode': 'MA',
          'flag': '🇲🇦',
          'isRTL': false,
          'isDefault': true,
          'isEnabled': true,
          'completionPercentage': 100.0,
          'lastUpdate': DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
          'localizedNames': {
            'ar': 'الفرنسية',
            'fr': 'Français',
            'en': 'French',
          },
          'region': 'Morocco',
          'script': 'Latn',
          'speakers': 13000000, // Morocco French speakers
        },
        {
          'code': 'en',
          'name': 'English',
          'nativeName': 'English',
          'englishName': 'English',
          'countryCode': 'MA',
          'flag': '🇺🇸',
          'isRTL': false,
          'isDefault': false,
          'isEnabled': true,
          'completionPercentage': 98.0,
          'lastUpdate': DateTime.now()
              .subtract(const Duration(days: 3))
              .toIso8601String(),
          'localizedNames': {
            'ar': 'الإنجليزية',
            'fr': 'Anglais',
            'en': 'English',
          },
          'region': 'International',
          'script': 'Latn',
          'speakers': 1500000000, // Global English speakers
        },
        {
          'code': 'es',
          'name': 'Español',
          'nativeName': 'Español',
          'englishName': 'Spanish',
          'countryCode': 'ES',
          'flag': '🇪🇸',
          'isRTL': false,
          'isDefault': false,
          'isEnabled': false, // Coming soon
          'completionPercentage': 75.0,
          'lastUpdate': DateTime.now()
              .subtract(const Duration(days: 10))
              .toIso8601String(),
          'localizedNames': {
            'ar': 'الإسبانية',
            'fr': 'Espagnol',
            'en': 'Spanish',
          },
          'region': 'Spain/Latin America',
          'script': 'Latn',
          'speakers': 500000000,
        },
        {
          'code': 'de',
          'name': 'Deutsch',
          'nativeName': 'Deutsch',
          'englishName': 'German',
          'countryCode': 'DE',
          'flag': '🇩🇪',
          'isRTL': false,
          'isDefault': false,
          'isEnabled': false, // Coming soon
          'completionPercentage': 70.0,
          'lastUpdate': DateTime.now()
              .subtract(const Duration(days: 15))
              .toIso8601String(),
          'localizedNames': {
            'ar': 'الألمانية',
            'fr': 'Allemand',
            'en': 'German',
          },
          'region': 'Germany/Austria/Switzerland',
          'script': 'Latn',
          'speakers': 100000000,
        },
      ];

      // Recent languages (last used)
      _recentLanguages = [
        _availableLanguages.firstWhere((lang) => lang['code'] == 'fr'),
        _availableLanguages.firstWhere((lang) => lang['code'] == 'ar'),
        _availableLanguages.firstWhere((lang) => lang['code'] == 'en'),
      ];

      return true;
    } catch (e) {
      _setError('Failed to load available languages: $e');
      return false;
    }
  }

  // Load Translations
  Future<bool> _loadTranslations() async {
    try {
      // Core translations for key app features
      _translations = {
        'ar': {
          // Authentication
          'login': 'تسجيل الدخول',
          'logout': 'تسجيل الخروج',
          'register': 'إنشاء حساب',
          'forgot_password': 'نسيت كلمة المرور',
          'email': 'البريد الإلكتروني',
          'password': 'كلمة المرور',
          'confirm_password': 'تأكيد كلمة المرور',

          // Navigation
          'home': 'الرئيسية',
          'services': 'الخدمات',
          'appointments': 'المواعيد',
          'support': 'الدعم',
          'profile': 'الملف الشخصي',
          'settings': 'الإعدادات',

          // Common actions
          'save': 'حفظ',
          'cancel': 'إلغاء',
          'delete': 'حذف',
          'edit': 'تعديل',
          'view': 'عرض',
          'search': 'بحث',
          'filter': 'تصفية',
          'refresh': 'تحديث',
          'loading': 'جارٍ التحميل...',
          'error': 'خطأ',
          'success': 'نجح',
          'warning': 'تحذير',
          'info': 'معلومات',

          // MultiSales specific
          'multisales': 'مولتيسايلز',
          'mobile_services': 'خدمات الموبايل',
          'internet_services': 'خدمات الإنترنت',
          'technical_support': 'الدعم التقني',
          'bill_payment': 'دفع الفواتير',
          'service_request': 'طلب خدمة',
          'agency_locator': 'محدد الوكالات',
        },
        'fr': {
          // Authentication
          'login': 'Connexion',
          'logout': 'Déconnexion',
          'register': 'Créer un compte',
          'forgot_password': 'Mot de passe oublié',
          'email': 'Email',
          'password': 'Mot de passe',
          'confirm_password': 'Confirmer le mot de passe',

          // Navigation
          'home': 'Accueil',
          'services': 'Services',
          'appointments': 'Rendez-vous',
          'support': 'Support',
          'profile': 'Profil',
          'settings': 'Paramètres',

          // Common actions
          'save': 'Enregistrer',
          'cancel': 'Annuler',
          'delete': 'Supprimer',
          'edit': 'Modifier',
          'view': 'Voir',
          'search': 'Rechercher',
          'filter': 'Filtrer',
          'refresh': 'Actualiser',
          'loading': 'Chargement...',
          'error': 'Erreur',
          'success': 'Succès',
          'warning': 'Avertissement',
          'info': 'Information',

          // MultiSales specific
          'multisales': 'MultiSales',
          'mobile_services': 'Services Mobiles',
          'internet_services': 'Services Internet',
          'technical_support': 'Support Technique',
          'bill_payment': 'Paiement de Factures',
          'service_request': 'Demande de Service',
          'agency_locator': 'Localisateur d\'Agences',
        },
        'en': {
          // Authentication
          'login': 'Login',
          'logout': 'Logout',
          'register': 'Create Account',
          'forgot_password': 'Forgot Password',
          'email': 'Email',
          'password': 'Password',
          'confirm_password': 'Confirm Password',

          // Navigation
          'home': 'Home',
          'services': 'Services',
          'appointments': 'Appointments',
          'support': 'Support',
          'profile': 'Profile',
          'settings': 'Settings',

          // Common actions
          'save': 'Save',
          'cancel': 'Cancel',
          'delete': 'Delete',
          'edit': 'Edit',
          'view': 'View',
          'search': 'Search',
          'filter': 'Filter',
          'refresh': 'Refresh',
          'loading': 'Loading...',
          'error': 'Error',
          'success': 'Success',
          'warning': 'Warning',
          'info': 'Information',

          // MultiSales specific
          'multisales': 'MultiSales',
          'mobile_services': 'Mobile Services',
          'internet_services': 'Internet Services',
          'technical_support': 'Technical Support',
          'bill_payment': 'Bill Payment',
          'service_request': 'Service Request',
          'agency_locator': 'Agency Locator',
        },
      };

      return true;
    } catch (e) {
      _setError('Failed to load translations: $e');
      return false;
    }
  }

  // Load Language Preferences
  Future<bool> _loadLanguagePreferences() async {
    try {
      _languagePreferences = {
        'autoDetect': false,
        'fallbackLanguage': 'fr',
        'cacheTranslations': true,
        'downloadOfflineTranslations': true,
        'showNativeNames': true,
        'enableTransliteration': false,
        'voiceLanguage': 'fr',
        'keyboardAutoSwitch': true,
        'contentLanguagePreference': 'same_as_ui',
        'translateNotifications': true,
        'regionalFormat': 'morocco',
        'lastUsedLanguages': ['fr', 'ar', 'en'],
        'languageUsageStats': {
          'fr': {'usageCount': 245, 'totalTime': 3600000}, // milliseconds
          'ar': {'usageCount': 120, 'totalTime': 1800000},
          'en': {'usageCount': 85, 'totalTime': 1200000},
        },
      };

      return true;
    } catch (e) {
      _setError('Failed to load language preferences: $e');
      return false;
    }
  }

  // Load Regional Settings
  Future<bool> _loadRegionalSettings() async {
    try {
      _regionalSettings = {
        'country': 'Morocco',
        'countryCode': 'MA',
        'region': 'North Africa',
        'timezone': 'Africa/Casablanca',
        'calendar': 'gregorian',
        'weekStart': 'monday',
        'dateFormat': 'dd/MM/yyyy',
        'timeFormat': '24h',
        'numberFormat': {
          'decimal': ',',
          'thousands': ' ',
          'pattern': '#,##0.##',
        },
        'currency': {
          'code': 'MAD',
          'symbol': 'DH',
          'name': 'Moroccan Dirham',
          'position': 'after', // before/after number
        },
        'units': {
          'temperature': 'celsius',
          'distance': 'metric',
          'weight': 'metric',
        },
        'phoneFormat': '+212 6XX XX XX XX',
        'addressFormat': {
          'order': ['street', 'city', 'postalCode', 'country'],
          'postalCodePattern': '[0-9]{5}',
        },
      };

      // Apply regional settings
      _currency = _regionalSettings!['currency']['code'];
      _currencySymbol = _regionalSettings!['currency']['symbol'];
      _dateFormat = _regionalSettings!['dateFormat'];
      _timeFormat = _regionalSettings!['timeFormat'];

      return true;
    } catch (e) {
      _setError('Failed to load regional settings: $e');
      return false;
    }
  }

  // Load Language Metadata
  Future<bool> _loadLanguageMetadata() async {
    try {
      _languageMetadata = {
        'supportedFeatures': {
          'textToSpeech': ['ar', 'fr', 'en'],
          'speechToText': ['ar', 'fr', 'en'],
          'translation': ['ar', 'fr', 'en'],
          'transliteration': ['ar'],
          'spellCheck': ['fr', 'en'],
          'autocomplete': ['ar', 'fr', 'en'],
        },
        'fontSupport': {
          'ar': ['Noto Sans Arabic', 'Cairo', 'Amiri'],
          'fr': ['Roboto', 'Open Sans', 'Lato'],
          'en': ['Roboto', 'Open Sans', 'Lato'],
        },
        'keyboardLayouts': {
          'ar': ['arabic', 'arabic-pc'],
          'fr': ['azerty', 'qwerty'],
          'en': ['qwerty', 'dvorak'],
        },
        'contentDirection': {
          'ar': 'rtl',
          'fr': 'ltr',
          'en': 'ltr',
        },
        'pluralizationRules': {
          'ar': 'arabic', // 0, 1, 2, 3-10, 11-99, 100+
          'fr': 'french', // 0-1, 2+
          'en': 'english', // 1, other
        },
      };

      return true;
    } catch (e) {
      _setError('Failed to load language metadata: $e');
      return false;
    }
  }

  // Change Language
  Future<bool> changeLanguage(String languageCode) async {
    _setLoading(true);
    _setError(null);

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      final language = _availableLanguages.firstWhere(
        (lang) => lang['code'] == languageCode,
        orElse: () => {},
      );

      if (language.isEmpty) {
        _setError('Language not supported');
        _setLoading(false);
        return false;
      }

      if (!language['isEnabled']) {
        _setError('Language is not yet available');
        _setLoading(false);
        return false;
      }

      // Update current language
      _currentLanguageCode = languageCode;
      _currentCountryCode = language['countryCode'];
      _currentLocale = Locale(languageCode, language['countryCode']);
      _isRTL = language['isRTL'];
      _textDirection = _isRTL ? TextDirection.rtl : TextDirection.ltr;

      // Update recent languages
      _recentLanguages.removeWhere((lang) => lang['code'] == languageCode);
      _recentLanguages.insert(0, language);
      if (_recentLanguages.length > 5) {
        _recentLanguages.removeRange(5, _recentLanguages.length);
      }

      // Update usage stats
      if (_languagePreferences != null) {
        final stats =
            _languagePreferences!['languageUsageStats'] as Map<String, dynamic>;
        if (stats.containsKey(languageCode)) {
          stats[languageCode]['usageCount']++;
        } else {
          stats[languageCode] = {'usageCount': 1, 'totalTime': 0};
        }
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to change language: $e');
      _setLoading(false);
      return false;
    }
  }

  // Get Translation
  String translate(String key, {String? languageCode}) {
    final langCode = languageCode ?? _currentLanguageCode;

    if (_translations.containsKey(langCode) &&
        _translations[langCode]!.containsKey(key)) {
      return _translations[langCode]![key]!;
    }

    // Try fallback language
    final fallback = _languagePreferences?['fallbackLanguage'] ?? 'fr';
    if (langCode != fallback &&
        _translations.containsKey(fallback) &&
        _translations[fallback]!.containsKey(key)) {
      return _translations[fallback]![key]!;
    }

    // Return key if no translation found
    return key;
  }

  // Get Localized Language Name
  String getLocalizedLanguageName(String languageCode) {
    final language = _availableLanguages.firstWhere(
      (lang) => lang['code'] == languageCode,
      orElse: () => {},
    );

    if (language.isEmpty) return languageCode;

    final localizedNames = language['localizedNames'] as Map<String, String>;
    return localizedNames[_currentLanguageCode] ?? language['nativeName'];
  }

  // Format Number
  String formatNumber(double number, {int? decimalPlaces}) {
    final decimals = decimalPlaces ?? 2;
    final formatted = number.toStringAsFixed(decimals);

    // Apply regional number formatting
    if (_regionalSettings != null) {
      final numberFormat = _regionalSettings!['numberFormat'];
      final decimal = numberFormat['decimal'];
      final thousands = numberFormat['thousands'];

      // Simple formatting - in production, use proper localization package
      final parts = formatted.split('.');
      String integerPart = parts[0];
      String decimalPart = parts.length > 1 ? parts[1] : '';

      // Add thousands separator
      if (integerPart.length > 3) {
        final buffer = StringBuffer();
        for (int i = 0; i < integerPart.length; i++) {
          if (i > 0 && (integerPart.length - i) % 3 == 0) {
            buffer.write(thousands);
          }
          buffer.write(integerPart[i]);
        }
        integerPart = buffer.toString();
      }

      if (decimalPart.isNotEmpty) {
        return '$integerPart$decimal$decimalPart';
      } else {
        return integerPart;
      }
    }

    return formatted;
  }

  // Format Currency
  String formatCurrency(double amount, {bool showSymbol = true}) {
    final formattedAmount = formatNumber(amount, decimalPlaces: 2);

    if (!showSymbol) return formattedAmount;

    if (_regionalSettings != null) {
      final currency = _regionalSettings!['currency'];
      final symbol = currency['symbol'];
      final position = currency['position'];

      if (position == 'before') {
        return '$symbol$formattedAmount';
      } else {
        return '$formattedAmount $symbol';
      }
    }

    return '$formattedAmount $_currencySymbol';
  }

  // Format Date
  String formatDate(DateTime date, {String? format}) {
    final dateFormat = format ?? _dateFormat;

    // Simple formatting - in production, use proper date formatting package
    switch (dateFormat) {
      case 'dd/MM/yyyy':
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      case 'MM/dd/yyyy':
        return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
      case 'yyyy-MM-dd':
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      default:
        return date.toString().split(' ')[0];
    }
  }

  // Get Enabled Languages
  List<Map<String, dynamic>> getEnabledLanguages() {
    return _availableLanguages.where((lang) => lang['isEnabled']).toList();
  }

  // Get Language Statistics
  Map<String, dynamic> getLanguageStatistics() {
    final stats = _languagePreferences?['languageUsageStats'] ?? {};
    final totalUsage = stats.values
        .fold<int>(0, (sum, lang) => sum + (lang['usageCount'] as int));

    return {
      'totalLanguages': _availableLanguages.length,
      'enabledLanguages': getEnabledLanguages().length,
      'currentLanguage': _currentLanguageCode,
      'totalUsage': totalUsage,
      'mostUsedLanguage': _getMostUsedLanguage(),
      'recentLanguages': _recentLanguages.map((lang) => lang['code']).toList(),
      'translationCompleteness': _getTranslationCompleteness(),
    };
  }

  // Get Most Used Language
  String _getMostUsedLanguage() {
    final stats = _languagePreferences?['languageUsageStats'] ?? {};
    String mostUsed = _currentLanguageCode;
    int maxUsage = 0;

    stats.forEach((lang, data) {
      final usage = data['usageCount'] as int;
      if (usage > maxUsage) {
        maxUsage = usage;
        mostUsed = lang;
      }
    });

    return mostUsed;
  }

  // Get Translation Completeness
  Map<String, double> _getTranslationCompleteness() {
    final completeness = <String, double>{};

    for (final language in _availableLanguages) {
      completeness[language['code']] =
          language['completionPercentage'].toDouble();
    }

    return completeness;
  }

  // Update Language Preferences
  Future<bool> updateLanguagePreferences(
      Map<String, dynamic> preferences) async {
    try {
      _languagePreferences = {..._languagePreferences!, ...preferences};
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update language preferences: $e');
      return false;
    }
  }

  // Enable Auto Translation
  void setAutoTranslate(bool enabled) {
    _enableAutoTranslate = enabled;
    notifyListeners();
  }

  // Enable Transliterations
  void setShowTransliterations(bool enabled) {
    _showTransliterations = enabled;
    notifyListeners();
  }

  // Set Keyboard Layout
  void setKeyboardLayout(String layout) {
    _keyboardLayout = layout;
    notifyListeners();
  }

  // Check if feature is supported for language
  bool isFeatureSupported(String feature, String languageCode) {
    if (_languageMetadata == null) return false;

    final supportedFeatures =
        _languageMetadata!['supportedFeatures'] as Map<String, dynamic>;
    if (!supportedFeatures.containsKey(feature)) return false;

    final supportedLanguages = supportedFeatures[feature] as List<dynamic>;
    return supportedLanguages.contains(languageCode);
  }

  // Get Supported Fonts for Language
  List<String> getSupportedFonts(String languageCode) {
    if (_languageMetadata == null) return [];

    final fontSupport =
        _languageMetadata!['fontSupport'] as Map<String, dynamic>;
    if (!fontSupport.containsKey(languageCode)) return [];

    return List<String>.from(fontSupport[languageCode]);
  }

  // Get Current Language Info
  Map<String, dynamic> getCurrentLanguageInfo() {
    return _availableLanguages.firstWhere(
      (lang) => lang['code'] == _currentLanguageCode,
      orElse: () => {},
    );
  }
}
