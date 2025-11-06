// Top-level stub widgets for missing screens

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/enhanced_auth_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/dashboard/sales_dashboard_screen.dart';
import '../../presentation/screens/documents/document_management_screen.dart';
import '../providers/optimized_auth_provider.dart';

// Top-level stub widgets for missing screens
class SettingsScreenStub extends StatelessWidget {
  const SettingsScreenStub({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Settings')));
}
class ChatScreenStub extends StatelessWidget {
  const ChatScreenStub({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Chat')));
}
class SupportScreenStub extends StatelessWidget {
  const SupportScreenStub({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Support')));
}
class OrdersScreenStub extends StatelessWidget {
  const OrdersScreenStub({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Orders')));
}
class OnboardingScreenStub extends StatelessWidget {
  const OnboardingScreenStub({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Onboarding')));
}
class LocationTrackingScreenStub extends StatelessWidget {
  const LocationTrackingScreenStub({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Location Tracking')));
}
class TerritoryMapScreenStub extends StatelessWidget {
  const TerritoryMapScreenStub({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Territory Map')));
}
class PromotionsListScreenStub extends StatelessWidget {
  const PromotionsListScreenStub({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Promotions')));
}
class FeedbackListScreenStub extends StatelessWidget {
  const FeedbackListScreenStub({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Feedback')));
}
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String description;
  const PlaceholderScreen({super.key, this.title = '', this.description = ''});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text(description)),
  );
}

/// Comprehensive routing configuration for MultiSales app

class AppRouter {
  static GoRouter createRouter(OptimizedAuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/splash',
      redirect: (context, state) => null,
      routes: [
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
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
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreenStub(),
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/chat',
          name: 'chat',
          builder: (context, state) => const ChatScreenStub(),
        ),
        GoRoute(
          path: '/support',
          name: 'support',
          builder: (context, state) => const SupportScreenStub(),
        ),
        GoRoute(
          path: '/orders',
          name: 'orders',
          builder: (context, state) => const OrdersScreenStub(),
        ),
        GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          builder: (context, state) => const OnboardingScreenStub(),
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
          path: '/maps',
          name: 'maps',
          builder: (context, state) => const LocationTrackingScreenStub(),
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
          path: '/territory',
          name: 'territory',
          builder: (context, state) => const TerritoryMapScreenStub(),
        ),
        GoRoute(
          path: '/promotions',
          name: 'promotions',
          builder: (context, state) => const PromotionsListScreenStub(),
        ),
        GoRoute(
          path: '/feedback',
          name: 'feedback',
          builder: (context, state) => const FeedbackListScreenStub(),
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
              Text('Page not found: \\${state.error}'),
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
            Text('MultiSales', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}


