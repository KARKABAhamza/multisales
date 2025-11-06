import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// Core Authentication
import '../../presentation/screens/login_screen.dart';

// Existing Screens
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';

// Providers

/// Simplified routing configuration for MultiSales app
/// This version includes only existing screens and working routes
class SimpleAppRouter {
  static GoRouter createRouter(OptimizedAuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/splash',
      redirect: (context, state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final currentPath = state.uri.path;

        // Handle authentication redirects
        if (!isAuthenticated) {
          if (currentPath != '/auth' && currentPath != '/splash') {
            return '/auth';
          }
          return null;
        }

        // Redirect authenticated users from auth screens
        if (isAuthenticated) {
          if (currentPath == '/auth' || currentPath == '/splash') {
            return '/home';
          }
        }

        return null;
      },
      routes: [
        // Splash Screen
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),

        // Authentication Routes
        GoRoute(
          path: '/contact',
          name: 'contact',
          builder: (context, state) => const ContactScreen(),
        ),

        // Home Route - Placeholder for now
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),

        // Settings Route - Placeholder for now
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Page not found: ${state.error}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OptimizedAuthProvider with ChangeNotifier {
  // Existing fields and methods

  bool get isAuthenticated => _isAuthenticated ?? false;

  bool? _isAuthenticated;
  // Make sure to update _isAuthenticated appropriately in your logic
}
