// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/localization/app_localizations.dart';
import '../widgets/multisales_logo.dart';
import '../widgets/notification_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> _languages = ['English', 'Español', 'Français'];
  final List<String> _regions = ['US', 'ES', 'FR'];
  String _selectedLanguage = 'English';
  String _selectedRegion = 'US';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _startAnimations();
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _fadeController.forward();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 768;
          final isDesktop = constraints.maxWidth >= 1024;
          final isMobile = constraints.maxWidth < 768;
          return SafeArea(
            child: Stack(
              children: [
                _buildBackground(context),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildContent(context, isTablet, isDesktop, isMobile),
                ),
                _buildHeader(context, isTablet, isDesktop),
                // Terms/Privacy Links at bottom
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 24,
                  child: Center(
                    child: TermsPrivacyRow(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).primaryColor.withOpacity(0.05),
            Colors.white,
          ],
        ),
      ),
      child: CustomPaint(
        painter: BackgroundPatternPainter(),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isTablet, bool isDesktop) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 32 : (isTablet ? 24 : 16),
                vertical: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo section
                  Row(
                    children: [
                      const MultiSalesLogo.small(),
                      if (isTablet) ...[
                        const SizedBox(width: 12),
                        Text(
                          'MultiSales',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                      ],
                    ],
                  ),

                  // Language and region selectors
                  if (isTablet)
                    Row(
                      children: [
                        _buildLanguageSelector(),
                        const SizedBox(width: 16),
                        _buildRegionSelector(),
                      ],
                    )
                  else
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.language),
                      onSelected: (value) {
                        setState(() {
                          _selectedLanguage = value;
                        });
                      },
                      itemBuilder: (context) => _languages.map((lang) {
                        return PopupMenuItem(
                          value: lang,
                          child: Text(lang),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, bool isTablet, bool isDesktop, bool isMobile) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 64 : (isTablet ? 32 : 16),
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),

            // Main content area
            if (isDesktop)
              _buildDesktopLayout(context)
            else if (isTablet)
              _buildTabletLayout(context)
            else
              _buildMobileLayout(context),

            const SizedBox(height: 40),

            // Features section
            _buildFeaturesSection(context, isTablet, isDesktop),

            const SizedBox(height: 40),

            // Action buttons
            _buildActionButtons(context, isTablet, isDesktop),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Row(
        children: [
          // Left side - Text content
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeText(context, true),
                const SizedBox(height: 32),
                _buildDescriptionText(context),
                const SizedBox(height: 40),
                Row(
                  children: [
                    _buildGetStartedButton(context, false),
                    const SizedBox(width: 16),
                    _buildLearnMoreButton(context),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 60),

          // Right side - Logo and visual
          Expanded(
            flex: 2,
            child: Column(
              children: [
                const MultiSalesLogo.large(),
                const SizedBox(height: 24),
                _buildStatsCards(context, true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        children: [
          const MultiSalesLogo.large(),
          const SizedBox(height: 32),
          _buildWelcomeText(context, true),
          const SizedBox(height: 24),
          _buildDescriptionText(context),
          const SizedBox(height: 40),
          _buildStatsCards(context, true),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        children: [
          const MultiSalesLogo.medium(),
          const SizedBox(height: 24),
          _buildWelcomeText(context, false),
          const SizedBox(height: 16),
          _buildDescriptionText(context),
          const SizedBox(height: 32),
          _buildStatsCards(context, false),
        ],
      ),
    );
  }

  Widget _buildWelcomeText(BuildContext context, bool isLarge) {
    final loc = AppLocalizations.of(context)!;
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            loc.welcomeToMultiSales,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: isLarge
                      ? 48
                      : (MediaQuery.of(context).size.width < 360 ? 28 : 32),
                  color: Theme.of(context).primaryColor,
                ),
            textAlign: isLarge ? TextAlign.left : TextAlign.center,
          ),
        );
      },
    );
  }

  Widget _buildDescriptionText(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            loc.welcomeMessage,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.grey[700],
                ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Widget _buildStatsCards(BuildContext context, bool isWide) {
    final loc = AppLocalizations.of(context)!;
    final stats = [
      {'title': '10K+', 'subtitle': loc.activeUsers},
      {'title': '50K+', 'subtitle': loc.ordersProcessed},
      {'title': '99.9%', 'subtitle': loc.uptime},
    ];

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: isWide
              ? Row(
                  children: stats
                      .map((stat) =>
                          Expanded(child: _buildStatCard(context, stat)))
                      .toList(),
                )
              : Column(
                  children: stats
                      .map((stat) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildStatCard(context, stat),
                          ))
                      .toList(),
                ),
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, Map<String, String> stat) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              stat['title']!,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              stat['subtitle']!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(
      BuildContext context, bool isTablet, bool isDesktop) {
    final loc = AppLocalizations.of(context)!;
    final features = [
      {
        'icon': Icons.inventory_2,
        'title': loc.inventoryManagement,
        'description': loc.manageInventoryEfficiently,
      },
      {
        'icon': Icons.analytics,
        'title': loc.salesAnalytics,
        'description': loc.analyzeSalesData,
      },
      {
        'icon': Icons.people,
        'title': loc.customerManagement,
        'description': loc.engageCustomers,
      },
      {
        'icon': Icons.security,
        'title': loc.securePlatform,
        'description': loc.dataProtected,
      },
    ];

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              Text(
                loc.whyChooseMultiSales,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (isDesktop)
                Row(
                  children: features
                      .map((feature) =>
                          Expanded(child: _buildFeatureCard(context, feature)))
                      .toList(),
                )
              else if (isTablet)
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: features
                      .map((feature) => _buildFeatureCard(context, feature))
                      .toList(),
                )
              else
                Column(
                  children: features
                      .map((feature) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildFeatureCard(context, feature),
                          ))
                      .toList(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatureCard(BuildContext context, Map<String, dynamic> feature) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                feature['icon'],
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              feature['title'],
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              feature['description'],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, bool isTablet, bool isDesktop) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              if (isTablet || isDesktop)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildGetStartedButton(context, false),
                    const SizedBox(width: 16),
                    _buildSignInButton(context),
                    const SizedBox(width: 16),
                    _buildLearnMoreButton(context),
                  ],
                )
              else
                Column(
                  children: [
                    _buildGetStartedButton(context, true),
                    const SizedBox(height: 12),
                    _buildSignInButton(context),
                    const SizedBox(height: 12),
                    _buildLearnMoreButton(context),
                  ],
                ),

              const SizedBox(height: 24),

              // Language and region selectors for mobile
              if (!isTablet && !isDesktop)
                Row(
                  children: [
                    Expanded(child: _buildLanguageSelector()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildRegionSelector()),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGetStartedButton(BuildContext context, bool isFullWidth) {
    final loc = AppLocalizations.of(context)!;
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: _isLoading ? null : () => _handleGetStarted(context),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.rocket_launch),
                  const SizedBox(width: 8),
                  Text(
                    loc.getStarted,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return OutlinedButton(
      onPressed: () => _handleSignIn(context),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.login),
          const SizedBox(width: 8),
          Text(
            loc.signIn,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearnMoreButton(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return TextButton(
      onPressed: () => _handleLearnMore(context),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.info_outline),
          const SizedBox(width: 8),
          Text(
            loc.learnMore,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return DropdownButton<String>(
      value: _selectedLanguage,
      isExpanded: true,
      underline: Container(),
      icon: const Icon(Icons.language),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedLanguage = newValue;
          });
          _handleLanguageChange(newValue);
        }
      },
      items: _languages.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildRegionSelector() {
    return DropdownButton<String>(
      value: _selectedRegion,
      isExpanded: true,
      underline: Container(),
      icon: const Icon(Icons.public),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedRegion = newValue;
          });
          _handleRegionChange(newValue);
        }
      },
      items: _regions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  // Event handlers
  Future<void> _handleGetStarted(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    HapticFeedback.mediumImpact();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      NotificationWidget.show(
        this.context,
        title: 'Welcome!',
        message: 'Welcome to MultiSales! Let\'s get you set up.',
        type: NotificationType.success,
      );

      // Navigate to registration/onboarding
      Navigator.pushReplacementNamed(this.context, '/onboarding');
    }
  }

  void _handleSignIn(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/login');
  }

  void _handleLearnMore(BuildContext context) {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const LearnMoreSheet(),
    );
  }

  void _handleLanguageChange(String language) {
    HapticFeedback.selectionClick();

    NotificationWidget.show(
      context,
      title: 'Language Updated',
      message: 'Language changed to $language',
      type: NotificationType.info,
    );

    // Here you would typically update the app's locale
    // Example: Provider.of<LocalizationProvider>(context, listen: false).setLanguage(language);
  }

  void _handleRegionChange(String region) {
    HapticFeedback.selectionClick();

    NotificationWidget.show(
      context,
      title: 'Region Updated',
      message: 'Region set to $region',
      type: NotificationType.info,
    );

    // Here you would typically update region-specific settings
    // Example: currency, date formats, etc.
  }
}

// Custom painter for background pattern
class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.05)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const gridSize = 50.0;

    // Draw grid pattern
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw decorative circles
    final circlePaint = Paint()
      ..color = Colors.blue.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.2),
      50,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.8),
      80,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Learn More bottom sheet
class LearnMoreSheet extends StatelessWidget {
  const LearnMoreSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            AppLocalizations.of(context)?.aboutMultiSales ?? 'About MultiSales',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection(
                    context,
                    AppLocalizations.of(context)?.ourMission ?? 'Our Mission',
                    AppLocalizations.of(context)?.missionStatement ??
                        'To empower sales teams with modern, efficient, and secure tools.',
                    Icons.flag,
                  ),
                  _buildInfoSection(
                    context,
                    AppLocalizations.of(context)?.keyFeatures ?? 'Key Features',
                    AppLocalizations.of(context)?.keyFeaturesDesc ??
                        'Comprehensive analytics, inventory, and customer management.',
                    Icons.star,
                  ),
                  _buildInfoSection(
                    context,
                    AppLocalizations.of(context)?.securityPrivacy ??
                        'Security & Privacy',
                    AppLocalizations.of(context)?.securityPrivacyDesc ??
                        'We prioritize your data security and privacy.',
                    Icons.security,
                  ),
                  _buildInfoSection(
                    context,
                    AppLocalizations.of(context)?.support ?? 'Support',
                    AppLocalizations.of(context)?.supportDesc ??
                        '24/7 support for all users.',
                    Icons.support_agent,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context)?.close ?? 'Close'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/onboarding');
                  },
                  child: Text(AppLocalizations.of(context)?.getStarted ??
                      'Get Started'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
      BuildContext context, String title, String content, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Terms and Privacy Row widget for bottom of welcome screen
class TermsPrivacyRow extends StatelessWidget {
  const TermsPrivacyRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () async {
            const url = 'https://multisales.app/terms';
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url),
                  mode: LaunchMode.externalApplication);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        AppLocalizations.of(context)?.couldNotOpenTerms ??
                            'Could not open Terms of Service')),
              );
            }
          },
          child: Text(AppLocalizations.of(context)?.termsOfService ??
              'Terms of Service'),
        ),
        const Text(' | '),
        TextButton(
          onPressed: () async {
            const url = 'https://multisales.app/privacy';
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url),
                  mode: LaunchMode.externalApplication);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        AppLocalizations.of(context)?.couldNotOpenPrivacy ??
                            'Could not open Privacy Policy')),
              );
            }
          },
          child: Text(
              AppLocalizations.of(context)?.privacyPolicy ?? 'Privacy Policy'),
        ),
      ],
    );
  }
}
