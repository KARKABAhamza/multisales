class AppConstants {
  // App Information
  static const String appName = 'MultiSales Onboarding';
  static const String appVersion = '1.0.0';
  static const String companyName = 'MultiSales Maroc';

  // Firebase Configuration
  static const String firebaseProjectId = 'multisales-18e57';
  static const String firebaseProjectNumber = '967872205422';
  static const String firebaseStorageBucket = 'multisales-18e57.appspot.com';
  static const String firebaseWebApiKey =
      'AIzaSyBz4EfU40riAMXt3sdKFFFq5Lc_X5W6WGQ';

  // User Roles
  static const String roleSales = 'sales';
  static const String roleSupport = 'support';
  static const String roleTechnician = 'technician';
  static const String roleManager = 'manager';

  // Onboarding Step IDs
  static const String stepWelcome = 'welcome';
  static const String stepRoleSelection = 'role_selection';
  static const String stepProfileSetup = 'profile_setup';
  static const String stepSalesIntro = 'sales_intro';
  static const String stepProductCatalog = 'product_catalog';
  static const String stepSalesTechniques = 'sales_techniques';
  static const String stepSupportIntro = 'support_intro';
  static const String stepTroubleshooting = 'troubleshooting';
  static const String collectionOnboardingProgress = 'onboarding_progress';
  static const String collectionTrainingModules = 'training_modules';
  static const String collectionCompanyData = 'company_data';
  static const String collectionProducts = 'products';
  static const String storageProfileImages = 'profile_images';
  static const String storageTrainingVideos = 'training_videos';
  static const String storageDocuments = 'documents';

  // Validation Rules
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;

  // Language Codes
  static const String languageEnglish = 'en';
  static const String languageFrench = 'fr';
  static const String languageArabic = 'ar';
  static const String languageSpanish = 'es';
  static const String languageGerman = 'de';

  // Default Values
  static const String defaultRole = roleSales;
  static const String defaultLanguage = languageEnglish;

  // Asset Paths
  static const String logoPath = 'assets/images/multisales_logo.jpg';

  // UI Constants
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXLarge = 16.0;

  // SharedPreferences Keys
  static const String prefKeyLanguage = 'selected_language';
  static const String prefKeyTheme = 'selected_theme';
  static const String prefKeyFirstTime = 'is_first_time';
  static const String prefKeyOnboardingComplete = 'onboarding_complete';
}

class AppMessages {
  // Error Messages
  static const String errorGeneral =
      'An unexpected error occurred. Please try again.';
  static const String errorNetwork =
      'Please check your internet connection and try again.';

  // Success Messages
  static const String successAccountCreated =
      'Account created successfully! Welcome to MultiSales.';
  static const String successProfileUpdated = 'Profile updated successfully.';
  static const String successOnboardingComplete =
      'Congratulations! You have completed your onboarding.';
  static const String successTrainingComplete =
      'Training module completed successfully.';
  static const String successPasswordReset =
      'Password reset email sent. Please check your inbox.';

  // Loading Messages
  static const String loadingSigningIn = 'Signing you in...';
  static const String loadingCreatingAccount = 'Creating your account...';
  static const String loadingProfileSetup = 'Setting up your profile...';
  static const String loadingTrainingData = 'Loading training content...';
  static const String loadingOnboardingData = 'Loading onboarding steps...';

  // Navigation Messages
  static const String navContinue = 'Continue';
  static const String navNext = 'Next';
  static const String navPrevious = 'Previous';
  static const String navSkip = 'Skip';
  static const String navFinish = 'Finish';
  static const String navGetStarted = 'Get Started';
  static const String navBackToLogin = 'Back to Login';
  static const String navGoHome = 'Go to Home';

  // Form Labels
  static const String labelEmail = 'Email Address';
  static const String labelFirstName = 'First Name';
  static const String labelLastName = 'Last Name';
  static const String labelPhoneNumber = 'Phone Number';
  static const String labelRole = 'Your Role';
  static const String labelDepartment = 'Department';
  static const String labelExperience = 'Years of Experience';

  // Training Categories
  static const String categorySalesSkills = 'Sales Skills';
  static const String categoryProductKnowledge = 'Product Knowledge';
  static const String categoryCustomerService = 'Customer Service';
  static const String categoryTechnicalSkills = 'Technical Skills';
  static const String categoryCompanyPolicies = 'Company Policies';

  // Product Messages
  static const String productAdded = 'Product added successfully!';
  static const String productUpdated = 'Product updated successfully!';
  static const String productDeleted = 'Product deleted successfully!';
}
