// lib/core/providers/provider_integration_example.dart

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'optimized_auth_provider.dart';

/// Example showing how to integrate the OptimizedAuthProvider with existing code
class AuthIntegrationExample extends StatelessWidget {
  const AuthIntegrationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OptimizedAuthProvider>(
      builder: (context, authProvider, child) {
        // Show loading state
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Authenticating...'),
                ],
              ),
            ),
          );
        }

        // Show error state
        if (authProvider.errorMessage != null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    authProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => authProvider.clearError(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        // Show authenticated state
        if (authProvider.isAuthenticated) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                  'Welcome ${authProvider.userModel?.firstName ?? 'User'}'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => authProvider.signOut(),
                ),
              ],
            ),
            body: _buildUserProfile(authProvider),
          );
        }

        // Show login form
        return _buildLoginForm(authProvider);
      },
    );
  }

  Widget _buildUserProfile(OptimizedAuthProvider authProvider) {
    final user = authProvider.userModel;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(user?.firstName.substring(0, 1) ?? 'U'),
              ),
              title: Text('${user?.firstName ?? ''} ${user?.lastName ?? ''}'),
              subtitle: Text(user?.email ?? ''),
              trailing: Icon(Icons.verified,
                  color: user?.isEmailVerified == true
                      ? Colors.green
                      : Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Account Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildInfoRow('Role', user?.role ?? 'Unknown'),
          _buildInfoRow('Account Type', user?.accountType ?? 'Basic'),
          _buildInfoRow(
              'Created', user?.createdAt.toString().split(' ')[0] ?? 'Unknown'),
          _buildInfoRow('Last Login',
              user?.lastLoginAt?.toString().split(' ')[0] ?? 'Never'),
          const SizedBox(height: 16),

          // Performance metrics (debug only)
          if (kDebugMode) ...[
            const Text('Performance Metrics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildPerformanceCard(authProvider),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(OptimizedAuthProvider authProvider) {
    final metrics = authProvider.getPerformanceMetrics();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Performance Data',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Operations: ${metrics['operation_timestamps']?.length ?? 0}'),
            Text(
                'User Loaded: ${metrics['current_state']?['user_loaded'] ?? false}'),
            Text(
                'Is Loading: ${metrics['current_state']?['is_loading'] ?? false}'),
            Text(
                'Has Error: ${metrics['current_state']?['has_error'] ?? false}'),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(OptimizedAuthProvider authProvider) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();

                  if (email.isNotEmpty && password.isNotEmpty) {
                    await authProvider.signIn(email, password);
                  }
                },
                child: const Text('Sign In'),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Navigate to registration screen
                // This is where you'd implement navigation to your registration screen
              },
              child: const Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper class to demonstrate usage patterns
class AuthUsageExamples {
  /// Example: Check authentication status
  static bool checkAuthStatus(BuildContext context) {
    final authProvider = context.read<OptimizedAuthProvider>();
    return authProvider.isAuthenticated;
  }

  /// Example: Sign in with error handling
  static Future<bool> signInExample(
      BuildContext context, String email, String password) async {
    final authProvider = context.read<OptimizedAuthProvider>();

    try {
      final success = await authProvider.signIn(email, password);

      if (!success && authProvider.errorMessage != null) {
        // Handle specific error cases
        _showErrorSnackBar(context, authProvider.errorMessage!);
      }

      return success;
    } catch (e) {
      _showErrorSnackBar(context, 'An unexpected error occurred');
      return false;
    }
  }

  /// Example: Register new user
  static Future<bool> registerExample(
    BuildContext context, {
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? role,
  }) async {
    final authProvider = context.read<OptimizedAuthProvider>();

    final success = await authProvider.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      role: role,
    );

    if (success) {
      _showSuccessSnackBar(context, 'Account created successfully!');
    } else if (authProvider.errorMessage != null) {
      _showErrorSnackBar(context, authProvider.errorMessage!);
    }

    return success;
  }

  /// Example: Sign out with confirmation
  static Future<void> signOutExample(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (result == true) {
      final authProvider = context.read<OptimizedAuthProvider>();
      await authProvider.signOut();
      _showSuccessSnackBar(context, 'Signed out successfully');
    }
  }

  /// Example: Reset password
  static Future<void> resetPasswordExample(
    BuildContext context,
    String email,
  ) async {
    final authProvider = context.read<OptimizedAuthProvider>();

    final success = await authProvider.resetPassword(email);

    if (success) {
      _showSuccessSnackBar(context, 'Password reset email sent!');
    } else if (authProvider.errorMessage != null) {
      _showErrorSnackBar(context, authProvider.errorMessage!);
    }
  }

  /// Example: Optimize memory usage
  static void optimizeMemoryExample(BuildContext context) {
    final authProvider = context.read<OptimizedAuthProvider>();
    authProvider.optimizeMemory();
  }

  /// Example: Get performance metrics
  static Map<String, dynamic> getPerformanceExample(BuildContext context) {
    final authProvider = context.read<OptimizedAuthProvider>();
    return authProvider.getPerformanceMetrics();
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  static void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}
