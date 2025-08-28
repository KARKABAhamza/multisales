// ignore_for_file: use_build_context_synchronously

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/analytics_service.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/auth_screen.dart';
import '../../presentation/screens/enhanced_auth_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/enhanced_dashboard_screen.dart';
import '../../presentation/screens/enhanced_profile_screen.dart';
import '../../presentation/screens/security_settings_screen.dart';
import '../../presentation/screens/task_screen.dart';
import '../../presentation/screens/meeting_screen.dart';
import '../../presentation/widgets/auth_wrapper.dart';

class AppRouter {
  // Helper method to check authentication state
  static String? _handleAuthRedirect(
      BuildContext context, GoRouterState state) {
    // Get the current route path
    final String location = state.uri.path;

    // Public routes that don't require authentication
    const publicRoutes = ['/login', '/auth'];

    // If it's a public route, allow access
    if (publicRoutes.contains(location)) {
      return null;
    }

    try {
      // Try to get the auth provider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // If user is not authenticated, redirect to login
      if (!authProvider.isAuthenticated) {
        return '/login';
      }

      // If user is authenticated but hasn't completed onboarding, redirect to onboarding
      if (!authProvider.hasCompletedOnboarding) {
        // Don't redirect if already on onboarding route
        if (!location.startsWith('/onboarding')) {
          return '/onboarding';
        }
      }

      // If user is authenticated and onboarding is complete, but on login page, redirect to home
      if (location == '/login' && authProvider.isAuthenticated) {
        return '/home';
      }
    } catch (e) {
      // If there's an error accessing auth provider (e.g., not initialized yet)
      // Allow access to root route which will handle auth wrapper
      if (location != '/') {
        return '/';
      }
    }

    // Allow access to the requested route
    return null;
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    observers: [
      AnalyticsService().observer,
    ],
    routes: [
      // Root route - Auth wrapper that decides between login and home
      GoRoute(
        path: '/',
        name: 'root',
        builder: (context, state) => const AuthWrapper(),
      ),

      // Login route
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Enhanced Authentication route (sign-in and sign-up)
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),

      // Enhanced Authentication route (modern UI)
      GoRoute(
        path: '/enhanced-auth',
        name: 'enhanced-auth',
        builder: (context, state) => const EnhancedAuthScreen(),
      ),

      // Home route (protected)
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Enhanced Dashboard route (protected)
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const EnhancedDashboardScreen(),
      ),

      // Onboarding routes
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final role = extra?['role'] as String?;
          return OnboardingScreen(role: role);
        },
        routes: [
          GoRoute(
            path: 'step/:stepId',
            name: 'onboarding-step',
            builder: (context, state) {
              final stepId = state.pathParameters['stepId']!;
              return OnboardingStepScreen(stepId: stepId);
            },
          ),
        ],
      ),

      // Training routes (protected)
      GoRoute(
        path: '/training',
        name: 'training',
        builder: (context, state) => const TrainingScreen(),
        routes: [
          GoRoute(
            path: 'module/:moduleId',
            name: 'training-module',
            builder: (context, state) {
              final moduleId = state.pathParameters['moduleId']!;
              return TrainingModuleScreen(moduleId: moduleId);
            },
          ),
        ],
      ),

      // Profile routes (protected)
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const EnhancedProfileScreen(),
        routes: [
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: 'security',
            name: 'security-settings',
            builder: (context, state) => const SecuritySettingsScreen(),
          ),
          GoRoute(
            path: 'edit',
            name: 'edit-profile',
            builder: (context, state) => const EditProfileScreen(),
          ),
        ],
      ),

      // Notifications route (protected)
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Task route (protected)
      GoRoute(
        path: '/task',
        name: 'task',
        builder: (context, state) => const TaskScreen(),
      ),

      // Meeting route (protected)
      GoRoute(
        path: '/meeting',
        name: 'meeting',
        builder: (context, state) => const MeetingScreen(),
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => ErrorScreen(error: state.error),

    // Redirect logic with authentication checks
    redirect: (context, state) {
      return _handleAuthRedirect(context, state);
    },
  );
}

class OnboardingScreen extends StatelessWidget {
  final String? role;

  const OnboardingScreen({super.key, this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.assignment, size: 64),
            const SizedBox(height: 16),
            Text('Onboarding for: ${role ?? 'Unknown Role'}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Complete Onboarding'),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingStepScreen extends StatelessWidget {
  final String stepId;

  const OnboardingStepScreen({super.key, required this.stepId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Step: $stepId')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Onboarding Step: $stepId'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Back to Onboarding'),
            ),
          ],
        ),
      ),
    );
  }
}

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Training')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 64),
            SizedBox(height: 16),
            Text('Training Modules', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Text('Select a training module to get started.'),
          ],
        ),
      ),
    );
  }
}

class TrainingModuleScreen extends StatelessWidget {
  final String moduleId;

  const TrainingModuleScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Module: $moduleId')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Training Module: $moduleId'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Back to Training'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 64),
            SizedBox(height: 16),
            Text('User Profile', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Text('Manage your account settings.'),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 64),
            SizedBox(height: 16),
            Text('Settings', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Text('Configure your preferences.'),
          ],
        ),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final Exception? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Something went wrong!', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            Text(error?.toString() ?? 'Unknown error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}

// Additional placeholder screens
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit, size: 64),
            SizedBox(height: 16),
            Text('Edit Profile', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Text('Update your profile information.'),
          ],
        ),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications, size: 64),
            SizedBox(height: 16),
            Text('Notifications', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Text('Stay updated with the latest news.'),
          ],
        ),
      ),
    );
  }
}
