import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Main scaffold that provides consistent layout across the app
class MainScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showDrawer;
  final bool showBottomNav;
  final int? currentIndex;
  final Function(int)? onBottomNavTap;

  const MainScaffold({
    super.key,
    required this.body,
    required this.title,
    this.actions,
    this.floatingActionButton,
    this.showDrawer = true,
    this.showBottomNav = false,
    this.currentIndex,
    this.onBottomNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // MultiSales Logo
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.business,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: actions,
      ),
      drawer: showDrawer ? const AppDrawer() : null,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: showBottomNav ? _buildBottomNav(context) : null,
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex ?? 0,
      onTap: (index) {
        if (onBottomNavTap != null) {
          onBottomNavTap!(index);
        } else {
          // Default navigation behavior
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/training');
              break;
            case 2:
              context.go('/messages');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        }
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Training',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}

/// App drawer for navigation
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.business, color: Colors.white, size: 40),
                const SizedBox(height: 12),
                Text(
                  'MultiSales',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Welcome to MultiSales',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            Icons.home,
            'Home',
            '/home',
          ),
          _buildDrawerItem(
            context,
            Icons.school,
            'Training',
            '/training',
          ),
          _buildDrawerItem(
            context,
            Icons.assignment,
            'Onboarding',
            '/onboarding',
          ),
          _buildDrawerItem(
            context,
            Icons.chat,
            'Messages',
            '/messages',
          ),
          _buildDrawerItem(
            context,
            Icons.people,
            'Team',
            '/team',
          ),
          _buildDrawerItem(
            context,
            Icons.analytics,
            'Analytics',
            '/analytics',
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            Icons.settings,
            'Settings',
            '/settings',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.of(context).pop();
        context.go(route);
      },
    );
  }
}
