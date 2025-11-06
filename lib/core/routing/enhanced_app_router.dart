import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../providers/optimized_auth_provider.dart';

// Authentication - Using existing screens
import '../../presentation/screens/enhanced_auth_screen.dart';

// Main App Structure - Using existing screens
import '../../presentation/screens/home_screen.dart';
// Removed broken import for SettingsScreen (file does not exist)

// Communication - Using existing screens
// Removed broken import for ChatScreen (file does not exist)

// Support - Using existing screens
// Removed broken import for SupportScreen (file does not exist)

// Orders - Using existing screens
// Removed broken import for OrdersScreen (file does not exist)

// Maps & Location - New feature screens
// Removed broken import for LocationTrackingScreen (file does not exist)
// Removed broken import for TerritoryMapScreen (file does not exist)

// Promotions - New feature screens
// Removed broken import for PromotionsListScreen (file does not exist)

// Feedback - New feature screens
// Removed broken import for FeedbackListScreen (file does not exist)

// Sales Dashboard - New feature screens
// Removed broken import for SalesDashboardScreen (file does not exist)

// Document Management - New feature screens
// Removed broken import for DocumentManagementScreen (file does not exist)

// Onboarding - Using existing screens
// Removed broken import for OnboardingScreen (file does not exist)

// Placeholder for non-existing screens
// Removed broken import for PlaceholderScreen (file does not exist)

// Stub widgets for missing screens
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Settings')));
}
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Chat')));
}
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Support')));
}
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Orders')));
}
class LocationTrackingScreen extends StatelessWidget {
  const LocationTrackingScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Location Tracking')));
}
class TerritoryMapScreen extends StatelessWidget {
  const TerritoryMapScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Territory Map')));
}
class PromotionsListScreen extends StatelessWidget {
  const PromotionsListScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Promotions')));
}
class FeedbackListScreen extends StatelessWidget {
  const FeedbackListScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Feedback')));
}
class SalesDashboardScreen extends StatelessWidget {
  const SalesDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Sales Dashboard')));
}
class DocumentManagementScreen extends StatelessWidget {
  const DocumentManagementScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Document Management')));
}
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Onboarding')));
}
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String description;
  const PlaceholderScreen({super.key, this.title = 'Placeholder', this.description = ''});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(description),
          ],
        ],
      ),
    ),
  );
}
// Providers

/// Comprehensive routing configuration for MultiSales app
class AppRouter {
  static GoRouter createRouter(OptimizedAuthProvider authProvider) {
    // Public-only app: no authentication or onboarding redirects
    return GoRouter(
      initialLocation: '/splash',
      redirect: (context, state) {
        // No authentication logic; always allow navigation
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
          path: '/auth',
          name: 'auth',
          builder: (context, state) => const EnhancedAuthScreen(),
        ),
        GoRoute(
          path: '/forgot-password',
          name: 'forgot-password',
          builder: (context, state) => const PlaceholderScreen(
            title: 'Password Recovery',
            description: 'Password recovery feature will be available soon.',
          ),
        ),

        // Onboarding Route
        GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),

        // Home Dashboard
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),

        // Communication Routes
        GoRoute(
          path: '/chat',
          name: 'chat',
          builder: (context, state) => const ChatScreen(),
        ),

        // Support Routes
        GoRoute(
          path: '/support',
          name: 'support',
          builder: (context, state) => const SupportScreen(),
        ),

        // Orders Routes
        GoRoute(
          path: '/orders',
          name: 'orders',
          builder: (context, state) => const OrdersScreen(),
        ),

        // Settings Routes
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),

        // Placeholder routes for future features
        GoRoute(
          path: '/account',
          name: 'account',
          builder: (context, state) => const PlaceholderScreen(
            title: 'Account Management',
            description: 'Account management features coming soon.',
          ),
        ),
        GoRoute(
          path: '/catalog',
          name: 'catalog',
          builder: (context, state) => const PlaceholderScreen(
            title: 'Product Catalog',
            description: 'Product catalog features coming soon.',
          ),
        ),
        GoRoute(
          path: '/appointments',
          name: 'appointments',
          builder: (context, state) => const PlaceholderScreen(
            title: 'Appointments',
            description: 'Appointment booking features coming soon.',
          ),
        ),
        GoRoute(
          path: '/maps',
          name: 'maps',
          builder: (context, state) => const LocationTrackingScreen(),
        ),
        GoRoute(
          path: '/territory-map',
          name: 'territory-map',
          builder: (context, state) => const TerritoryMapScreen(),
        ),
        GoRoute(
          path: '/promotions',
          name: 'promotions',
          builder: (context, state) => const PromotionsListScreen(),
        ),
        GoRoute(
          path: '/feedback',
          name: 'feedback',
          builder: (context, state) => const FeedbackListScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          name: 'sales-dashboard',
          builder: (context, state) => const SalesDashboardScreen(),
        ),
        GoRoute(
          path: '/documents',
          name: 'documents',
          builder: (context, state) => const DocumentManagementScreen(),
        ),
        GoRoute(
          path: '/tutorial',
          name: 'tutorial',
          builder: (context, state) => const PlaceholderScreen(
            title: 'Tutorial',
            description: 'Tutorial features coming soon.',
          ),
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

/// Simple splash screen placeholder
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('MultiSales',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}
