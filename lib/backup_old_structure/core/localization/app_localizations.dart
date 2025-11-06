import 'package:flutter/material.dart';

class AppLocalizations {
  String get appointments =>
      _localizedValues[locale.languageCode]?['appointments'] ?? 'Appointments';
  String get calendarSettings =>
      _localizedValues[locale.languageCode]?['calendar_settings'] ?? 'Calendar Settings Updated';
  String get syncCalendar =>
      _localizedValues[locale.languageCode]?['sync_calendar'] ?? 'Sync Calendar';
  // --- Removed duplicate 'error' getter ---
  String get orSignInWith =>
      _localizedValues[locale.languageCode]?['or_sign_in_with'] ??
      'or sign in with';
  String socialSignInNotImplemented(String provider) =>
      _localizedValues[locale.languageCode]?['social_sign_in_not_implemented']
          ?.replaceAll('{provider}', provider) ??
      '$provider sign-in is not yet implemented.';
  // --- Added for WelcomeScreen ---
  String get activeUsers =>
      _localizedValues[locale.languageCode]?['active_users'] ?? 'Active Users';
  String get ordersProcessed =>
      _localizedValues[locale.languageCode]?['orders_processed'] ?? 'Orders Processed Updated';
  String get uptime =>
      _localizedValues[locale.languageCode]?['uptime'] ?? 'Uptime';
  String get inventoryManagement =>
      _localizedValues[locale.languageCode]?['inventory_management'] ??
      'Inventory Management';
  String get manageInventoryEfficiently =>
      _localizedValues[locale.languageCode]?['manage_inventory_efficiently'] ??
      'Manage your inventory efficiently.';
  String get salesAnalytics =>
      _localizedValues[locale.languageCode]?['sales_analytics'] ??
      'Sales Analytics';
  String get analyzeSalesData =>
      _localizedValues[locale.languageCode]?['analyze_sales_data'] ??
      'Analyze sales data in real time.';
  String get customerManagement =>
      _localizedValues[locale.languageCode]?['customer_management'] ??
      'Customer Management';
  String get engageCustomers =>
      _localizedValues[locale.languageCode]?['engage_customers'] ??
      'Engage and manage your customers.';
  String get securePlatform =>
      _localizedValues[locale.languageCode]?['secure_platform'] ??
      'Secure Platform';
  String get dataProtected =>
      _localizedValues[locale.languageCode]?['data_protected'] ??
      'Your data is protected with us.';
  String get whyChooseMultiSales =>
      _localizedValues[locale.languageCode]?['why_choose_multisales'] ??
      'Why Choose MultiSales?';
  String get getStarted =>
      _localizedValues[locale.languageCode]?['get_started'] ?? 'Get Started';
  String get learnMore =>
      _localizedValues[locale.languageCode]?['learn_more'] ?? 'Learn More';
  String get aboutMultiSales =>
      _localizedValues[locale.languageCode]?['about_multisales'] ??
      'About MultiSales';
  String get ourMission =>
      _localizedValues[locale.languageCode]?['our_mission'] ?? 'Our Mission';
  String get missionStatement =>
      _localizedValues[locale.languageCode]?['mission_statement'] ??
      'To empower sales teams with modern, efficient, and secure tools.';
  String get keyFeatures =>
      _localizedValues[locale.languageCode]?['key_features'] ?? 'Key Features';
  String get keyFeaturesDesc =>
      _localizedValues[locale.languageCode]?['key_features_desc'] ??
      'Comprehensive analytics, inventory, and customer management.';
  String get securityPrivacy =>
      _localizedValues[locale.languageCode]?['security_privacy'] ??
      'Security & Privacy';
  String get securityPrivacyDesc =>
      _localizedValues[locale.languageCode]?['security_privacy_desc'] ??
      'We prioritize your data security and privacy.';
  String get support =>
      _localizedValues[locale.languageCode]?['support'] ?? 'Support';
  String get supportDesc =>
      _localizedValues[locale.languageCode]?['support_desc'] ??
      '24/7 support for all users.';
  String get close =>
      _localizedValues[locale.languageCode]?['close'] ?? 'Close';
  String get couldNotOpenTerms =>
      _localizedValues[locale.languageCode]?['could_not_open_terms'] ??
      'Could not open Terms of Service';
  String get couldNotOpenPrivacy =>
      _localizedValues[locale.languageCode]?['could_not_open_privacy'] ??
      'Could not open Privacy Policy';
  // --- Added for HomeScreen training cards and loading ---
  String get loadingTrainingData =>
      _localizedValues[locale.languageCode]?['loading_training_data'] ??
      'Loading training data...';
  String get salesFundamentals =>
      _localizedValues[locale.languageCode]?['sales_fundamentals'] ??
      'Sales Fundamentals';
  String get completeSalesTraining =>
      _localizedValues[locale.languageCode]?['complete_sales_training'] ??
      'Complete your sales training';
  String get productKnowledge =>
      _localizedValues[locale.languageCode]?['product_knowledge'] ??
      'Product Knowledge';
  String get learnAboutProducts =>
      _localizedValues[locale.languageCode]?['learn_about_products'] ??
      'Learn about our products';
  String get customerService =>
      _localizedValues[locale.languageCode]?['customer_service'] ??
      'Customer Service';
  String get masterCustomerInteractions =>
      _localizedValues[locale.languageCode]?['master_customer_interactions'] ??
      'Master customer interactions';
  String get passwordHint =>
      _localizedValues[locale.languageCode]?['password_hint'] ?? 'Password';
  // --- Added for AuthScreen ---
  String get signInSuccess =>
      _localizedValues[locale.languageCode]?['sign_in_success'] ??
      'Sign in successful!';
  String get signUpSuccess =>
      _localizedValues[locale.languageCode]?['sign_up_success'] ??
      'Sign up successful!';
  String get firstName =>
      _localizedValues[locale.languageCode]?['first_name'] ?? 'First Name';
  String get firstNameHint =>
      _localizedValues[locale.languageCode]?['first_name_hint'] ?? 'John';
  String get firstNameInput =>
      _localizedValues[locale.languageCode]?['first_name_input'] ??
      'First name input field';
  String get lastName =>
      _localizedValues[locale.languageCode]?['last_name'] ?? 'Last Name';
  String get lastNameHint =>
      _localizedValues[locale.languageCode]?['last_name_hint'] ?? 'Doe';
  String get lastNameInput =>
      _localizedValues[locale.languageCode]?['last_name_input'] ??
      'Last name input field';
  String get emailHint =>
      _localizedValues[locale.languageCode]?['email_hint'] ??
      'john.doe@example.com';
  String get emailSignUpInput =>
      _localizedValues[locale.languageCode]?['email_sign_up_input'] ??
      'Email address input field for sign up';
  String get phone =>
      _localizedValues[locale.languageCode]?['phone'] ?? 'Phone Number';
  String get phoneHint =>
      _localizedValues[locale.languageCode]?['phone_hint'] ?? '+1 234 567 8900';
  String get phoneInput =>
      _localizedValues[locale.languageCode]?['phone_input'] ??
      'Phone number input field';
  String get createPasswordHint =>
      _localizedValues[locale.languageCode]?['create_password_hint'] ??
      'Create a strong password';
  String get createPasswordInput =>
      _localizedValues[locale.languageCode]?['create_password_input'] ??
      'Create password field';
  String get confirmPassword =>
      _localizedValues[locale.languageCode]?['confirm_password'] ??
      'Confirm Password';
  String get confirmPasswordHint =>
      _localizedValues[locale.languageCode]?['confirm_password_hint'] ??
      'Re-enter your password';
  String get confirmPasswordInput =>
      _localizedValues[locale.languageCode]?['confirm_password_input'] ??
      'Confirm password field';
  String get facebookSignUpNotImplemented =>
      _localizedValues[locale.languageCode]
          ?['facebook_sign_up_not_implemented'] ??
      'Facebook (OAuth2) sign-up is not yet implemented.';
  String get appleSignUpNotImplemented =>
      _localizedValues[locale.languageCode]?['apple_sign_up_not_implemented'] ??
      'Apple (OAuth2) sign-up is not yet implemented.';
  String get createAccountButton =>
      _localizedValues[locale.languageCode]?['create_account_button'] ??
      'Create account button';
  String get createAccountTooltip =>
      _localizedValues[locale.languageCode]?['create_account_tooltip'] ??
      'Create your new account';
  String get createAccount =>
      _localizedValues[locale.languageCode]?['create_account'] ??
      'Create Account';
  String get pleaseEnterEmail =>
      _localizedValues[locale.languageCode]?['please_enter_email'] ??
      'Please enter your email';
  String get pleaseEnterValidEmail =>
      _localizedValues[locale.languageCode]?['please_enter_valid_email'] ??
      'Please enter a valid email address';
  String get pleaseEnterPassword =>
      _localizedValues[locale.languageCode]?['please_enter_password'] ??
      'Please enter your password';
  String get passwordMinLength =>
      _localizedValues[locale.languageCode]?['password_min_length'] ??
      'Password must be at least 6 characters';
  String get pleaseConfirmPassword =>
      _localizedValues[locale.languageCode]?['please_confirm_password'] ??
      'Please confirm your password';
  String get passwordsDoNotMatch =>
      _localizedValues[locale.languageCode]?['passwords_do_not_match'] ??
      'Passwords do not match';
  String get fieldRequired =>
      _localizedValues[locale.languageCode]?['field_required'] ??
      'This field is required';
  String get nameMinLength =>
      _localizedValues[locale.languageCode]?['name_min_length'] ??
      'Must be at least 2 characters';
  String get pleaseEnterPhone =>
      _localizedValues[locale.languageCode]?['please_enter_phone'] ??
      'Please enter your phone number';
  String get pleaseEnterValidPhone =>
      _localizedValues[locale.languageCode]?['please_enter_valid_phone'] ??
      'Please enter a valid phone number';
  // Social login specific
  String get signInWithFacebook =>
      _localizedValues[locale.languageCode]?['sign_in_with_facebook'] ??
      'Sign in with Facebook';
  String get signInWithApple =>
      _localizedValues[locale.languageCode]?['sign_in_with_apple'] ??
      'Sign in with Apple';
  String get noSocialLogin =>
      _localizedValues[locale.languageCode]?['no_social_login'] ??
      'No social login options available';
  String get termsOfService =>
      _localizedValues[locale.languageCode]?['terms_of_service'] ??
      'Terms of Service';
  String get privacyPolicy =>
      _localizedValues[locale.languageCode]?['privacy_policy'] ??
      'Privacy Policy';
  // Home/Dashboard specific
  String get trainingProgress =>
      _localizedValues[locale.languageCode]?['training_progress'] ??
      'Training Progress';
  String get viewAll =>
      _localizedValues[locale.languageCode]?['view_all'] ?? 'View All';
  String get quickActions =>
      _localizedValues[locale.languageCode]?['quick_actions'] ??
      'Quick Actions';
  String get addTask =>
      _localizedValues[locale.languageCode]?['add_task'] ?? 'Add Task';
  String get sendMessage =>
      _localizedValues[locale.languageCode]?['send_message'] ?? 'Send Message';
  String get scheduleMeeting =>
      _localizedValues[locale.languageCode]?['schedule_meeting'] ??
      'Schedule Meeting';
  final Locale locale;

  AppLocalizations(this.locale);

  String get oauthSignIn =>
      _localizedValues[locale.languageCode]?['oauth_sign_in'] ??
      'Sign in with OAuth2';

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('fr', 'FR'), // French
    Locale('ar', 'SA'), // Arabic
    Locale('es', 'ES'), // Spanish
    Locale('de', 'DE'), // German
  ];

  // Localized strings
  String get appTitle =>
      _localizedValues[locale.languageCode]?['app_title'] ?? 'MultiSales';

  // Auth related strings
  String get loginTitle =>
      _localizedValues[locale.languageCode]?['login_title'] ?? 'Login';
  String get email =>
      _localizedValues[locale.languageCode]?['email'] ?? 'Email';
  String get password =>
      _localizedValues[locale.languageCode]?['password'] ?? 'Password';
  String get signIn =>
      _localizedValues[locale.languageCode]?['sign_in'] ?? 'Sign In';
  String get signUp =>
      _localizedValues[locale.languageCode]?['sign_up'] ?? 'Sign Up';
  String get forgotPassword =>
      _localizedValues[locale.languageCode]?['forgot_password'] ??
      'Forgot Password?';
  String get noAccount =>
      _localizedValues[locale.languageCode]?['no_account'] ??
      "Don't have an account? Sign Up";
  String get haveAccount =>
      _localizedValues[locale.languageCode]?['have_account'] ??
      'Already have an account? Sign In';

  // Validation messages
  String get emailRequired =>
      _localizedValues[locale.languageCode]?['email_required'] ??
      'Please enter your email';
  String get emailInvalid =>
      _localizedValues[locale.languageCode]?['email_invalid'] ??
      'Please enter a valid email';
  String get passwordRequired =>
      _localizedValues[locale.languageCode]?['password_required'] ??
      'Please enter your password';
  String get passwordTooShort =>
      _localizedValues[locale.languageCode]?['password_too_short'] ??
      'Password must be at least 6 characters';

  // Messages
  String get loginSuccess =>
      _localizedValues[locale.languageCode]?['login_success'] ??
      'Login successful!';
  String get loginFailed =>
      _localizedValues[locale.languageCode]?['login_failed'] ??
      'Login failed. Please check your credentials.';
  String get passwordResetSent =>
      _localizedValues[locale.languageCode]?['password_reset_sent'] ??
      'Password reset email sent!';

  // Navigation
  String get home => _localizedValues[locale.languageCode]?['home'] ?? 'Home';
  String get training =>
      _localizedValues[locale.languageCode]?['training'] ?? 'Training';
  String get onboarding =>
      _localizedValues[locale.languageCode]?['onboarding'] ?? 'Onboarding';
  String get profile =>
      _localizedValues[locale.languageCode]?['profile'] ?? 'Profile';
  String get settings =>
      _localizedValues[locale.languageCode]?['settings'] ?? 'Settings';

  // Welcome messages
  String get welcomeToMultiSales =>
      _localizedValues[locale.languageCode]?['welcome_to_multisales'] ??
      'Welcome to MultiSales';
  String get welcomeMessage =>
      _localizedValues[locale.languageCode]?['welcome_message'] ??
      'Your comprehensive onboarding platform';

  // Onboarding
  String get welcomeToSales =>
      _localizedValues[locale.languageCode]?['welcome_to_sales'] ??
      'Welcome to Sales Team';
  String get welcomeToSupport =>
      _localizedValues[locale.languageCode]?['welcome_to_support'] ??
      'Welcome to Support Team';
  String get welcomeToTech =>
      _localizedValues[locale.languageCode]?['welcome_to_tech'] ??
      'Welcome to Technical Team';

  // Training
  String get trainingModules =>
      _localizedValues[locale.languageCode]?['training_modules'] ??
      'Training Modules';
  String get startTraining =>
      _localizedValues[locale.languageCode]?['start_training'] ??
      'Start Training';
  String get continueTraining =>
      _localizedValues[locale.languageCode]?['continue_training'] ??
      'Continue Training';
  String get completeTraining =>
      _localizedValues[locale.languageCode]?['complete_training'] ??
      'Complete Training';

  // Common actions
  String get next => _localizedValues[locale.languageCode]?['next'] ?? 'Next';
  String get previous =>
      _localizedValues[locale.languageCode]?['previous'] ?? 'Previous';
  String get complete =>
      _localizedValues[locale.languageCode]?['complete'] ?? 'Complete';
  String get skip => _localizedValues[locale.languageCode]?['skip'] ?? 'Skip';
  String get cancel =>
      _localizedValues[locale.languageCode]?['cancel'] ?? 'Cancel';
  String get save => _localizedValues[locale.languageCode]?['save'] ?? 'Save';
  String get edit => _localizedValues[locale.languageCode]?['edit'] ?? 'Edit';
  String get delete =>
      _localizedValues[locale.languageCode]?['delete'] ?? 'Delete';
  String get confirm =>
      _localizedValues[locale.languageCode]?['confirm'] ?? 'Confirm';

  // Error messages
  String get error =>
      _localizedValues[locale.languageCode]?['error'] ?? 'Error';
  String get somethingWentWrong =>
      _localizedValues[locale.languageCode]?['something_went_wrong'] ??
      'Something went wrong!';
  String get networkError =>
      _localizedValues[locale.languageCode]?['network_error'] ??
      'Network error. Please check your connection.';
  String get tryAgain =>
      _localizedValues[locale.languageCode]?['try_again'] ?? 'Try Again';

  // Progress
  String get progress =>
      _localizedValues[locale.languageCode]?['progress'] ?? 'Progress';
  String get completed =>
      _localizedValues[locale.languageCode]?['completed'] ?? 'Completed';
  String get inProgress =>
      _localizedValues[locale.languageCode]?['in_progress'] ?? 'In Progress';
  String get notStarted =>
      _localizedValues[locale.languageCode]?['not_started'] ?? 'Not Started';

  // Localized values map
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
    'appointments': 'Appointments',
    'calendar_settings': 'Calendar Settings',
    'sync_calendar': 'Sync Calendar',
      // --- Added for LoginScreen ---
      'error': 'Error',
      'or_sign_in_with': 'or sign in with',
      'social_sign_in_not_implemented':
          '{provider} sign-in is not yet implemented.',
      // --- Added for WelcomeScreen ---
      'active_users': 'Active Users',
      'orders_processed': 'Orders Processed',
      'uptime': 'Uptime',
      'inventory_management': 'Inventory Management',
      'manage_inventory_efficiently': 'Manage your inventory efficiently.',
      'sales_analytics': 'Sales Analytics',
      'analyze_sales_data': 'Analyze sales data in real time.',
      'customer_management': 'Customer Management',
      'engage_customers': 'Engage and manage your customers.',
      'secure_platform': 'Secure Platform',
      'data_protected': 'Your data is protected with us.',
      'why_choose_multisales': 'Why Choose MultiSales?',
      'get_started': 'Get Started',
      'learn_more': 'Learn More',
      'about_multisales': 'About MultiSales',
      'our_mission': 'Our Mission',
      'mission_statement':
          'To empower sales teams with modern, efficient, and secure tools.',
      'key_features': 'Key Features',
      'key_features_desc':
          'Comprehensive analytics, inventory, and customer management.',
      'security_privacy': 'Security & Privacy',
      'security_privacy_desc': 'We prioritize your data security and privacy.',
      'support': 'Support',
      'support_desc': '24/7 support for all users.',
      'close': 'Close',
      'could_not_open_terms': 'Could not open Terms of Service',
      'could_not_open_privacy': 'Could not open Privacy Policy',
      // --- Added for HomeScreen training cards and loading ---
      'loading_training_data': 'Loading training data...',
      'sales_fundamentals': 'Sales Fundamentals',
      'complete_sales_training': 'Complete your sales training',
      'product_knowledge': 'Product Knowledge',
      'learn_about_products': 'Learn about our products',
      'customer_service': 'Customer Service',
      'master_customer_interactions': 'Master customer interactions',
      // --- Added for AuthScreen ---
      'sign_in_success': 'Sign in successful!',
      'sign_up_success': 'Sign up successful!',
      'first_name': 'First Name',
      'first_name_hint': 'John',
      'first_name_input': 'First name input field',
      'last_name': 'Last Name',
      'last_name_hint': 'Doe',
      'last_name_input': 'Last name input field',
      'email_hint': 'john.doe@example.com',
      'email_sign_up_input': 'Email address input field for sign up',
      'phone': 'Phone Number',
      'phone_hint': '+1 234 567 8900',
      'phone_input': 'Phone number input field',
      'create_password_hint': 'Create a strong password',
      'create_password_input': 'Create password field',
      'confirm_password': 'Confirm Password',
      'confirm_password_hint': 'Re-enter your password',
      'confirm_password_input': 'Confirm password field',
      'facebook_sign_up_not_implemented':
          'Facebook (OAuth2) sign-up is not yet implemented.',
      'apple_sign_up_not_implemented':
          'Apple (OAuth2) sign-up is not yet implemented.',
      'create_account_button': 'Create account button',
      'create_account_tooltip': 'Create your new account',
      'create_account': 'Create Account',
      'please_enter_email': 'Please enter your email',
      'please_enter_valid_email': 'Please enter a valid email address',
      'please_enter_password': 'Please enter your password',
      'password_min_length': 'Password must be at least 6 characters',
      'please_confirm_password': 'Please confirm your password',
      'passwords_do_not_match': 'Passwords do not match',
      'field_required': 'This field is required',
      'name_min_length': 'Must be at least 2 characters',
      'please_enter_phone': 'Please enter your phone number',
      'please_enter_valid_phone': 'Please enter a valid phone number',
      'sign_in_with_facebook': 'Sign in with Facebook',
      'sign_in_with_apple': 'Sign in with Apple',
      'no_social_login': 'No social login options available',
      'terms_of_service': 'Terms of Service',
      'privacy_policy': 'Privacy Policy',
      'training_progress': 'Training Progress',
      'view_all': 'View All',
      'quick_actions': 'Quick Actions',
      'add_task': 'Add Task',
      'send_message': 'Send Message',
      'schedule_meeting': 'Schedule Meeting',
      'app_title': 'MultiSales',
      'login_title': 'Login',
      'email': 'Email',
      'password': 'Password',
      'sign_in': 'Sign In',
      'sign_up': 'Sign Up',
      'forgot_password': 'Forgot Password?',
      'no_account': "Don't have an account? Sign Up",
      'have_account': 'Already have an account? Sign In',
      'email_required': 'Please enter your email',
      'email_invalid': 'Please enter a valid email',
      'password_required': 'Please enter your password',
      'password_too_short': 'Password must be at least 6 characters',
      'login_success': 'Login successful!',
      'login_failed': 'Login failed. Please check your credentials.',
      'password_reset_sent': 'Password reset email sent!',
      'home': 'Home',
      'training': 'Training',
      'onboarding': 'Onboarding',
      'profile': 'Profile',
      'settings': 'Settings',
      'welcome_to_multisales': 'Welcome to MultiSales',
      'welcome_message': 'Your comprehensive onboarding platform',
      'welcome_to_sales': 'Welcome to Sales Team',
      'welcome_to_support': 'Welcome to Support Team',
      'welcome_to_tech': 'Welcome to Technical Team',
      'training_modules': 'Training Modules',
      'start_training': 'Start Training',
      'continue_training': 'Continue Training',
      'complete_training': 'Complete Training',
      'next': 'Next',
      'previous': 'Previous',
      'complete': 'Complete',
      'skip': 'Skip',
      'cancel': 'Cancel',
      'save': 'Save',
      'edit': 'Edit',
      'delete': 'Delete',
      'confirm': 'Confirm',
      // 'error': 'Error', // Removed duplicate key
      'something_went_wrong': 'Something went wrong!',
      'network_error': 'Network error. Please check your connection.',
      'try_again': 'Try Again',
      'progress': 'Progress',
      'completed': 'Completed',
      'in_progress': 'In Progress',
      'not_started': 'Not Started',
      'oauth_sign_in': 'Sign in with OAuth2',
    },
    'fr': {
    'appointments': 'Rendez-vous',
    'calendar_settings': 'Paramètres du calendrier',
    'sync_calendar': 'Synchroniser le calendrier',
      // --- Added for HomeScreen training cards and loading ---
      'loading_training_data': 'Chargement des données de formation...',
      'sales_fundamentals': 'Fondamentaux de la vente',
      'complete_sales_training': 'Terminez votre formation à la vente',
      'product_knowledge': 'Connaissance du produit',
      'learn_about_products': 'Découvrez nos produits',
      'customer_service': 'Service client',
      'master_customer_interactions': 'Maîtrisez les interactions clients',
      'sign_in_with_facebook': 'Se connecter avec Facebook',
      'sign_in_with_apple': 'Se connecter avec Apple',
      'no_social_login': 'Aucune option de connexion sociale disponible',
      'terms_of_service': "Conditions d'utilisation",
      'privacy_policy': 'Politique de confidentialité',
      'training_progress': 'Progrès de la formation',
      'view_all': 'Voir tout',
      'quick_actions': 'Actions rapides',
      'add_task': 'Ajouter une tâche',
      'send_message': 'Envoyer un message',
      'schedule_meeting': 'Planifier une réunion',
      'app_title': 'MultiSales',
      'login_title': 'Connexion',
      'email': 'E-mail',
      'password': 'Mot de passe',
      'sign_in': 'Se connecter',
      'sign_up': "S'inscrire",
      'forgot_password': 'Mot de passe oublié?',
      'no_account': "Pas de compte? S'inscrire",
      'have_account': 'Déjà un compte? Se connecter',
      'email_required': 'Veuillez entrer votre e-mail',
      'email_invalid': 'Veuillez entrer un e-mail valide',
      'password_required': 'Veuillez entrer votre mot de passe',
      'password_too_short':
          'Le mot de passe doit contenir au moins 6 caractères',
      'login_success': 'Connexion réussie!',
      'login_failed': 'Échec de la connexion. Vérifiez vos identifiants.',
      'password_reset_sent':
          'E-mail de réinitialisation du mot de passe envoyé!',
      'home': 'Accueil',
      'training': 'Formation',
      'onboarding': 'Intégration',
      'profile': 'Profil',
      'settings': 'Paramètres',
      'welcome_to_multisales': 'Bienvenue chez MultiSales',
      'welcome_message': 'Votre plateforme d\'intégration complète',
      'welcome_to_sales': 'Bienvenue dans l\'équipe de vente',
      'welcome_to_support': 'Bienvenue dans l\'équipe de support',
      'welcome_to_tech': 'Bienvenue dans l\'équipe technique',
      'training_modules': 'Modules de formation',
      'start_training': 'Commencer la formation',
      'continue_training': 'Continuer la formation',
      'complete_training': 'Terminer la formation',
      'next': 'Suivant',
      'previous': 'Précédent',
      'complete': 'Terminer',
      'skip': 'Ignorer',
      'cancel': 'Annuler',
      'save': 'Enregistrer',
      'edit': 'Modifier',
      'delete': 'Supprimer',
      'confirm': 'Confirmer',
      'error': 'Erreur',
      'something_went_wrong': 'Quelque chose s\'est mal passé!',
      'network_error': 'Erreur réseau. Vérifiez votre connexion.',
      'try_again': 'Réessayer',
      'progress': 'Progrès',
      'completed': 'Terminé',
      'in_progress': 'En cours',
      'not_started': 'Pas commencé',
      'oauth_sign_in': 'Se connecter avec OAuth2',
    },
    'ar': {
    'appointments': 'المواعيد',
    'calendar_settings': 'إعدادات التقويم',
    'sync_calendar': 'مزامنة التقويم',
      'sign_in_with_facebook': 'تسجيل الدخول عبر فيسبوك',
      'sign_in_with_apple': 'تسجيل الدخول عبر أبل',
      'no_social_login': 'لا توجد خيارات تسجيل دخول اجتماعي متاحة',
      'terms_of_service': 'شروط الخدمة',
      'privacy_policy': 'سياسة الخصوصية',
      'training_progress': 'تقدم التدريب',
      'view_all': 'عرض الكل',
      'quick_actions': 'إجراءات سريعة',
      'add_task': 'إضافة مهمة',
      'send_message': 'إرسال رسالة',
      'schedule_meeting': 'جدولة اجتماع',
      'app_title': 'MultiSales',
      'login_title': 'تسجيل الدخول',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'sign_in': 'تسجيل الدخول',
      'sign_up': 'إنشاء حساب',
      'forgot_password': 'نسيت كلمة المرور؟',
      'no_account': 'ليس لديك حساب؟ إنشاء حساب',
      'have_account': 'لديك حساب بالفعل؟ تسجيل الدخول',
      'email_required': 'يرجى إدخال بريدك الإلكتروني',
      'email_invalid': 'يرجى إدخال بريد إلكتروني صالح',
      'password_required': 'يرجى إدخال كلمة المرور',
      'password_too_short': 'يجب أن تكون كلمة المرور 6 أحرف على الأقل',
      'login_success': 'تم تسجيل الدخول بنجاح!',
      'login_failed': 'فشل تسجيل الدخول. تحقق من بياناتك.',
      'password_reset_sent': 'تم إرسال رسالة إعادة تعيين كلمة المرور!',
      'home': 'الرئيسية',
      'training': 'التدريب',
      'onboarding': 'التأهيل',
      'profile': 'الملف الشخصي',
      'settings': 'الإعدادات',
      'welcome_to_multisales': 'مرحبا بك في MultiSales',
      'welcome_message': 'منصة التأهيل الشاملة الخاصة بك',
      'welcome_to_sales': 'مرحبا بك في فريق المبيعات',
      'welcome_to_support': 'مرحبا بك في فريق الدعم',
      'welcome_to_tech': 'مرحبا بك في الفريق التقني',
      'training_modules': 'وحدات التدريب',
      'start_training': 'بدء التدريب',
      'continue_training': 'متابعة التدريب',
      'complete_training': 'إنهاء التدريب',
      'next': 'التالي',
      'previous': 'السابق',
      'complete': 'إنهاء',
      'skip': 'تخطي',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'edit': 'تعديل',
      'delete': 'حذف',
      'confirm': 'تأكيد',
      'error': 'خطأ',
      'something_went_wrong': 'حدث خطأ ما!',
      'network_error': 'خطأ في الشبكة. تحقق من اتصالك.',
      'try_again': 'حاول مرة أخرى',
      'progress': 'التقدم',
      'completed': 'مكتمل',
      'in_progress': 'قيد التنفيذ',
      'not_started': 'لم يبدأ',
      'oauth_sign_in': 'تسجيل الدخول باستخدام OAuth2',
    },
    'es': {
    'appointments': 'Citas',
    'calendar_settings': 'Configuración del calendario',
    'sync_calendar': 'Sincronizar calendario',
      'sign_in_with_facebook': 'Iniciar sesión con Facebook',
      'sign_in_with_apple': 'Iniciar sesión con Apple',
      'no_social_login':
          'No hay opciones de inicio de sesión social disponibles',
      'terms_of_service': 'Términos de servicio',
      'privacy_policy': 'Política de privacidad',
      'training_progress': 'Progreso de entrenamiento',
      'view_all': 'Ver todo',
      'quick_actions': 'Acciones rápidas',
      'add_task': 'Agregar tarea',
      'send_message': 'Enviar mensaje',
      'schedule_meeting': 'Programar reunión',
      'app_title': 'MultiSales',
      'login_title': 'Iniciar sesión',
      'email': 'Correo electrónico',
      'password': 'Contraseña',
      'sign_in': 'Iniciar sesión',
      'sign_up': 'Registrarse',
      'forgot_password': '¿Olvidaste tu contraseña?',
      'no_account': '¿No tienes cuenta? Registrarse',
      'have_account': '¿Ya tienes cuenta? Iniciar sesión',
      'email_required': 'Por favor ingresa tu correo electrónico',
      'email_invalid': 'Por favor ingresa un correo electrónico válido',
      'password_required': 'Por favor ingresa tu contraseña',
      'password_too_short': 'La contraseña debe tener al menos 6 caracteres',
      'login_success': '¡Inicio de sesión exitoso!',
      'login_failed': 'Error al iniciar sesión. Verifica tus credenciales.',
      'password_reset_sent':
          '¡Correo de restablecimiento de contraseña enviado!',
      'home': 'Inicio',
      'training': 'Entrenamiento',
      'onboarding': 'Incorporación',
      'profile': 'Perfil',
      'settings': 'Configuración',
      'welcome_to_multisales': 'Bienvenido a MultiSales',
      'welcome_message': 'Tu plataforma integral de incorporación',
      'welcome_to_sales': 'Bienvenido al equipo de ventas',
      'welcome_to_support': 'Bienvenido al equipo de soporte',
      'welcome_to_tech': 'Bienvenido al equipo técnico',
      'training_modules': 'Módulos de entrenamiento',
      'start_training': 'Comenzar entrenamiento',
      'continue_training': 'Continuar entrenamiento',
      'complete_training': 'Completar entrenamiento',
      'next': 'Siguiente',
      'previous': 'Anterior',
      'complete': 'Completar',
      'skip': 'Omitir',
      'cancel': 'Cancelar',
      'save': 'Guardar',
      'edit': 'Editar',
      'delete': 'Eliminar',
      'confirm': 'Confirmar',
      'error': 'Error',
      'something_went_wrong': '¡Algo salió mal!',
      'network_error': 'Error de red. Verifica tu conexión.',
      'try_again': 'Intentar de nuevo',
      'progress': 'Progreso',
      'completed': 'Completado',
      'in_progress': 'En progreso',
      'not_started': 'No iniciado',
      'oauth_sign_in': 'Iniciar sesión con OAuth2',
    },
    'de': {
    'appointments': 'Termine',
    'calendar_settings': 'Kalendereinstellungen',
    'sync_calendar': 'Kalender synchronisieren',
      'sign_in_with_facebook': 'Mit Facebook anmelden',
      'sign_in_with_apple': 'Mit Apple anmelden',
      'no_social_login': 'Keine Social-Login-Optionen verfügbar',
      'terms_of_service': 'Nutzungsbedingungen',
      'privacy_policy': 'Datenschutzrichtlinie',
      'training_progress': 'Trainingsfortschritt',
      'view_all': 'Alle ansehen',
      'quick_actions': 'Schnellaktionen',
      'add_task': 'Aufgabe hinzufügen',
      'send_message': 'Nachricht senden',
      'schedule_meeting': 'Meeting planen',
      'app_title': 'MultiSales',
      'login_title': 'Anmelden',
      'email': 'E-Mail',
      'password': 'Passwort',
      'sign_in': 'Anmelden',
      'sign_up': 'Registrieren',
      'forgot_password': 'Passwort vergessen?',
      'no_account': 'Kein Konto? Registrieren',
      'have_account': 'Bereits ein Konto? Anmelden',
      'email_required': 'Bitte geben Sie Ihre E-Mail ein',
      'email_invalid': 'Bitte geben Sie eine gültige E-Mail ein',
      'password_required': 'Bitte geben Sie Ihr Passwort ein',
      'password_too_short': 'Passwort muss mindestens 6 Zeichen haben',
      'login_success': 'Anmeldung erfolgreich!',
      'login_failed':
          'Anmeldung fehlgeschlagen. Überprüfen Sie Ihre Anmeldedaten.',
      'password_reset_sent': 'Passwort-Reset-E-Mail gesendet!',
      'home': 'Startseite',
      'training': 'Schulung',
      'onboarding': 'Einarbeitung',
      'profile': 'Profil',
      'settings': 'Einstellungen',
      'welcome_to_multisales': 'Willkommen bei MultiSales',
      'welcome_message': 'Ihre umfassende Einarbeitungsplattform',
      'welcome_to_sales': 'Willkommen im Vertriebsteam',
      'welcome_to_support': 'Willkommen im Support-Team',
      'welcome_to_tech': 'Willkommen im technischen Team',
      'training_modules': 'Schulungsmodule',
      'start_training': 'Schulung beginnen',
      'continue_training': 'Schulung fortsetzen',
      'complete_training': 'Schulung abschließen',
      'next': 'Weiter',
      'previous': 'Zurück',
      'complete': 'Abschließen',
      'skip': 'Überspringen',
      'cancel': 'Abbrechen',
      'save': 'Speichern',
      'edit': 'Bearbeiten',
      'delete': 'Löschen',
      'confirm': 'Bestätigen',
      'error': 'Fehler',
      'something_went_wrong': 'Etwas ist schief gelaufen!',
      'network_error': 'Netzwerkfehler. Überprüfen Sie Ihre Verbindung.',
      'try_again': 'Erneut versuchen',
      'progress': 'Fortschritt',
      'completed': 'Abgeschlossen',
      'in_progress': 'In Bearbeitung',
      'not_started': 'Nicht begonnen',
      'oauth_sign_in': 'Mit OAuth2 anmelden',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
