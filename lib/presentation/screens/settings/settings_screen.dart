import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/enhanced_ui_components.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Notification settings
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = false;
  bool _orderUpdates = true;
  bool _promotionalOffers = false;
  bool _securityAlerts = true;

  // Privacy settings
  bool _shareUsageData = false;
  bool _personalizedAds = false;
  bool _locationTracking = false;

  // App settings
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'USD';
  String _selectedTheme = 'System';
  bool _biometricLogin = false;
  bool _autoLogout = true;

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Arabic',
  ];

  final List<String> _currencies = [
    'USD',
    'EUR',
    'GBP',
    'CAD',
    'AUD',
  ];

  final List<String> _themes = [
    'Light',
    'Dark',
    'System',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            title: 'Account',
            icon: Icons.person,
            children: [
              _buildListTile(
                icon: Icons.edit,
                title: 'Edit Profile',
                subtitle: 'Update your personal information',
                onTap: () => _navigateToProfile(),
              ),
              _buildListTile(
                icon: Icons.security,
                title: 'Security',
                subtitle: 'Password, 2FA, and login settings',
                onTap: () => _navigateToSecurity(),
              ),
              _buildListTile(
                icon: Icons.payment,
                title: 'Payment Methods',
                subtitle: 'Manage your payment options',
                onTap: () => _navigateToPayments(),
              ),
              _buildListTile(
                icon: Icons.location_on,
                title: 'Addresses',
                subtitle: 'Manage shipping and billing addresses',
                onTap: () => _navigateToAddresses(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Notifications',
            icon: Icons.notifications,
            children: [
              _buildSwitchTile(
                icon: Icons.phone_android,
                title: 'Push Notifications',
                subtitle: 'Receive notifications on your device',
                value: _pushNotifications,
                onChanged: (value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                  _updateNotificationSettings();
                },
              ),
              _buildSwitchTile(
                icon: Icons.email,
                title: 'Email Notifications',
                subtitle: 'Receive notifications via email',
                value: _emailNotifications,
                onChanged: (value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                  _updateNotificationSettings();
                },
              ),
              _buildSwitchTile(
                icon: Icons.sms,
                title: 'SMS Notifications',
                subtitle: 'Receive notifications via text message',
                value: _smsNotifications,
                onChanged: (value) {
                  setState(() {
                    _smsNotifications = value;
                  });
                  _updateNotificationSettings();
                },
              ),
              const Divider(),
              _buildSwitchTile(
                icon: Icons.shopping_bag,
                title: 'Order Updates',
                subtitle: 'Notifications about your orders',
                value: _orderUpdates,
                onChanged: (value) {
                  setState(() {
                    _orderUpdates = value;
                  });
                },
              ),
              _buildSwitchTile(
                icon: Icons.local_offer,
                title: 'Promotional Offers',
                subtitle: 'Special deals and discounts',
                value: _promotionalOffers,
                onChanged: (value) {
                  setState(() {
                    _promotionalOffers = value;
                  });
                },
              ),
              _buildSwitchTile(
                icon: Icons.shield,
                title: 'Security Alerts',
                subtitle: 'Important security notifications',
                value: _securityAlerts,
                onChanged: (value) {
                  setState(() {
                    _securityAlerts = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Privacy',
            icon: Icons.privacy_tip,
            children: [
              _buildSwitchTile(
                icon: Icons.analytics,
                title: 'Share Usage Data',
                subtitle: 'Help improve the app by sharing usage data',
                value: _shareUsageData,
                onChanged: (value) {
                  setState(() {
                    _shareUsageData = value;
                  });
                },
              ),
              _buildSwitchTile(
                icon: Icons.ads_click,
                title: 'Personalized Ads',
                subtitle: 'Show ads based on your interests',
                value: _personalizedAds,
                onChanged: (value) {
                  setState(() {
                    _personalizedAds = value;
                  });
                },
              ),
              _buildSwitchTile(
                icon: Icons.location_on,
                title: 'Location Tracking',
                subtitle: 'Allow location-based features',
                value: _locationTracking,
                onChanged: (value) {
                  setState(() {
                    _locationTracking = value;
                  });
                },
              ),
              _buildListTile(
                icon: Icons.description,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                onTap: () => _openPrivacyPolicy(),
              ),
              _buildListTile(
                icon: Icons.article,
                title: 'Terms of Service',
                subtitle: 'Read our terms of service',
                onTap: () => _openTermsOfService(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'App Preferences',
            icon: Icons.settings,
            children: [
              _buildDropdownTile(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'Choose your preferred language',
                value: _selectedLanguage,
                items: _languages,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                  _updateLanguage(value);
                },
              ),
              _buildDropdownTile(
                icon: Icons.attach_money,
                title: 'Currency',
                subtitle: 'Choose your preferred currency',
                value: _selectedCurrency,
                items: _currencies,
                onChanged: (value) {
                  setState(() {
                    _selectedCurrency = value;
                  });
                  _updateCurrency(value);
                },
              ),
              _buildDropdownTile(
                icon: Icons.palette,
                title: 'Theme',
                subtitle: 'Choose your preferred theme',
                value: _selectedTheme,
                items: _themes,
                onChanged: (value) {
                  setState(() {
                    _selectedTheme = value;
                  });
                  _updateTheme(value);
                },
              ),
              _buildSwitchTile(
                icon: Icons.fingerprint,
                title: 'Biometric Login',
                subtitle: 'Use fingerprint or face ID to login',
                value: _biometricLogin,
                onChanged: (value) {
                  setState(() {
                    _biometricLogin = value;
                  });
                  _updateBiometricLogin(value);
                },
              ),
              _buildSwitchTile(
                icon: Icons.timer,
                title: 'Auto Logout',
                subtitle: 'Automatically logout after inactivity',
                value: _autoLogout,
                onChanged: (value) {
                  setState(() {
                    _autoLogout = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Support',
            icon: Icons.help,
            children: [
              _buildListTile(
                icon: Icons.help_center,
                title: 'Help Center',
                subtitle: 'Find answers to common questions',
                onTap: () => _openHelpCenter(),
              ),
              _buildListTile(
                icon: Icons.chat,
                title: 'Contact Support',
                subtitle: 'Get help from our support team',
                onTap: () => _contactSupport(),
              ),
              _buildListTile(
                icon: Icons.bug_report,
                title: 'Report a Bug',
                subtitle: 'Help us improve the app',
                onTap: () => _reportBug(),
              ),
              _buildListTile(
                icon: Icons.rate_review,
                title: 'Rate the App',
                subtitle: 'Leave a review on the app store',
                onTap: () => _rateApp(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'About',
            icon: Icons.info,
            children: [
              _buildListTile(
                icon: Icons.info_outline,
                title: 'App Version',
                subtitle: 'Version 1.0.0 (Build 100)',
                onTap: () => _showVersionInfo(),
              ),
              _buildListTile(
                icon: Icons.update,
                title: 'Check for Updates',
                subtitle: 'Get the latest features and fixes',
                onTap: () => _checkForUpdates(),
              ),
              _buildListTile(
                icon: Icons.description,
                title: 'Licenses',
                subtitle: 'Open source licenses',
                onTap: () => _showLicenses(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Account Actions',
            icon: Icons.warning,
            children: [
              _buildListTile(
                icon: Icons.download,
                title: 'Export Data',
                subtitle: 'Download your account data',
                onTap: () => _exportData(),
              ),
              _buildListTile(
                icon: Icons.logout,
                title: 'Sign Out',
                subtitle: 'Sign out from your account',
                onTap: () => _signOut(),
                textColor: Colors.orange,
              ),
              _buildListTile(
                icon: Icons.delete_forever,
                title: 'Delete Account',
                subtitle: 'Permanently delete your account',
                onTap: () => _deleteAccount(),
                textColor: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return EnhancedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? Colors.grey[600],
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(
        icon,
        color: Colors.grey[600],
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.grey[600],
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: value,
            isExpanded: true,
            onChanged: (newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Navigation methods
  void _navigateToProfile() {
    Navigator.of(context).pushNamed('/account');
  }

  void _navigateToSecurity() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening security settings...')),
    );
  }

  void _navigateToPayments() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening payment methods...')),
    );
  }

  void _navigateToAddresses() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening address book...')),
    );
  }

  void _openHelpCenter() {
    Navigator.of(context).pushNamed('/support');
  }

  void _contactSupport() {
    Navigator.of(context).pushNamed('/support');
  }

  void _reportBug() {
    _showFeedbackDialog('Report a Bug', 'Describe the bug you encountered');
  }

  void _rateApp() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening app store...')),
    );
  }

  void _openPrivacyPolicy() {
    _showTextDialog(
      'Privacy Policy',
      'This is where the privacy policy content would be displayed. '
          'It would include information about data collection, usage, '
          'and user rights.',
    );
  }

  void _openTermsOfService() {
    _showTextDialog(
      'Terms of Service',
      'This is where the terms of service content would be displayed. '
          'It would include the legal terms and conditions for using the app.',
    );
  }

  void _showVersionInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('App Version'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MultiSales App'),
            SizedBox(height: 8),
            Text('Version: 1.0.0'),
            Text('Build: 100'),
            Text('Release Date: January 2024'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _checkForUpdates() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Checking for updates...')),
    );
  }

  void _showLicenses() {
    showLicensePage(context: context);
  }

  void _exportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text(
          'Your account data will be exported and sent to your email address. '
          'This may take a few minutes to process.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data export started...')),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              HapticFeedback.lightImpact();
              // Perform sign out
              Navigator.of(context).pushReplacementNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? '
          'This action cannot be undone and all your data will be permanently lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _confirmDeleteAccount();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Final Confirmation'),
        content: const Text(
          'Type "DELETE" to confirm account deletion:',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              HapticFeedback.heavyImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion initiated...')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm Delete'),
          ),
        ],
      ),
    );
  }

  void _showTextDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(content),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(String title, String hint) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Feedback submitted!')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  // Settings update methods
  void _updateNotificationSettings() {
    HapticFeedback.lightImpact();
    // Save notification settings
  }

  void _updateLanguage(String language) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Language changed to $language')),
    );
  }

  void _updateCurrency(String currency) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Currency changed to $currency')),
    );
  }

  void _updateTheme(String theme) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Theme changed to $theme')),
    );
  }

  void _updateBiometricLogin(bool enabled) {
    HapticFeedback.lightImpact();
    if (enabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric login enabled')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric login disabled')),
      );
    }
  }
}
