import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService {
  static const String _languageKey = 'selected_language';
  static const String _countryKey = 'selected_country';

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English (United States)
    Locale('fr', 'FR'), // French (France)
    Locale('ar', 'SA'), // Arabic (Saudi Arabia)
    Locale('es', 'ES'), // Spanish (Spain)
    Locale('de', 'DE'), // German (Germany)
    Locale('it', 'IT'), // Italian (Italy)
    Locale('pt', 'BR'), // Portuguese (Brazil)
    Locale('zh', 'CN'), // Chinese (China)
    Locale('ja', 'JP'), // Japanese (Japan)
    Locale('ko', 'KR'), // Korean (South Korea)
  ];

  static const Locale fallbackLocale = Locale('en', 'US');

  // Get saved locale from SharedPreferences
  static Future<Locale> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey);
    final countryCode = prefs.getString(_countryKey);

    if (languageCode != null && countryCode != null) {
      final locale = Locale(languageCode, countryCode);
      if (supportedLocales.contains(locale)) {
        return locale;
      }
    }

    return fallbackLocale;
  }

  // Save locale to SharedPreferences
  static Future<bool> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
    await prefs.setString(_countryKey, locale.countryCode ?? '');
    return true;
  }

  // Get device locale if supported
  static Locale getDeviceLocale() {
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;

    // Check if device locale is directly supported
    if (supportedLocales.contains(deviceLocale)) {
      return deviceLocale;
    }

    // Check if language is supported with different country
    final supportedLanguage = supportedLocales.firstWhere(
      (locale) => locale.languageCode == deviceLocale.languageCode,
      orElse: () => fallbackLocale,
    );

    return supportedLanguage;
  }

  // Get language name for display
  static String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      case 'ar':
        return 'العربية';
      case 'es':
        return 'Español';
      case 'de':
        return 'Deutsch';
      case 'it':
        return 'Italiano';
      case 'pt':
        return 'Português';
      case 'zh':
        return '中文';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      default:
        return 'English';
    }
  }

  // Get country name for display
  static String getCountryName(Locale locale) {
    switch ('${locale.languageCode}_${locale.countryCode}') {
      case 'en_US':
        return 'United States';
      case 'fr_FR':
        return 'France';
      case 'ar_SA':
        return 'Saudi Arabia';
      case 'es_ES':
        return 'Spain';
      case 'de_DE':
        return 'Germany';
      case 'it_IT':
        return 'Italy';
      case 'pt_BR':
        return 'Brazil';
      case 'zh_CN':
        return 'China';
      case 'ja_JP':
        return 'Japan';
      case 'ko_KR':
        return 'South Korea';
      default:
        return 'United States';
    }
  }

  // Get full display name (Language - Country)
  static String getFullDisplayName(Locale locale) {
    return '${getLanguageName(locale)} - ${getCountryName(locale)}';
  }

  // Check if locale is RTL (Right-to-Left)
  static bool isRTL(Locale locale) {
    return locale.languageCode == 'ar' ||
        locale.languageCode == 'he' ||
        locale.languageCode == 'fa' ||
        locale.languageCode == 'ur';
  }

  // Get text direction for locale
  static TextDirection getTextDirection(Locale locale) {
    return isRTL(locale) ? TextDirection.rtl : TextDirection.ltr;
  }

  // Get locale by language code
  static Locale? getLocaleByLanguageCode(String languageCode) {
    try {
      return supportedLocales.firstWhere(
        (locale) => locale.languageCode == languageCode,
      );
    } catch (e) {
      return null;
    }
  }

  // Format currency for locale
  static String formatCurrency(double amount, Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return '\$${amount.toStringAsFixed(2)}';
      case 'fr':
        return '${amount.toStringAsFixed(2)} €';
      case 'ar':
        return '${amount.toStringAsFixed(2)} ر.س';
      case 'es':
        return '${amount.toStringAsFixed(2)} €';
      case 'de':
        return '${amount.toStringAsFixed(2)} €';
      case 'it':
        return '${amount.toStringAsFixed(2)} €';
      case 'pt':
        return 'R\$ ${amount.toStringAsFixed(2)}';
      case 'zh':
        return '¥${amount.toStringAsFixed(2)}';
      case 'ja':
        return '¥${amount.toStringAsFixed(0)}';
      case 'ko':
        return '₩${amount.toStringAsFixed(0)}';
      default:
        return '\$${amount.toStringAsFixed(2)}';
    }
  }

  // Format date for locale
  static String formatDate(DateTime date, Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return '${date.month}/${date.day}/${date.year}';
      case 'fr':
      case 'de':
      case 'it':
      case 'es':
        return '${date.day}/${date.month}/${date.year}';
      case 'ar':
        return '${date.day}/${date.month}/${date.year}';
      case 'pt':
        return '${date.day}/${date.month}/${date.year}';
      case 'zh':
      case 'ja':
      case 'ko':
        return '${date.year}/${date.month}/${date.day}';
      default:
        return '${date.month}/${date.day}/${date.year}';
    }
  }

  // Get number format for locale
  static String formatNumber(double number, Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return number.toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]},',
            );
      case 'fr':
      case 'de':
      case 'it':
      case 'es':
      case 'pt':
        return number.toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]}.',
            );
      case 'ar':
        return number.toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]}،',
            );
      default:
        return number.toString();
    }
  }

  // Translate common terms
  static Map<String, Map<String, String>> commonTranslations = {
    'hello': {
      'en': 'Hello',
      'fr': 'Bonjour',
      'ar': 'مرحبا',
      'es': 'Hola',
      'de': 'Hallo',
      'it': 'Ciao',
      'pt': 'Olá',
      'zh': '你好',
      'ja': 'こんにちは',
      'ko': '안녕하세요',
    },
    'welcome': {
      'en': 'Welcome',
      'fr': 'Bienvenue',
      'ar': 'مرحبا بك',
      'es': 'Bienvenido',
      'de': 'Willkommen',
      'it': 'Benvenuto',
      'pt': 'Bem-vindo',
      'zh': '欢迎',
      'ja': 'ようこそ',
      'ko': '환영합니다',
    },
    'loading': {
      'en': 'Loading...',
      'fr': 'Chargement...',
      'ar': 'جاري التحميل...',
      'es': 'Cargando...',
      'de': 'Wird geladen...',
      'it': 'Caricamento...',
      'pt': 'Carregando...',
      'zh': '加载中...',
      'ja': '読み込み中...',
      'ko': '로딩 중...',
    },
    'error': {
      'en': 'Error',
      'fr': 'Erreur',
      'ar': 'خطأ',
      'es': 'Error',
      'de': 'Fehler',
      'it': 'Errore',
      'pt': 'Erro',
      'zh': '错误',
      'ja': 'エラー',
      'ko': '오류',
    },
    'success': {
      'en': 'Success',
      'fr': 'Succès',
      'ar': 'نجح',
      'es': 'Éxito',
      'de': 'Erfolg',
      'it': 'Successo',
      'pt': 'Sucesso',
      'zh': '成功',
      'ja': '成功',
      'ko': '성공',
    },
  };

  // Get translated text
  static String translate(String key, Locale locale) {
    final translations = commonTranslations[key];
    if (translations == null) return key;

    return translations[locale.languageCode] ?? translations['en'] ?? key;
  }
}
