// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/multisales_logo.dart';
import '../widgets/notification_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  int _currentPage = 0;
  bool _isLoading = false;

  // User data collection
  String _selectedRole = '';
  String _businessType = '';
  String _businessSize = '';
  final List<String> _interests = [];

  final List<String> _roles = [
    'Business Owner',
    'Sales Manager',
    'Sales Representative',
    'Marketing Manager',
    'Operations Manager',
    'Other',
  ];

  final List<String> _businessTypes = [
    'Retail',
    'E-commerce',
    'Manufacturing',
    'Services',
    'Technology',
    'Healthcare',
    'Education',
    'Non-profit',
    'Other',
  ];

  final List<String> _businessSizes = [
    'Solo (Just me)',
    'Small (2-10 employees)',
    'Medium (11-50 employees)',
    'Large (51-200 employees)',
    'Enterprise (200+ employees)',
  ];

  final List<String> _availableInterests = [
    'Inventory Management',
    'Sales Analytics',
    'Customer Relations',
    'Order Processing',
    'Marketing Automation',
    'Financial Reporting',
    'Team Collaboration',
    'Mobile Access',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 4) {
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _updateProgress();
      HapticFeedback.lightImpact();
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _updateProgress();
      HapticFeedback.lightImpact();
    }
  }

  void _updateProgress() {
    final progress = (_currentPage + 1) / 5;
    _progressController.animateTo(progress);
  }

  bool _canProceed() {
    switch (_currentPage) {
      case 1:
        return _selectedRole.isNotEmpty;
      case 2:
        return _businessType.isNotEmpty;
      case 3:
        return _businessSize.isNotEmpty;
      case 4:
        return _interests.isNotEmpty;
      default:
        return true;
    }
  }

  Future<void> _completeOnboarding() async {
    setState(() {
      _isLoading = true;
    });

    HapticFeedback.mediumImpact();

    // Simulate API call to save onboarding data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      NotificationWidget.show(
        context,
        title: 'Welcome!',
        message: 'Welcome to MultiSales! Your account is ready.',
        type: NotificationType.success,
      );

      // Navigate to main app
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 768;
          final isDesktop = constraints.maxWidth >= 1024;

          return SafeArea(
            child: Column(
              children: [
                _buildHeader(context, isTablet, isDesktop),
                _buildProgressBar(context),
                Expanded(
                  child: _buildContent(context, isTablet, isDesktop),
                ),
                _buildNavigationButtons(context, isTablet),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isTablet, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 32 : (isTablet ? 24 : 16),
        vertical: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const MultiSalesLogo.small(),
              if (isTablet) ...[
                const SizedBox(width: 12),
                Text(
                  'MultiSales Setup',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ],
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/main');
            },
            child: const Text('Skip'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${_currentPage + 1} of 5',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                '${((_currentPage + 1) / 5 * 100).round()}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _progressAnimation.value,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
                minHeight: 4,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isTablet, bool isDesktop) {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
        _updateProgress();
      },
      children: [
        _buildWelcomePage(context, isTablet, isDesktop),
        _buildRolePage(context, isTablet, isDesktop),
        _buildBusinessTypePage(context, isTablet, isDesktop),
        _buildBusinessSizePage(context, isTablet, isDesktop),
        _buildInterestsPage(context, isTablet, isDesktop),
      ],
    );
  }

  Widget _buildWelcomePage(
      BuildContext context, bool isTablet, bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : (isTablet ? 32 : 16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const MultiSalesLogo.large(),
          const SizedBox(height: 32),
          Text(
            'Welcome to MultiSales!',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Let\'s set up your account to provide you with the best experience. '
            'This will only take a few minutes.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  color: Colors.grey[700],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.security,
                    size: 48,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your Privacy Matters',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We collect this information to personalize your experience and '
                    'recommend features that are most relevant to your business.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRolePage(BuildContext context, bool isTablet, bool isDesktop) {
    return _buildSelectionPage(
      context,
      isTablet,
      isDesktop,
      title: 'What\'s your role?',
      subtitle: 'This helps us customize your dashboard and features.',
      options: _roles,
      selectedValue: _selectedRole,
      onChanged: (value) {
        setState(() {
          _selectedRole = value;
        });
      },
      icon: Icons.person,
    );
  }

  Widget _buildBusinessTypePage(
      BuildContext context, bool isTablet, bool isDesktop) {
    return _buildSelectionPage(
      context,
      isTablet,
      isDesktop,
      title: 'What type of business do you run?',
      subtitle: 'We\'ll suggest relevant features and integrations.',
      options: _businessTypes,
      selectedValue: _businessType,
      onChanged: (value) {
        setState(() {
          _businessType = value;
        });
      },
      icon: Icons.business,
    );
  }

  Widget _buildBusinessSizePage(
      BuildContext context, bool isTablet, bool isDesktop) {
    return _buildSelectionPage(
      context,
      isTablet,
      isDesktop,
      title: 'How big is your team?',
      subtitle: 'This helps us recommend the right plan and features.',
      options: _businessSizes,
      selectedValue: _businessSize,
      onChanged: (value) {
        setState(() {
          _businessSize = value;
        });
      },
      icon: Icons.groups,
    );
  }

  Widget _buildInterestsPage(
      BuildContext context, bool isTablet, bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : (isTablet ? 32 : 16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.interests,
            size: 64,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 24),
          Text(
            'What are you most interested in?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Select all that apply. We\'ll prioritize these features in your dashboard.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[700],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Flexible(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _availableInterests.map((interest) {
                  final isSelected = _interests.contains(interest);
                  return FilterChip(
                    label: Text(interest),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _interests.add(interest);
                        } else {
                          _interests.remove(interest);
                        }
                      });
                      HapticFeedback.selectionClick();
                    },
                    selectedColor:
                        Theme.of(context).primaryColor.withOpacity(0.2),
                    checkmarkColor: Theme.of(context).primaryColor,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionPage(
    BuildContext context,
    bool isTablet,
    bool isDesktop, {
    required String title,
    required String subtitle,
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String> onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : (isTablet ? 32 : 16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[700],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: options.map((option) {
                  final isSelected = selectedValue == option;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: selectedValue,
                        onChanged: (value) {
                          if (value != null) {
                            onChanged(value);
                            HapticFeedback.selectionClick();
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        tileColor: isSelected
                            ? Theme.of(context).primaryColor.withOpacity(0.05)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24 : 16,
        vertical: 16,
      ),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousPage,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Back'),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 16),
          Expanded(
            flex: _currentPage == 0 ? 1 : 2,
            child: ElevatedButton(
              onPressed: _canProceed() ? (_isLoading ? null : _nextPage) : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      _currentPage == 4 ? 'Complete Setup' : 'Continue',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
