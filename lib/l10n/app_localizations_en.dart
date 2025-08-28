// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MultiSales Auth';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signInSuccess => 'Sign in successful!';

  @override
  String get signUpSuccess => 'Sign up successful!';

  @override
  String get firstName => 'First Name';

  @override
  String get firstNameHint => 'John';

  @override
  String get firstNameInput => 'First name input field';

  @override
  String get lastName => 'Last Name';

  @override
  String get lastNameHint => 'Doe';

  @override
  String get lastNameInput => 'Last name input field';

  @override
  String get email => 'Email Address';

  @override
  String get emailHint => 'john.doe@example.com';

  @override
  String get emailSignUpInput => 'Email address input field for sign up';

  @override
  String get phone => 'Phone Number';

  @override
  String get phoneHint => '+1 234 567 8900';

  @override
  String get phoneInput => 'Phone number input field';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Password';

  @override
  String get createPasswordHint => 'Create a strong password';

  @override
  String get createPasswordInput => 'Create password field';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Re-enter your password';

  @override
  String get confirmPasswordInput => 'Confirm password field';

  @override
  String get facebookSignUpNotImplemented => 'Facebook (OAuth2) sign-up is not yet implemented.';

  @override
  String get appleSignUpNotImplemented => 'Apple (OAuth2) sign-up is not yet implemented.';

  @override
  String get createAccountButton => 'Create account button';

  @override
  String get createAccountTooltip => 'Create your new account';

  @override
  String get createAccount => 'Create Account';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email address';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get pleaseConfirmPassword => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get nameMinLength => 'Must be at least 2 characters';

  @override
  String get pleaseEnterPhone => 'Please enter your phone number';

  @override
  String get pleaseEnterValidPhone => 'Please enter a valid phone number';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';
}
