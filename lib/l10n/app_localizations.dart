import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ar.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('ar'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'MultiSales Auth'**
  String get appTitle;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sign in successful!'**
  String get signInSuccess;

  /// No description provided for @signUpSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sign up successful!'**
  String get signUpSuccess;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'John'**
  String get firstNameHint;

  /// No description provided for @firstNameInput.
  ///
  /// In en, this message translates to:
  /// **'First name input field'**
  String get firstNameInput;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Doe'**
  String get lastNameHint;

  /// No description provided for @lastNameInput.
  ///
  /// In en, this message translates to:
  /// **'Last name input field'**
  String get lastNameInput;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'john.doe@example.com'**
  String get emailHint;

  /// No description provided for @emailSignUpInput.
  ///
  /// In en, this message translates to:
  /// **'Email address input field for sign up'**
  String get emailSignUpInput;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'+1 234 567 8900'**
  String get phoneHint;

  /// No description provided for @phoneInput.
  ///
  /// In en, this message translates to:
  /// **'Phone number input field'**
  String get phoneInput;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @createPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a strong password'**
  String get createPasswordHint;

  /// No description provided for @createPasswordInput.
  ///
  /// In en, this message translates to:
  /// **'Create password field'**
  String get createPasswordInput;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get confirmPasswordHint;

  /// No description provided for @confirmPasswordInput.
  ///
  /// In en, this message translates to:
  /// **'Confirm password field'**
  String get confirmPasswordInput;

  /// No description provided for @facebookSignUpNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Facebook (OAuth2) sign-up is not yet implemented.'**
  String get facebookSignUpNotImplemented;

  /// No description provided for @appleSignUpNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Apple (OAuth2) sign-up is not yet implemented.'**
  String get appleSignUpNotImplemented;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create account button'**
  String get createAccountButton;

  /// No description provided for @createAccountTooltip.
  ///
  /// In en, this message translates to:
  /// **'Create your new account'**
  String get createAccountTooltip;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterValidEmail;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @nameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Must be at least 2 characters'**
  String get nameMinLength;

  /// No description provided for @pleaseEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhone;

  /// No description provided for @pleaseEnterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterValidPhone;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Password reset success message
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent!'**
  String get passwordResetSent;

  /// Welcome headline on dashboard
  ///
  /// In en, this message translates to:
  /// **'Welcome to MultiSales!'**
  String get welcomeToMultiSales;

  /// Welcome sub-message on dashboard
  ///
  /// In en, this message translates to:
  /// **"Here's what's happening with your business today."**
  String get welcomeMessage;

  /// Support/notifications banner description
  ///
  /// In en, this message translates to:
  /// **'You have new updates!'**
  String get supportDesc;

  /// Section title: Testimonials & References
  String get testimonialsAndReferences;

  /// Subtitle: Customer reviews, case studies, videos or quotes.
  String get testimonialsSubtitle;

  /// Section title: They trust us
  String get theyTrustUs;

  /// Action label: Read case study
  String get readCaseStudy;

  /// Appointments title used in calendar screen
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// Calendar settings label
  ///
  /// In en, this message translates to:
  /// **'Calendar Settings'**
  String get calendarSettings;

  /// Sync calendar label
  ///
  /// In en, this message translates to:
  /// **'Sync Calendar'**
  String get syncCalendar;

  // Home / Navigation
  String get brandName;
  String get menuHome;
  String get menuExpertise;
  String get menuServices;
  String get menuAbout;
  String get menuContact;
  String get menuLogin;

  /// Section title for the logos/products grid
  String get sectionWhatWeSell;

  /// Short intro line above the logos grid
  String get whatWeSellIntro;

  /// Button label to close dialog
  String get closeLabel;

  /// Accessibility label or title for preview dialog
  String get previewTitle;

  /// No description provided for @offlineNotice.
  ///
  /// In en, this message translates to:
  /// **'You are offline. Some features may be unavailable.'**
  String get offlineNotice;

  // Marketing content keys
  String get heroTagline; // Short banner/tagline under brand
  String get heroAccroche; // 1–2 short sentences hook

  // About page paragraphs
  String get aboutP1;
  String get aboutP2;
  String get aboutP3;
  String get aboutP4;

  // Services intro (short paragraph)
  String get servicesIntroShort;

  // Services bullets (grid items)
  String get svcSourcing;
  String get svcIndustrialSupplies;
  String get svcHotelSupplies;
  String get svcConsumables;
  String get svcEPI;
  String get svcLogistics;
  String get svcContracts;

  // Benefits list
  String get benLeadTime;
  String get benPrice;
  String get benCompliance;
  String get benTraceability;
  String get benSupport;
  String get benFlexibility;

  // CTAs
  String get ctaRequestQuotePersonalized;
  String get ctaReassortExpress;
  String get ctaContactPurchasing;
  String get ctaDownloadBrochure;

  // Contact sales CTA text block
  String get contactSalesCta;

  // SEO
  String get metaDescription;

  // Hero section
  String get heroTitle;
  String get heroSubtitle;
  String get ctaQuote;
  String get ctaOurExpertise;
  String get heroLine1;
  String get heroLine2;
  String get heroLine3;

  // Our expertise
  String get sectionOurExpertiseTitle;
  String get expertiseVoice;
  String get expertiseAutomatism;
  String get expertiseData;
  String get expertiseVideo;

  // Why choose us
  String get sectionWhyChooseUsTitle;
  String get whyPoint1;
  String get whyPoint2;
  String get whyPoint3;
  String get whyPoint4;

  // Featured services
  String get sectionFeaturedServicesTitle;
  String get featuredService1;
  String get featuredService2;
  String get featuredService3;
  String get featuredService4;

  // Final CTA
  String get finalCtaTitle;
  String get finalCtaSubtitle;
  String get finalCtaContact;

  // Footer
  String get footerCompanyCasablanca;
  String get footerAddress;
  String get footerContact;
  String get footerRightsReserved;

  // Common CTAs
  String get learnMore;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr', 'ar'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'ar':
      return AppLocalizationsAr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
