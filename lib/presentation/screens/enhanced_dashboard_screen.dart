import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/enhanced_dashboard_widgets.dart';
import '../widgets/enhanced_ui_components.dart';
import '../widgets/enhanced_form_fields.dart';
import '../../core/providers/auth_provider.dart';

class EnhancedDashboardScreen extends StatefulWidget {
  const EnhancedDashboardScreen({super.key});

  @override
  State<EnhancedDashboardScreen> createState() =>
      _EnhancedDashboardScreenState();
}

class _EnhancedDashboardScreenState extends State<EnhancedDashboardScreen>
    with TickerProviderStateMixin {
  int _selectedBottomNavIndex = 0;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  final List<BottomNavigationItem> _bottomNavItems = [
    const BottomNavigationItem(
      label: 'Dashboard',
      icon: Icons.dashboard,
      route: '/dashboard',
    ),
    const BottomNavigationItem(
      label: 'Training',
      icon: Icons.school,
      route: '/training',
    ),
    const BottomNavigationItem(
      label: 'Progress',
      icon: Icons.analytics,
      route: '/progress',
    ),
    const BottomNavigationItem(
      label: 'Settings',
      icon: Icons.settings,
      route: '/settings',
    ),
  ];

  final List<NavigationItem> _drawerItems = [
    const NavigationItem(
      title: 'Dashboard',
      route: '/dashboard',
      icon: Icons.dashboard,
      subtitle: 'Overview & metrics',
    ),
    const NavigationItem(
      title: 'Onboarding',
      route: '/onboarding',
      icon: Icons.assignment,
      subtitle: 'Role-based training',
    ),
    const NavigationItem(
      title: 'Training Modules',
      route: '/training',
      icon: Icons.school,
      subtitle: 'Learn & grow',
    ),
    const NavigationItem(
      title: 'Progress Tracking',
      route: '/progress',
      icon: Icons.analytics,
      subtitle: 'Your achievements',
    ),
    const NavigationItem(
      title: 'Team Chat',
      route: '/chat',
      icon: Icons.chat,
      subtitle: 'Connect with team',
    ),
    const NavigationItem(
      title: 'Resources',
      route: '/resources',
      icon: Icons.library_books,
      subtitle: 'Documents & guides',
    ),
    const NavigationItem(
      title: 'Profile',
      route: '/profile',
      icon: Icons.person,
      subtitle: 'Your information',
    ),
    const NavigationItem(
      title: 'Settings',
      route: '/settings',
      icon: Icons.settings,
      subtitle: 'App preferences',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onNavigationItemTap(String route) {
    Navigator.of(context).pop(); // Close drawer
    // Handle navigation based on route
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to $route'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedBottomNavIndex = index;
    });
    // Handle navigation based on index
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Switched to ${_bottomNavItems[index].label}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onSearch(String query) {
    if (query.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Searching for: $query'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _onVoiceSearch() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice search activated'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildDashboardContent() {
    switch (_selectedBottomNavIndex) {
      case 0:
        return _buildMainDashboard();
      case 1:
        return _buildTrainingContent();
      case 2:
        return _buildProgressContent();
      case 3:
        return _buildSettingsContent();
      default:
        return _buildMainDashboard();
    }
  }

  Widget _buildMainDashboard() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome section
                EnhancedCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back!',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Ready to continue your learning journey?',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Metrics grid
                Text(
                  'Your Progress',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.3,
                  children: [
                    EnhancedMetricCard(
                      title: 'Modules Completed',
                      value: '8/12',
                      icon: Icons.school,
                      color: Colors.green,
                      trend: '+2 this week',
                      isPositiveTrend: true,
                      onTap: () => _onBottomNavTap(1),
                    ),
                    EnhancedMetricCard(
                      title: 'Learning Hours',
                      value: '24.5h',
                      icon: Icons.access_time,
                      color: Colors.blue,
                      trend: '+5.2h this week',
                      isPositiveTrend: true,
                      onTap: () => _onBottomNavTap(2),
                    ),
                    EnhancedMetricCard(
                      title: 'Team Rank',
                      value: '#3',
                      icon: Icons.leaderboard,
                      color: Colors.orange,
                      trend: '↑2 positions',
                      isPositiveTrend: true,
                      onTap: () => _onBottomNavTap(2),
                    ),
                    EnhancedMetricCard(
                      title: 'Certificates',
                      value: '5',
                      icon: Icons.military_tech,
                      color: Colors.purple,
                      trend: '+1 this month',
                      isPositiveTrend: true,
                      onTap: () => _onBottomNavTap(2),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Quick actions
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: EnhancedButton(
                        onPressed: () => _onBottomNavTap(1),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Continue Learning',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: EnhancedButton(
                        onPressed: () => _onBottomNavTap(2),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.analytics),
                            SizedBox(width: 8),
                            Text('View Progress'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingContent() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Training Modules',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                // Training modules list
                ...List.generate(5, (index) {
                  final titles = [
                    'Product Knowledge Basics',
                    'Customer Service Excellence',
                    'Sales Techniques',
                    'Digital Marketing Fundamentals',
                    'Team Collaboration Skills',
                  ];
                  final progress = [0.8, 0.6, 0.3, 0.9, 0.1];
                  final colors = [
                    Colors.blue,
                    Colors.green,
                    Colors.orange,
                    Colors.purple,
                    Colors.red,
                  ];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: EnhancedCard(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colors[index],
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          titles[index],
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: progress[index],
                              backgroundColor: Colors.grey[300],
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(colors[index]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(progress[index] * 100).toInt()}% Complete',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          progress[index] == 1.0
                              ? Icons.check_circle
                              : Icons.play_circle_outline,
                          color: progress[index] == 1.0
                              ? Colors.green
                              : colors[index],
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Opening ${titles[index]}'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressContent() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Progress',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                // Overall progress
                EnhancedCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overall Progress',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LinearProgressIndicator(
                                    value: 0.67,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor,
                                    ),
                                    minHeight: 8,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '67% Complete',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            CircularProgressIndicator(
                              value: 0.67,
                              backgroundColor: Colors.grey[300],
                              strokeWidth: 6,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Achievements
                Text(
                  'Recent Achievements',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                ...List.generate(4, (index) {
                  final achievements = [
                    {
                      'title': 'First Module Complete',
                      'icon': Icons.school,
                      'color': Colors.blue
                    },
                    {
                      'title': 'Week Streak',
                      'icon': Icons.local_fire_department,
                      'color': Colors.orange
                    },
                    {
                      'title': 'Top Performer',
                      'icon': Icons.star,
                      'color': Colors.yellow
                    },
                    {
                      'title': 'Team Player',
                      'icon': Icons.group,
                      'color': Colors.green
                    },
                  ];

                  final achievement = achievements[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: EnhancedCard(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: (achievement['color'] as Color)
                              .withValues(alpha: 0.1),
                          child: Icon(
                            achievement['icon'] as IconData,
                            color: achievement['color'] as Color,
                          ),
                        ),
                        title: Text(achievement['title'] as String),
                        subtitle: Text('Earned ${3 - index} days ago'),
                        trailing: Icon(
                          Icons.emoji_events,
                          color: achievement['color'] as Color,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsContent() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                // Settings sections
                const SizedBox(height: 12),
                _buildSettingsSection(
                  'Account',
                  [
                    {
                      'title': 'Profile Information',
                      'icon': Icons.person,
                      'subtitle': 'Update your details'
                    },
                    {
                      'title': 'Password & Security',
                      'icon': Icons.security,
                      'subtitle': 'Manage your security'
                    },
                    {
                      'title': 'Privacy Settings',
                      'icon': Icons.privacy_tip,
                      'subtitle': 'Control your privacy'
                    },
                  ],
                ),

                const SizedBox(height: 20),
                _buildSettingsSection(
                  'Preferences',
                  [
                    {
                      'title': 'Language',
                      'icon': Icons.language,
                      'subtitle': 'Choose your language'
                    },
                    {
                      'title': 'Notifications',
                      'icon': Icons.notifications,
                      'subtitle': 'Manage notifications'
                    },
                    {
                      'title': 'Theme',
                      'icon': Icons.palette,
                      'subtitle': 'Dark or light mode'
                    },
                  ],
                ),

                const SizedBox(height: 20),
                _buildSettingsSection(
                  'Support',
                  [
                    {
                      'title': 'Help Center',
                      'icon': Icons.help,
                      'subtitle': 'Get help and support'
                    },
                    {
                      'title': 'Contact Us',
                      'icon': Icons.contact_support,
                      'subtitle': 'Reach out to our team'
                    },
                    {
                      'title': 'About',
                      'icon': Icons.info,
                      'subtitle': 'App version and info'
                    },
                  ],
                ),

                const SizedBox(height: 32),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return EnhancedButton(
                      onPressed: () async {
                        await authProvider.signOut();
                      },
                      isLoading: authProvider.isLoading,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: authProvider.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.logout, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Sign Out',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(String title, List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
        ),
        const SizedBox(height: 12),
        EnhancedCard(
          child: Column(
            children: items.map((item) {
              final isLast = items.indexOf(item) == items.length - 1;
              return Column(
                children: [
                  ListTile(
                    leading: Icon(
                      item['icon'] as IconData,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(item['title'] as String),
                    subtitle: Text(item['subtitle'] as String),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening ${item['title']}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  if (!isLast) const Divider(height: 1),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _bottomNavItems[_selectedBottomNavIndex].label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
        actions: [
          Semantics(
            button: true,
            label: 'Notifications',
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening notifications'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      drawer: EnhancedNavigationDrawer(
        currentRoute: '/dashboard',
        onItemTap: _onNavigationItemTap,
        items: _drawerItems,
      ),
      body: Column(
        children: [
          // Search bar (only show on main dashboard)
          if (_selectedBottomNavIndex == 0)
            EnhancedSearchBar(
              hintText: 'Search modules, progress, or help...',
              onSearch: _onSearch,
              onVoiceSearch: _onVoiceSearch,
            ),

          // Main content
          Expanded(
            child: _buildDashboardContent(),
          ),
        ],
      ),
      bottomNavigationBar: EnhancedBottomNavigationBar(
        currentIndex: _selectedBottomNavIndex,
        onTap: _onBottomNavTap,
        items: _bottomNavItems,
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: Semantics(
          button: true,
          label: 'Quick help',
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Quick Help'),
                  content: const Text('What can we help you with today?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            child: const Icon(Icons.help_outline),
          ),
        ),
      ),
    );
  }
}
