// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/optimized_auth_provider.dart';
import '../../../core/localization/app_localizations.dart';

class SalesDashboardScreen extends StatefulWidget {
  const SalesDashboardScreen({super.key});

  @override
  State<SalesDashboardScreen> createState() => _SalesDashboardScreenState();
}

class _SalesDashboardScreenState extends State<SalesDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'This Month';
  String _selectedTeam = 'All Teams';

  final List<String> _periods = [
    'Today',
    'This Week',
    'This Month',
    'This Quarter',
    'This Year',
    'Custom'
  ];

  final List<String> _teams = [
    'All Teams',
    'North Team',
    'South Team',
    'East Team',
    'West Team',
    'Enterprise Team'
  ];

  final Map<String, dynamic> _dashboardData = {
    'revenue': {
      'current': 2450000,
      'target': 3000000,
      'growth': 15.2,
      'previous': 2130000,
    },
    'deals': {
      'closed': 127,
      'target': 150,
      'pipeline': 340,
      'won_rate': 68.5,
    },
    'activities': {
      'calls': 1256,
      'meetings': 89,
      'emails': 2145,
      'demos': 34,
    },
    'team_performance': [
      {
        'name': 'North Team',
        'revenue': 650000,
        'target': 750000,
        'deals': 32,
        'members': 8,
        'leader': 'Sarah Johnson',
      },
      {
        'name': 'South Team',
        'revenue': 580000,
        'target': 700000,
        'deals': 28,
        'members': 7,
        'leader': 'Mike Chen',
      },
      {
        'name': 'East Team',
        'revenue': 720000,
        'target': 800000,
        'deals': 38,
        'members': 9,
        'leader': 'Lisa Rodriguez',
      },
      {
        'name': 'West Team',
        'revenue': 500000,
        'target': 750000,
        'deals': 29,
        'members': 6,
        'leader': 'David Kim',
      },
    ],
    'top_performers': [
      {
        'name': 'Alex Smith',
        'team': 'East Team',
        'revenue': 185000,
        'deals': 12,
        'score': 95,
      },
      {
        'name': 'Maria Garcia',
        'team': 'North Team',
        'revenue': 172000,
        'deals': 11,
        'score': 92,
      },
      {
        'name': 'John Wilson',
        'team': 'South Team',
        'revenue': 168000,
        'deals': 10,
        'score': 89,
      },
      {
        'name': 'Emma Brown',
        'team': 'West Team',
        'revenue': 155000,
        'deals': 9,
        'score': 87,
      },
    ],
    'pipeline_stages': [
      {'stage': 'Prospecting', 'count': 45, 'value': 890000},
      {'stage': 'Qualification', 'count': 38, 'value': 1250000},
      {'stage': 'Proposal', 'count': 22, 'value': 980000},
      {'stage': 'Negotiation', 'count': 15, 'value': 750000},
      {'stage': 'Closing', 'count': 8, 'value': 420000},
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.home),
        backgroundColor: theme.colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: loc.home, icon: const Icon(Icons.dashboard)),
            Tab(text: loc.training, icon: const Icon(Icons.trending_up)),
            Tab(text: loc.profile, icon: const Icon(Icons.filter_list)),
            Tab(text: loc.settings, icon: const Icon(Icons.assessment)),
          ],
        ),
        actions: [
          Tooltip(
            message: 'Refresh',
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _refreshData(),
            ),
          ),
          Tooltip(
            message: 'Settings',
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _showDashboardSettings(context),
            ),
          ),
        ],
      ),
      body: Consumer<OptimizedAuthProvider>(
        builder: (context, authProvider, child) {
          // Public-only provider: no loading logic
          return Column(
            children: [
              _buildFilterBar(theme),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(theme),
                    _buildPerformanceTab(theme),
                    _buildPipelineTab(theme),
                    _buildReportsTab(theme),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _exportDashboard(),
        icon: const Icon(Icons.download),
        label: const Text('Export'),
      ),
    );
  }

  Widget _buildFilterBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedPeriod,
              decoration: const InputDecoration(
                labelText: 'Period',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(),
              ),
              items: _periods.map((period) {
                return DropdownMenuItem(value: period, child: Text(period));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPeriod = value!;
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedTeam,
              decoration: const InputDecoration(
                labelText: 'Team',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(),
              ),
              items: _teams.map((team) {
                return DropdownMenuItem(value: team, child: Text(team));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTeam = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(ThemeData theme) {
    final revenue = _dashboardData['revenue'];
    final deals = _dashboardData['deals'];
    final activities = _dashboardData['activities'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Revenue metrics
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Revenue',
                  '\$${(revenue['current'] / 1000).toStringAsFixed(0)}K',
                  '\$${(revenue['target'] / 1000).toStringAsFixed(0)}K Target',
                  revenue['current'] / revenue['target'],
                  Icons.attach_money,
                  Colors.green,
                  theme,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Growth',
                  '${revenue['growth']}%',
                  'vs Last Period',
                  revenue['growth'] / 20, // Normalize to 0-1
                  Icons.trending_up,
                  Colors.blue,
                  theme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Deals metrics
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Deals Closed',
                  '${deals['closed']}',
                  '${deals['target']} Target',
                  deals['closed'] / deals['target'],
                  Icons.handshake,
                  Colors.orange,
                  theme,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Win Rate',
                  '${deals['won_rate']}%',
                  'Pipeline Success',
                  deals['won_rate'] / 100,
                  Icons.star,
                  Colors.purple,
                  theme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Activities summary
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Activity Summary',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActivityItem(
                          'Calls',
                          '${activities['calls']}',
                          Icons.phone,
                          Colors.blue,
                          theme,
                        ),
                      ),
                      Expanded(
                        child: _buildActivityItem(
                          'Meetings',
                          '${activities['meetings']}',
                          Icons.people,
                          Colors.green,
                          theme,
                        ),
                      ),
                      Expanded(
                        child: _buildActivityItem(
                          'Emails',
                          '${activities['emails']}',
                          Icons.email,
                          Colors.orange,
                          theme,
                        ),
                      ),
                      Expanded(
                        child: _buildActivityItem(
                          'Demos',
                          '${activities['demos']}',
                          Icons.computer,
                          Colors.purple,
                          theme,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Quick insights
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Insights',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInsightItem(
                    'Revenue is 15.2% above last period',
                    Icons.trending_up,
                    Colors.green,
                    theme,
                  ),
                  _buildInsightItem(
                    'Pipeline value increased by 8%',
                    Icons.arrow_upward,
                    Colors.blue,
                    theme,
                  ),
                  _buildInsightItem(
                    'Team performance varies significantly',
                    Icons.warning,
                    Colors.orange,
                    theme,
                  ),
                  _buildInsightItem(
                    '23 deals closing this week',
                    Icons.schedule,
                    Colors.purple,
                    theme,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab(ThemeData theme) {
    final teamPerformance = _dashboardData['team_performance'] as List;
    final topPerformers = _dashboardData['top_performers'] as List;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Team Performance',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...teamPerformance
                      .map((team) => _buildTeamPerformanceItem(team, theme)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Top Performers',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...topPerformers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final performer = entry.value;
                    return _buildTopPerformerItem(performer, index + 1, theme);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineTab(ThemeData theme) {
    final pipelineStages = _dashboardData['pipeline_stages'] as List;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sales Pipeline',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...pipelineStages
                      .map((stage) => _buildPipelineStageItem(stage, theme)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pipeline Health',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.analytics, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Pipeline Analytics Chart'),
                          Text('Coming Soon',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Reports',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildReportItem(
                    'Sales Performance Report',
                    'Comprehensive analysis of sales metrics and KPIs',
                    Icons.assessment,
                    Colors.blue,
                    theme,
                  ),
                  _buildReportItem(
                    'Team Activity Report',
                    'Detailed breakdown of team activities and productivity',
                    Icons.people,
                    Colors.green,
                    theme,
                  ),
                  _buildReportItem(
                    'Pipeline Analysis',
                    'Deep dive into pipeline health and conversion rates',
                    Icons.filter_list,
                    Colors.orange,
                    theme,
                  ),
                  _buildReportItem(
                    'Revenue Forecast',
                    'Predictive analysis and revenue projections',
                    Icons.trending_up,
                    Colors.purple,
                    theme,
                  ),
                  _buildReportItem(
                    'Customer Insights',
                    'Customer behavior and engagement analytics',
                    Icons.insights,
                    Colors.teal,
                    theme,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report Schedule',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Automated reports will be available soon'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String subtitle,
    double progress,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
      String title, String value, IconData icon, Color color, ThemeData theme) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInsightItem(
      String text, IconData icon, Color color, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamPerformanceItem(Map<String, dynamic> team, ThemeData theme) {
    final progress = team['revenue'] / team['target'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                team['name'],
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${(team['revenue'] / 1000).toStringAsFixed(0)}K / \$${(team['target'] / 1000).toStringAsFixed(0)}K',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Led by ${team['leader']} • ${team['members']} members • ${team['deals']} deals',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 0.9
                  ? Colors.green
                  : progress >= 0.7
                      ? Colors.orange
                      : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPerformerItem(
      Map<String, dynamic> performer, int rank, ThemeData theme) {
    Color rankColor;
    switch (rank) {
      case 1:
        rankColor = Colors.amber;
        break;
      case 2:
        rankColor = Colors.grey;
        break;
      case 3:
        rankColor = Colors.brown;
        break;
      default:
        rankColor = Colors.blue;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rankColor.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: rankColor),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  color: rankColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  performer['name'],
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${performer['team']} • \$${(performer['revenue'] / 1000).toStringAsFixed(0)}K • ${performer['deals']} deals',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${performer['score']}',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineStageItem(Map<String, dynamic> stage, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stage['stage'],
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${stage['count']} deals',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${(stage['value'] / 1000).toStringAsFixed(0)}K',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  'Total Value',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(String title, String description, IconData icon,
      Color color, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _generateReport(title),
            icon: const Icon(Icons.download),
          ),
        ],
      ),
    );
  }

  void _showDashboardSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dashboard Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.refresh),
              title: Text('Auto Refresh'),
              subtitle: Text('Every 5 minutes'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
            ListTile(
              leading: Icon(Icons.visibility),
              title: Text('Widget Layout'),
              subtitle: Text('Customize layout'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Alert Thresholds'),
              subtitle: Text('Set target alerts'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _refreshData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshing dashboard data...')),
    );
  }

  void _exportDashboard() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting dashboard...')),
    );
  }

  void _generateReport(String reportType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Generating $reportType...')),
    );
  }
}
