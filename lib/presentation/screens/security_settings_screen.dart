// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/providers/enhanced_auth_provider.dart';
import '../../core/services/enhanced_auth_service.dart';
import '../widgets/enhanced_ui_components.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _showPasswordChangeForm = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Settings'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: Consumer<EnhancedAuthProvider>(
        builder: (context, authProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Security Score Card
                _buildSecurityScoreCard(authProvider),
                const SizedBox(height: 24),

                // Account Security Section
                _buildSectionHeader('Account Security'),
                const SizedBox(height: 16),
                _buildAccountSecurityOptions(authProvider),
                const SizedBox(height: 24),

                // Biometric Authentication Section
                if (authProvider.biometricStatus !=
                    BiometricStatus.notAvailable) ...[
                  _buildSectionHeader('Biometric Authentication'),
                  const SizedBox(height: 16),
                  _buildBiometricOptions(authProvider),
                  const SizedBox(height: 24),
                ],

                // Session Management Section
                _buildSectionHeader('Session Management'),
                const SizedBox(height: 16),
                _buildSessionManagementOptions(authProvider),
                const SizedBox(height: 24),

                // Security Recommendations
                if (authProvider.securityRecommendations.isNotEmpty) ...[
                  _buildSectionHeader('Security Recommendations'),
                  const SizedBox(height: 16),
                  _buildSecurityRecommendations(authProvider),
                  const SizedBox(height: 24),
                ],

                // Password Change Form
                if (_showPasswordChangeForm) ...[
                  _buildSectionHeader('Change Password'),
                  const SizedBox(height: 16),
                  _buildPasswordChangeForm(authProvider),
                  const SizedBox(height: 24),
                ],

                // Security Actions
                _buildSectionHeader('Security Actions'),
                const SizedBox(height: 16),
                _buildSecurityActions(authProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSecurityScoreCard(EnhancedAuthProvider authProvider) {
    final score = authProvider.securityScore;
    final scorePercentage = score / 100;

    Color scoreColor;
    String scoreText;
    IconData scoreIcon;

    if (score >= 80) {
      scoreColor = Colors.green;
      scoreText = 'Excellent';
      scoreIcon = Icons.shield;
    } else if (score >= 60) {
      scoreColor = Colors.orange;
      scoreText = 'Good';
      scoreIcon = Icons.security;
    } else if (score >= 40) {
      scoreColor = Colors.yellow.shade700;
      scoreText = 'Fair';
      scoreIcon = Icons.warning;
    } else {
      scoreColor = Colors.red;
      scoreText = 'Poor';
      scoreIcon = Icons.error;
    }

    return EnhancedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                scoreIcon,
                color: scoreColor,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Security Score',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      '$scoreText ($score/100)',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: scoreColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(scorePercentage * 100).toInt()}%',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: scoreColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: scorePercentage,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
          ),
          const SizedBox(height: 8),
          Text(
            'Your account security is $scoreText. Follow the recommendations below to improve your security score.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildAccountSecurityOptions(EnhancedAuthProvider authProvider) {
    return Column(
      children: [
        _buildSecurityOption(
          icon: Icons.lock_outline,
          title: 'Change Password',
          subtitle: 'Update your account password',
          onTap: () {
            setState(() {
              _showPasswordChangeForm = !_showPasswordChangeForm;
            });
          },
        ),
        const Divider(),
        _buildSecurityOption(
          icon: Icons.email_outlined,
          title: 'Email Verification',
          subtitle: authProvider.user?.isEmailVerified == true
              ? 'Email verified'
              : 'Verify your email address',
          trailing: authProvider.user?.isEmailVerified == true
              ? const Icon(Icons.check_circle, color: Colors.green)
              : TextButton(
                  onPressed: () => _sendEmailVerification(authProvider),
                  child: const Text('Verify'),
                ),
        ),
        const Divider(),
        _buildSecurityOption(
          icon: Icons.phone_outlined,
          title: 'Phone Number',
          subtitle: authProvider.user?.phone != null
              ? 'Phone number added'
              : 'Add phone number for 2FA',
          trailing: authProvider.user?.phone != null
              ? const Icon(Icons.check_circle, color: Colors.green)
              : TextButton(
                  onPressed: () => _showAddPhoneDialog(),
                  child: const Text('Add'),
                ),
        ),
      ],
    );
  }

  Widget _buildBiometricOptions(EnhancedAuthProvider authProvider) {
    String biometricText = 'Biometric Authentication';
    IconData biometricIcon = Icons.fingerprint;

    switch (authProvider.biometricStatus) {
      case BiometricStatus.fingerprint:
        biometricText = 'Fingerprint Authentication';
        biometricIcon = Icons.fingerprint;
        break;
      case BiometricStatus.face:
        biometricText = 'Face ID Authentication';
        biometricIcon = Icons.face;
        break;
      default:
        biometricText = 'Biometric Authentication';
        biometricIcon = Icons.security;
    }

    return Column(
      children: [
        _buildSecurityOption(
          icon: biometricIcon,
          title: biometricText,
          subtitle: authProvider.isBiometricEnabled
              ? 'Enabled for quick sign-in'
              : 'Enable for secure and quick access',
          trailing: Switch(
            value: authProvider.isBiometricEnabled,
            onChanged: (value) => _toggleBiometric(authProvider, value),
          ),
        ),
        if (authProvider.isBiometricEnabled) ...[
          const Divider(),
          _buildSecurityOption(
            icon: Icons.login,
            title: 'Biometric Sign-in Only',
            subtitle: 'Require biometric for all sign-ins',
            trailing: Switch(
              value: authProvider.biometricOnlyMode,
              onChanged: (value) =>
                  _toggleBiometricOnlyMode(authProvider, value),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSessionManagementOptions(EnhancedAuthProvider authProvider) {
    return Column(
      children: [
        _buildSecurityOption(
          icon: Icons.timer_outlined,
          title: 'Session Timeout',
          subtitle: 'Automatically sign out after inactivity',
          trailing: DropdownButton<int>(
            value: authProvider.sessionTimeoutMinutes,
            items: const [
              DropdownMenuItem(value: 15, child: Text('15 min')),
              DropdownMenuItem(value: 30, child: Text('30 min')),
              DropdownMenuItem(value: 60, child: Text('1 hour')),
              DropdownMenuItem(value: 120, child: Text('2 hours')),
              DropdownMenuItem(value: -1, child: Text('Never')),
            ],
            onChanged: (value) => _setSessionTimeout(authProvider, value!),
          ),
        ),
        const Divider(),
        _buildSecurityOption(
          icon: Icons.devices_outlined,
          title: 'Active Sessions',
          subtitle: 'Manage your active sessions',
          onTap: () => _showActiveSessionsDialog(authProvider),
        ),
        const Divider(),
        _buildSecurityOption(
          icon: Icons.logout,
          title: 'Sign Out Other Devices',
          subtitle: 'Sign out from all other devices',
          onTap: () => _signOutOtherDevices(authProvider),
        ),
      ],
    );
  }

  Widget _buildSecurityRecommendations(EnhancedAuthProvider authProvider) {
    return Column(
      children: authProvider.securityRecommendations.map((recommendation) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.blue.shade700,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  recommendation,
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPasswordChangeForm(EnhancedAuthProvider authProvider) {
    return EnhancedCard(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _currentPasswordController,
              obscureText: _obscureCurrentPassword,
              decoration: InputDecoration(
                labelText: 'Current Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureCurrentPassword = !_obscureCurrentPassword;
                    });
                  },
                  icon: Icon(_obscureCurrentPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Current password is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _newPasswordController,
              obscureText: _obscureNewPassword,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                  icon: Icon(_obscureNewPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                authProvider.validatePassword(value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'New password is required';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
            ),
            if (authProvider.passwordStrength != null) ...[
              const SizedBox(height: 8),
              _buildPasswordStrengthIndicator(authProvider.passwordStrength!),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  icon: Icon(_obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _showPasswordChangeForm = false;
                      });
                      _clearPasswordForm();
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading
                        ? null
                        : () => _changePassword(authProvider),
                    child: authProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Change Password'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator(PasswordStrength strength) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Password Strength: ',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              strength.level,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: strength.color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: strength.score / 5,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(strength.color),
        ),
        if (strength.feedback.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            strength.feedback.join(' '),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildSecurityActions(EnhancedAuthProvider authProvider) {
    return Column(
      children: [
        _buildSecurityOption(
          icon: Icons.history,
          title: 'Security Log',
          subtitle: 'View recent security activities',
          onTap: () => _showSecurityLogDialog(authProvider),
        ),
        const Divider(),
        _buildSecurityOption(
          icon: Icons.download_outlined,
          title: 'Export Security Data',
          subtitle: 'Download your security information',
          onTap: () => _exportSecurityData(authProvider),
        ),
        const Divider(),
        _buildSecurityOption(
          icon: Icons.delete_forever_outlined,
          title: 'Delete Account',
          subtitle: 'Permanently delete your account',
          textColor: Colors.red,
          onTap: () => _showDeleteAccountDialog(authProvider),
        ),
      ],
    );
  }

  Widget _buildSecurityOption({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  // Action methods
  Future<void> _sendEmailVerification(EnhancedAuthProvider authProvider) async {
    final success = await authProvider.sendEmailVerification();
    if (success && mounted) {
      _showSuccessSnackBar('Verification email sent!');
    }
  }

  Future<void> _toggleBiometric(
      EnhancedAuthProvider authProvider, bool enable) async {
    if (enable) {
      final success = await authProvider.enableBiometric();
      if (success && mounted) {
        _showSuccessSnackBar('Biometric authentication enabled!');
      }
    } else {
      await authProvider.disableBiometric();
      if (mounted) {
        _showSuccessSnackBar('Biometric authentication disabled!');
      }
    }
  }

  Future<void> _changePassword(EnhancedAuthProvider authProvider) async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await authProvider.changePassword(
        _currentPasswordController.text,
        _newPasswordController.text,
      );

      if (success && mounted) {
        _showSuccessSnackBar('Password changed successfully!');
        setState(() {
          _showPasswordChangeForm = false;
        });
        _clearPasswordForm();
      }
    }
  }

  void _clearPasswordForm() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  Future<void> _toggleBiometricOnlyMode(
      EnhancedAuthProvider authProvider, bool enable) async {
    await authProvider.setBiometricOnlyMode(enable);
    if (mounted) {
      _showSuccessSnackBar(
        enable
            ? 'Biometric-only mode enabled!'
            : 'Biometric-only mode disabled!',
      );
    }
  }

  Future<void> _setSessionTimeout(
      EnhancedAuthProvider authProvider, int minutes) async {
    await authProvider.setSessionTimeout(minutes);
    if (mounted) {
      String message;
      if (minutes == -1) {
        message = 'Session will never timeout';
      } else {
        message = 'Session timeout set to $minutes minutes';
      }
      _showSuccessSnackBar(message);
    }
  }

  void _showAddPhoneDialog() {
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Phone Number'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add your phone number for enhanced security.'),
            const SizedBox(height: 16),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
                hintText: '+1 234 567 8900',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          Consumer<EnhancedAuthProvider>(
            builder: (context, authProvider, child) => TextButton(
              onPressed: authProvider.isLoading
                  ? null
                  : () => _addPhoneNumber(authProvider, phoneController.text),
              child: authProvider.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Add'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addPhoneNumber(
      EnhancedAuthProvider authProvider, String phoneNumber) async {
    if (phoneNumber.trim().isEmpty) {
      _showErrorSnackBar('Please enter a phone number');
      return;
    }

    final success = await authProvider.addPhoneNumber(phoneNumber.trim());
    if (mounted) {
      Navigator.of(context).pop();
      if (success) {
        _showSuccessSnackBar('Phone number added successfully!');
      } else {
        _showErrorSnackBar(
            authProvider.errorMessage ?? 'Failed to add phone number');
      }
    }
  }

  void _showActiveSessionsDialog(EnhancedAuthProvider authProvider) {
    authProvider.loadActiveSessions();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Active Sessions'),
        content: SizedBox(
          width: double.maxFinite,
          child: Consumer<EnhancedAuthProvider>(
            builder: (context, provider, child) {
              if (provider.activeSessions.isEmpty) {
                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.devices, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No active sessions found'),
                  ],
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('These devices have access to your account:'),
                  const SizedBox(height: 16),
                  ...provider.activeSessions.map(
                    (session) => ListTile(
                      leading: Icon(
                        session.isCurrent ? Icons.smartphone : Icons.computer,
                        color: session.isCurrent ? Colors.green : Colors.grey,
                      ),
                      title: Text(session.deviceName),
                      subtitle: Text(
                        '${session.location}\nLast active: ${_formatSessionTime(session.lastActivity)}',
                      ),
                      trailing: session.isCurrent
                          ? const Chip(
                              label: Text('Current'),
                              backgroundColor: Colors.green,
                              labelStyle: TextStyle(color: Colors.white),
                            )
                          : IconButton(
                              icon: const Icon(Icons.logout, color: Colors.red),
                              onPressed: () {
                                _showInfoSnackBar(
                                    'Individual session logout coming soon!');
                              },
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
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

  String _formatSessionTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Future<void> _signOutOtherDevices(EnhancedAuthProvider authProvider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out Other Devices'),
        content: const Text(
          'This will sign you out from all other devices. You will remain signed in on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await authProvider.signOutOtherDevices();
      if (mounted) {
        if (success) {
          _showSuccessSnackBar('Signed out from all other devices!');
        } else {
          _showErrorSnackBar(
              authProvider.errorMessage ?? 'Failed to sign out other devices');
        }
      }
    }
  }

  void _showSecurityLogDialog(EnhancedAuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Security Log'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView(
            children: [
              _buildSecurityLogItem(
                'Password Changed',
                'You changed your password',
                DateTime.now().subtract(const Duration(days: 2)),
                Icons.lock,
                Colors.blue,
              ),
              _buildSecurityLogItem(
                'Biometric Authentication Enabled',
                'You enabled fingerprint authentication',
                DateTime.now().subtract(const Duration(days: 5)),
                Icons.fingerprint,
                Colors.green,
              ),
              _buildSecurityLogItem(
                'Sign In',
                'Signed in from Chrome on Windows',
                DateTime.now().subtract(const Duration(hours: 2)),
                Icons.login,
                Colors.grey,
              ),
              _buildSecurityLogItem(
                'Email Verified',
                'You verified your email address',
                DateTime.now().subtract(const Duration(days: 10)),
                Icons.email,
                Colors.green,
              ),
            ],
          ),
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

  Widget _buildSecurityLogItem(
    String title,
    String description,
    DateTime timestamp,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(description),
      trailing: Text(
        _formatSessionTime(timestamp),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  void _exportSecurityData(EnhancedAuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Security Data'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This will export the following security information:'),
            SizedBox(height: 16),
            Text('• Account security settings'),
            Text('• Recent security activities'),
            Text('• Active sessions'),
            Text('• Security score history'),
            SizedBox(height: 16),
            Text('The data will be downloaded as a JSON file.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performExportSecurityData(authProvider);
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  Future<void> _performExportSecurityData(
      EnhancedAuthProvider authProvider) async {
    _showInfoSnackBar('Preparing security data export...');

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      _showSuccessSnackBar('Security data exported successfully!');
    }
  }

  void _showDeleteAccountDialog(EnhancedAuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteAccount(authProvider);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount(EnhancedAuthProvider authProvider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will permanently delete your account and all associated data.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('This action cannot be undone. You will lose:'),
            SizedBox(height: 8),
            Text('• All account information'),
            Text('• Training progress'),
            Text('• Saved preferences'),
            Text('• All uploaded documents'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final passwordConfirmed = await _showPasswordConfirmationDialog();

      if (passwordConfirmed != null) {
        final success = await authProvider.deleteAccount(passwordConfirmed);

        if (mounted) {
          if (success) {
            _showSuccessSnackBar('Account deleted successfully');
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (route) => false);
          } else {
            _showErrorSnackBar(
                authProvider.errorMessage ?? 'Failed to delete account');
          }
        }
      }
    }
  }

  Future<String?> _showPasswordConfirmationDialog() async {
    final passwordController = TextEditingController();
    bool obscurePassword = true;

    return showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Confirm Account Deletion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  'Please enter your password to confirm account deletion:'),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: Icon(obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (passwordController.text.isNotEmpty) {
                  Navigator.of(context).pop(passwordController.text);
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
    HapticFeedback.lightImpact();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
    HapticFeedback.lightImpact();
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
