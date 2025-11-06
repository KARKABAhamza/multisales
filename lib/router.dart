// ignore_for_file: sort_child_properties_last

import 'package:go_router/go_router.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/services_page.dart';
import 'pages/contact_page.dart';
import 'pages/legal_page.dart';
import 'pages/service_detail_page.dart';
import 'pages/expertise_page.dart';
import 'presentation/widgets/bottom_nav_shell.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => BottomNavShell(
        child: child,
        currentLocation: state.uri.toString(),
      ),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const NoTransitionPage(child: HomePage()),
        ),
        GoRoute(
          path: '/expertise',
          pageBuilder: (context, state) => NoTransitionPage(child: ExpertisePage()),
        ),
        GoRoute(
          path: '/services',
          pageBuilder: (context, state) => NoTransitionPage(child: ServicesPage()),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) => ServiceDetailPage(serviceId: state.pathParameters['id']!),
            ),
          ],
        ),
        GoRoute(
          path: '/contact',
          pageBuilder: (context, state) => const NoTransitionPage(child: ContactPage()),
        ),
      ],
    ),
    // Non-tab routes
    GoRoute(path: '/a-propos', builder: (context, state) => const AboutPage()),
    GoRoute(path: '/legal', builder: (context, state) => const LegalPage()),
  ],
);
