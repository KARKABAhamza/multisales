import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavShell extends StatelessWidget {
  final Widget child;
  final String currentLocation;
  const BottomNavShell({super.key, required this.child, required this.currentLocation});

  static final _tabs = [
    _TabItem(route: '/', icon: Icons.home_outlined, activeIcon: Icons.home),
    _TabItem(route: '/services', icon: Icons.design_services_outlined, activeIcon: Icons.design_services),
    _TabItem(route: '/contact', icon: Icons.mail_outline, activeIcon: Icons.mail),
  ];

  int _locationToTabIndex(String location) {
    // Match exact or prefix (for nested paths)
    if (location == '/' || location.startsWith('/?')) return 0;
    if (location.startsWith('/services')) return 1;
    if (location.startsWith('/contact')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
  final currentIndex = _locationToTabIndex(currentLocation);

    return Scaffold(
      body: child,
      bottomNavigationBar: SafeArea(
        top: false,
        child: NavigationBar(
        selectedIndex: currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: (index) {
          final target = _tabs[index].route;
          context.go(target);
        },
          backgroundColor: Theme.of(context).colorScheme.surface,
          indicatorColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.10),
          surfaceTintColor: Colors.transparent,
          destinations: _tabs
              .map((t) => NavigationDestination(
                    icon: Icon(t.icon),
                    selectedIcon: Icon(t.activeIcon),
                    label: '',
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _TabItem {
  final String route;
  final IconData icon;
  final IconData activeIcon;
  const _TabItem({required this.route, required this.icon, required this.activeIcon});
}
