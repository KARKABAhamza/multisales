import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// Authentication - Using existing screens
import '../../presentation/screens/enhanced_auth_screen.dart';

// Main App Structure - Using existing screens
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';

// Communication - Using existing screens
import '../../presentation/screens/communication/chat_screen.dart';

// Support - Using existing screens
import '../../presentation/screens/support/support_screen.dart';

// Orders - Using existing screens
import '../../presentation/screens/orders/orders_screen.dart';

// Maps & Location - New feature screens
import '../../presentation/screens/maps/location_tracking_screen.dart';
import '../../presentation/screens/maps/territory_map_screen.dart';

// Promotions - New feature screens
import '../../presentation/screens/promotions/promotions_list_screen.dart';

// Feedback - New feature screens
import '../../presentation/screens/feedback/feedback_list_screen.dart';

// Sales Dashboard - New feature screens
import '../../presentation/screens/dashboard/sales_dashboard_screen.dart';

// Document Management - New feature screens
import '../../presentation/screens/documents/document_management_screen.dart';

// Onboarding - Using existing screens
import '../../presentation/screens/onboarding_screen.dart';

// Placeholder for non-existing screens
import '../../presentation/screens/placeholder_screen.dart';

// Providers
import '../providers/optimized_auth_provider.dart';

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
