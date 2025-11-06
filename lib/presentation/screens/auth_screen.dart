// Removed broken import for SocialLoginButtons (file does not exist)
import '../../l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
// Removed broken import for Enhanced Form Fields (file does not exist)

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  // Stub for onboarding tab
  Widget _buildOnboardingTab() {
    return const Center(
      child: Text('Onboarding content goes here.'),
    );
  }

  // Stub for forgot password tab
  Widget _buildForgotPasswordTab() {
    return const Center(
      child: Text('Forgot password content goes here.'),
    );
  }

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;

  // Define tab keys and their order
  final List<String> _tabKeys = ['signin', 'signup', 'onboarding', 'forgot'];
  final Map<String, String> _tabLabels = {};
  int _initialTab = 0;
  bool _didInitTabs = false;

  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  // Controllers for sign in
  final TextEditingController _signInEmailController = TextEditingController();
  final TextEditingController _signInPasswordController =
      TextEditingController();

  // Controllers for sign up
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _signUpPasswordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = AppLocalizations.of(context);
    // Set up tab labels (localized)
    _tabLabels.clear();
    _tabLabels['signin'] = loc?.signIn ?? 'Sign In';
    _tabLabels['signup'] = loc?.signUp ?? 'Sign Up';
    _tabLabels['onboarding'] = 'Onboarding';
    _tabLabels['forgot'] = 'Forgot Password';
    if (!_didInitTabs) {
      final extra = GoRouterState.of(context).extra;
      String? tabKey;
      if (extra is Map && extra['tab'] is String) {
        tabKey = extra['tab'];
      }
      _initialTab = tabKey != null && _tabKeys.contains(tabKey)
          ? _tabKeys.indexOf(tabKey)
          : 0;
      _tabController = TabController(
          length: _tabKeys.length, vsync: this, initialIndex: _initialTab);
      _didInitTabs = true;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _signUpEmailController.dispose();
    _phoneController.dispose();
    _signUpPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc?.appTitle ?? 'MultiSales Auth'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Tab Bar
            TabBar(
              controller: _tabController,
              tabs: _tabKeys.map((k) => Tab(text: _tabLabels[k])).toList(),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSignInForm(),
                  _buildSignUpForm(),
                  _buildOnboardingTab(),
                  _buildForgotPasswordTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetPassword() {
    final l = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(l?.passwordResetSent ?? 'Password reset link sent!')),
    );
  }

  void _signIn() {
    final l = AppLocalizations.of(context);
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l?.signInSuccess ?? 'Sign in successful!')),
      );
    });
  }

  void _signUp() {
    final l = AppLocalizations.of(context);
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l?.signUpSuccess ?? 'Sign up successful!')),
      );
    });
  }

  Widget _buildSignUpForm() {
    final l = AppLocalizations.of(context);
    return Form(
      key: _signUpFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: l?.firstName ?? 'First Name',
                    hintText: l?.firstNameHint ?? 'John',
                    prefixIcon: const Icon(Icons.person_outlined),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: _validateName,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: l?.lastName ?? 'Last Name',
                    hintText: l?.lastNameHint ?? 'Doe',
                    prefixIcon: const Icon(Icons.person_outlined),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: _validateName,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _signUpEmailController,
            decoration: InputDecoration(
              labelText: l?.email ?? 'Email Address',
              hintText: l?.emailHint ?? 'john.doe@example.com',
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: l?.phone ?? 'Phone Number',
              hintText: l?.phoneHint ?? '+1 234 567 8900',
              prefixIcon: const Icon(Icons.phone_outlined),
            ),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: _validatePhone,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _signUpPasswordController,
            decoration: InputDecoration(
              labelText: l?.password ?? 'Password',
              hintText: l?.createPasswordHint ?? 'Create a strong password',
              prefixIcon: const Icon(Icons.lock_outline),
            ),
            obscureText: true,
            textInputAction: TextInputAction.next,
            validator: _validatePassword,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: l?.confirmPassword ?? 'Confirm Password',
              hintText: l?.confirmPasswordHint ?? 'Re-enter your password',
              prefixIcon: const Icon(Icons.lock_outline),
            ),
            obscureText: true,
            textInputAction: TextInputAction.done,
            validator: _validateConfirmPassword,
          ),
          const SizedBox(height: 24),
          // Social login buttons removed (widget does not exist)
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _signUp,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      l?.createAccount ?? 'Create Account',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          // Terms/Privacy Links
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              GestureDetector(
                onTap: () async {
                  final url = Uri.parse('https://multisales.com/terms');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: Text(
                  l?.termsOfService ?? 'Terms of Service',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Text('|'),
              GestureDetector(
                onTap: () async {
                  final url = Uri.parse('https://multisales.com/privacy');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: Text(
                  l?.privacyPolicy ?? 'Privacy Policy',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String? value) {
    final l = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l?.pleaseEnterEmail ?? 'Please enter your email';
    }
    // Basic RFC-like email check
    if (!RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return l?.pleaseEnterValidEmail ?? 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final l = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l?.pleaseEnterPassword ?? 'Please enter your password';
    }
    if (value.length < 6) {
      return l?.passwordMinLength ?? 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final l = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l?.pleaseConfirmPassword ?? 'Please confirm your password';
    }
    if (value != _signUpPasswordController.text) {
      return l?.passwordsDoNotMatch ?? 'Passwords do not match';
    }
    return null;
  }

  String? _validateName(String? value) {
    final l = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l?.fieldRequired ?? 'This field is required';
    }
    if (value.length < 2) {
      return l?.nameMinLength ?? 'Must be at least 2 characters';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final l = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l?.pleaseEnterPhone ?? 'Please enter your phone number';
    }
    // E.164-like phone format, after stripping spaces and punctuation
    final normalized = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(normalized)) {
      return l?.pleaseEnterValidPhone ?? 'Please enter a valid phone number';
    }
    return null;
  }

  Widget _buildSignInForm() {
    final l = AppLocalizations.of(context);
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _signInFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Email Field
                TextFormField(
                  controller: _signInEmailController,
                  decoration: InputDecoration(
                    labelText: l?.email ?? 'Email',
                    hintText: l?.emailHint ?? 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                // Password Field
                TextFormField(
                  controller: _signInPasswordController,
                  decoration: InputDecoration(
                    labelText: l?.password ?? 'Password',
                    hintText: l?.passwordHint ?? 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 8),
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _resetPassword,
                    child: Text(
                      l?.forgotPassword ?? 'Forgot password?',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signIn,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            l?.signIn ?? 'Sign In',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l?.noAccount ?? "Don't have an account?",
                        style: const TextStyle(fontSize: 14)),
                    TextButton(
                      onPressed: () => _tabController.animateTo(1),
                      child: Text(l?.signUp ?? 'Sign Up'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Terms/Privacy Links
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final url = Uri.parse('https://multisales.com/terms');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        }
                      },
                      child: Text(
                        l?.termsOfService ?? 'Terms of Service',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const Text('|'),
                    GestureDetector(
                      onTap: () async {
                        final url = Uri.parse('https://multisales.com/privacy');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        }
                      },
                      child: Text(
                        l?.privacyPolicy ?? 'Privacy Policy',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Stub for onboarding tab
  // (Widget methods already defined above, remove these duplicates)
}
