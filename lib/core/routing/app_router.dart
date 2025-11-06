import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../services/analytics_service.dart';
import '../../pages/home_page.dart';
import '../../pages/about_page.dart';
import '../../pages/services_page.dart';
import '../../pages/contact_page.dart';
import '../../pages/expertise_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    observers: [
      AnalyticsService().observer as NavigatorObserver,
    ],
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/a-propos',
        name: 'about',
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: '/services',
        name: 'services',
        builder: (context, state) => ServicesPage(),
      ),
      GoRoute(
        path: '/contact',
        name: 'contact',
        builder: (context, state) => const ContactPage(),
      ),
      GoRoute(
        path: '/expertise',
        name: 'expertise',
        builder: (context, state) => ExpertisePage(),
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
}
// ...existing code...

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
