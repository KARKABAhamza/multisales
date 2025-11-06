// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/responsive_layout.dart';
import '../../core/providers/language_provider.dart';

/// Main navigation header with responsive design
class ResponsiveNavigationHeader extends StatefulWidget {
  final String? currentRoute;
  final Function(String)? onNavigate;
  final bool showUserActions;
  final Widget? customLogo;

  const ResponsiveNavigationHeader({
    super.key,
    this.currentRoute,
    this.onNavigate,
    this.showUserActions = true,
    this.customLogo,
  });

  @override
  State<ResponsiveNavigationHeader> createState() =>
      _ResponsiveNavigationHeaderState();
}

class _ResponsiveNavigationHeaderState
    extends State<ResponsiveNavigationHeader> {
  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileHeader(context),
      tablet: _buildTabletHeader(context),
      desktop: _buildDesktopHeader(context),
      largeDesktop: _buildDesktopHeader(context),
    );
  }

  Widget _buildMobileHeader(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Logo
            _buildLogo(context, isCompact: true),
            const Spacer(),

            // User actions
            if (widget.showUserActions) ...[
              _buildNotificationButton(context),
              const SizedBox(width: 8),
              _buildUserMenuButton(context),
              const SizedBox(width: 8),
            ],

            // Menu button
            IconButton(
              onPressed: () {
                setState(() {
                  _isMenuOpen = !_isMenuOpen;
                });
                if (_isMenuOpen) {
                  _showMobileMenu(context);
                }
              },
              icon: Icon(
                _isMenuOpen ? Icons.close : Icons.menu,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletHeader(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            // Logo
            _buildLogo(context),
            const SizedBox(width: 32),

            // Navigation items (limited)
            Expanded(
              child: _buildTabletNavigation(context),
            ),

            // User actions
            if (widget.showUserActions) ...[
              _buildSearchButton(context),
              const SizedBox(width: 16),
              _buildNotificationButton(context),
              const SizedBox(width: 16),
              _buildLanguageSelector(context),
              const SizedBox(width: 16),
              _buildUserMenuButton(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopHeader(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ResponsiveContainer(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Row(
          children: [
            // Logo
            _buildLogo(context),
            const SizedBox(width: 48),

            // Navigation items
            Expanded(
              child: _buildDesktopNavigation(context),
            ),

            // Search bar
            SizedBox(
              width: 300,
              child: _buildSearchBar(context),
            ),
            const SizedBox(width: 24),

            // User actions
            if (widget.showUserActions) ...[
              _buildNotificationButton(context),
              const SizedBox(width: 16),
              _buildLanguageSelector(context),
              const SizedBox(width: 16),
              _buildUserMenuButton(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context, {bool isCompact = false}) {
    return widget.customLogo ??
        GestureDetector(
          onTap: () => widget.onNavigate?.call('/'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isCompact ? 32 : 40,
                height: isCompact ? 32 : 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.business,
                  color: Colors.white,
                  size: isCompact ? 20 : 24,
                ),
              ),
              if (!isCompact) ...[
                const SizedBox(width: 12),
                Text(
                  'MultiSales',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ],
          ),
        );
  }

  Widget _buildTabletNavigation(BuildContext context) {
    final primaryNavItems = _getNavigationItems().take(4).toList();

    return Row(
      children: primaryNavItems.map((item) {
        final isActive = widget.currentRoute == item.route;
        return Padding(
          padding: const EdgeInsets.only(right: 24),
          child: GestureDetector(
            onTap: () => widget.onNavigate?.call(item.route),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icon,
                    size: 20,
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: isActive
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDesktopNavigation(BuildContext context) {
    final navItems = _getNavigationItems();

    return Row(
      children: navItems.map((item) {
        final isActive = widget.currentRoute == item.route;
        return Padding(
          padding: const EdgeInsets.only(right: 32),
          child: GestureDetector(
            onTap: () => widget.onNavigate?.call(item.route),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isActive
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : null,
                borderRadius: BorderRadius.circular(8),
                border: isActive
                    ? Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.3),
                      )
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icon,
                    size: 20,
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: isActive
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return IconButton(
      onPressed: () => _showSearchDialog(context),
      icon: Icon(
        Icons.search,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
      ),
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: () => _showNotifications(context),
          icon: Icon(
            Icons.notifications_outlined,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return PopupMenuButton<String>(
          onSelected: (value) => languageProvider.changeLanguage(Locale(value)),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'en', child: Text('English')),
            const PopupMenuItem(value: 'fr', child: Text('Français')),
            const PopupMenuItem(value: 'es', child: Text('Español')),
            const PopupMenuItem(value: 'ar', child: Text('العربية')),
            const PopupMenuItem(value: 'de', child: Text('Deutsch')),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language,
                  size: 16,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  languageProvider.currentLocale.languageCode.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserMenuButton(BuildContext context) {
    // Public-only: Show info/help/about button instead of user menu
    return IconButton(
      icon: const Icon(Icons.info_outline),
      tooltip: 'About',
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('About MultiSales'),
            content: const Text('MultiSales is a public platform for catalog browsing and contact. For help, visit the Contact page.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ResponsiveMobileMenu(
        currentRoute: widget.currentRoute,
        onNavigate: (route) {
          Navigator.pop(context);
          widget.onNavigate?.call(route);
        },
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ResponsiveSearchDialog(),
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ResponsiveNotificationDialog(),
    );
  }

  // Removed user menu action handler for public-only logic

  List<NavigationItem> _getNavigationItems() {
    return [
      NavigationItem(
        route: '/',
        label: 'Dashboard',
        icon: Icons.dashboard_outlined,
      ),
      NavigationItem(
        route: '/catalog',
        label: 'Products',
        icon: Icons.inventory_2_outlined,
      ),
      NavigationItem(
        route: '/orders',
        label: 'Orders',
        icon: Icons.shopping_cart_outlined,
      ),
      NavigationItem(
        route: '/customers',
        label: 'Customers',
        icon: Icons.people_outlined,
      ),
      NavigationItem(
        route: '/analytics',
        label: 'Analytics',
        icon: Icons.analytics_outlined,
      ),
      NavigationItem(
        route: '/support',
        label: 'Support',
        icon: Icons.support_agent_outlined,
      ),
    ];
  }
}

/// Navigation item data class
class NavigationItem {
  final String route;
  final String label;
  final IconData icon;

  NavigationItem({
    required this.route,
    required this.label,
    required this.icon,
  });
}

/// Mobile bottom sheet menu
class ResponsiveMobileMenu extends StatelessWidget {
  final String? currentRoute;
  final Function(String)? onNavigate;

  const ResponsiveMobileMenu({
    super.key,
    this.currentRoute,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  'Navigation',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: _getNavigationItems().map((item) {
                final isActive = currentRoute == item.route;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                        : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      item.icon,
                      color: isActive
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        color: isActive
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    onTap: () => onNavigate?.call(item.route),
                  ),
                );
              }).toList(),
            ),
          ),

          // Public-only: Only show settings button, no user/logout/account
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: OutlinedButton.icon(
              onPressed: () => onNavigate?.call('/settings'),
              icon: const Icon(Icons.settings),
              label: const Text('Settings'),
            ),
          ),
        ],
      ),
    );
  }

  List<NavigationItem> _getNavigationItems() {
    return [
      NavigationItem(
          route: '/', label: 'Dashboard', icon: Icons.dashboard_outlined),
      NavigationItem(
          route: '/catalog',
          label: 'Products',
          icon: Icons.inventory_2_outlined),
      NavigationItem(
          route: '/orders',
          label: 'Orders',
          icon: Icons.shopping_cart_outlined),
      NavigationItem(
          route: '/customers', label: 'Customers', icon: Icons.people_outlined),
      NavigationItem(
          route: '/analytics',
          label: 'Analytics',
          icon: Icons.analytics_outlined),
      NavigationItem(
          route: '/support',
          label: 'Support',
          icon: Icons.support_agent_outlined),
    ];
  }
}

/// Responsive search dialog
class ResponsiveSearchDialog extends StatefulWidget {
  const ResponsiveSearchDialog({super.key});

  @override
  State<ResponsiveSearchDialog> createState() => _ResponsiveSearchDialogState();
}

class _ResponsiveSearchDialogState extends State<ResponsiveSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ResponsiveContainer(
        maxWidth: 600,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 500),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Search header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Search products, orders, customers...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: _performSearch,
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              // Search results
              Expanded(
                child: _searchResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              size: 48,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Start typing to search',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.history),
                            title: Text(_searchResults[index]),
                            onTap: () {
                              // Handle search result selection
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    // Simulate search
    setState(() {
      _searchResults = [
        'Product: $query',
        'Customer: $query',
        'Order: $query',
      ];
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

/// Responsive notification dialog
class ResponsiveNotificationDialog extends StatelessWidget {
  const ResponsiveNotificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ResponsiveContainer(
        maxWidth: 400,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      'Notifications',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              // Notifications list
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: 5,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        child: Icon(
                          Icons.notifications,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      title: Text('Notification ${index + 1}'),
                      subtitle:
                          const Text('This is a sample notification message'),
                      trailing: Text(
                        '${index + 1}m ago',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  },
                ),
              ),

              // Footer
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // View all notifications
                      Navigator.pop(context);
                    },
                    child: const Text('View All'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
