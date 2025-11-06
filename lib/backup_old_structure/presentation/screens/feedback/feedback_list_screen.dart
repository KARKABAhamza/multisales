// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/optimized_auth_provider.dart';

class FeedbackListScreen extends StatefulWidget {
  const FeedbackListScreen({super.key});

  @override
  State<FeedbackListScreen> createState() => _FeedbackListScreenState();
}

class _FeedbackListScreenState extends State<FeedbackListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';
  String _selectedSortBy = 'Recent';

  final List<String> _filters = [
    'All',
    'Positive',
    'Negative',
    'Feature Request',
    'Bug Report',
    'General'
  ];

  final List<String> _sortOptions = [
    'Recent',
    'Oldest',
    'Rating High to Low',
    'Rating Low to High',
    'Priority'
  ];

  final List<Map<String, dynamic>> _feedbackList = [
    {
      'id': 'FB001',
      'customerName': 'Sarah Johnson',
      'customerEmail': 'sarah.j@techcorp.com',
      'company': 'TechCorp Solutions',
      'type': 'Feature Request',
      'rating': 4,
      'subject': 'Mobile App Integration',
      'message':
          'Would love to see better integration with mobile devices. The current web interface works well, but a dedicated mobile app would be fantastic for field sales.',
      'status': 'Under Review',
      'priority': 'High',
      'category': 'Product Enhancement',
      'assignedTo': 'Product Team',
      'createdAt': '2024-03-15T10:30:00Z',
      'updatedAt': '2024-03-16T14:20:00Z',
      'tags': ['mobile', 'integration', 'sales'],
      'attachments': [],
      'responses': [
        {
          'author': 'Product Manager',
          'message': 'Thanks for the feedback! This is on our roadmap for Q2.',
          'createdAt': '2024-03-16T14:20:00Z',
        }
      ],
    },
    {
      'id': 'FB002',
      'customerName': 'Mike Chen',
      'customerEmail': 'm.chen@globalind.com',
      'company': 'Global Industries',
      'type': 'Bug Report',
      'rating': 2,
      'subject': 'Report Generation Issue',
      'message':
          'Having trouble generating monthly reports. The system freezes when trying to export data for large date ranges. This is affecting our monthly review process.',
      'status': 'In Progress',
      'priority': 'High',
      'category': 'Technical Issue',
      'assignedTo': 'Engineering Team',
      'createdAt': '2024-03-14T09:15:00Z',
      'updatedAt': '2024-03-15T16:45:00Z',
      'tags': ['reports', 'export', 'performance'],
      'attachments': ['screenshot.png', 'error_log.txt'],
      'responses': [
        {
          'author': 'Support Team',
          'message': 'We\'ve identified the issue and are working on a fix.',
          'createdAt': '2024-03-15T11:30:00Z',
        },
        {
          'author': 'Engineering Team',
          'message': 'Fix deployed to staging, testing in progress.',
          'createdAt': '2024-03-15T16:45:00Z',
        }
      ],
    },
    {
      'id': 'FB003',
      'customerName': 'Lisa Rodriguez',
      'customerEmail': 'l.rodriguez@startup.io',
      'company': 'StartUp Inc',
      'type': 'Positive',
      'rating': 5,
      'subject': 'Excellent Customer Support',
      'message':
          'I wanted to share how impressed I am with your customer support team. They resolved my integration issue quickly and provided excellent documentation.',
      'status': 'Resolved',
      'priority': 'Medium',
      'category': 'Customer Service',
      'assignedTo': 'Support Team',
      'createdAt': '2024-03-13T14:22:00Z',
      'updatedAt': '2024-03-13T15:10:00Z',
      'tags': ['support', 'positive', 'documentation'],
      'attachments': [],
      'responses': [
        {
          'author': 'Support Manager',
          'message':
              'Thank you for the kind words! We\'ll share this with the team.',
          'createdAt': '2024-03-13T15:10:00Z',
        }
      ],
    },
    {
      'id': 'FB004',
      'customerName': 'David Kim',
      'customerEmail': 'd.kim@enterprise.com',
      'company': 'Enterprise Corp',
      'type': 'Feature Request',
      'rating': 4,
      'subject': 'Advanced Analytics Dashboard',
      'message':
          'The current analytics are good, but we need more advanced features like predictive analytics, custom KPIs, and drill-down capabilities for our executive team.',
      'status': 'Planned',
      'priority': 'Medium',
      'category': 'Product Enhancement',
      'assignedTo': 'Analytics Team',
      'createdAt': '2024-03-12T11:45:00Z',
      'updatedAt': '2024-03-14T09:30:00Z',
      'tags': ['analytics', 'dashboard', 'enterprise'],
      'attachments': ['requirements.pdf'],
      'responses': [
        {
          'author': 'Product Manager',
          'message':
              'Great suggestion! This aligns with our enterprise roadmap.',
          'createdAt': '2024-03-14T09:30:00Z',
        }
      ],
    },
    {
      'id': 'FB005',
      'customerName': 'Amy Wilson',
      'customerEmail': 'a.wilson@consulting.biz',
      'company': 'Wilson Consulting',
      'type': 'General',
      'rating': 3,
      'subject': 'Training Resources',
      'message':
          'The platform is powerful but the learning curve is steep. More training videos and documentation would help new users get up to speed faster.',
      'status': 'New',
      'priority': 'Low',
      'category': 'Documentation',
      'assignedTo': 'Training Team',
      'createdAt': '2024-03-11T16:20:00Z',
      'updatedAt': '2024-03-11T16:20:00Z',
      'tags': ['training', 'documentation', 'onboarding'],
      'attachments': [],
      'responses': [],
    },
  ];

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Feedback'),
        backgroundColor: theme.colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All Feedback', icon: Icon(Icons.feedback)),
            Tab(text: 'Pending', icon: Icon(Icons.pending_actions)),
            Tab(text: 'In Progress', icon: Icon(Icons.work)),
            Tab(text: 'Analytics', icon: Icon(Icons.analytics)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortDialog(context),
          ),
        ],
      ),
      body: Consumer<OptimizedAuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildFeedbackList(_getFilteredFeedback(), theme),
              _buildFeedbackList(
                  _getFilteredFeedback(['New', 'Under Review']), theme),
              _buildFeedbackList(_getFilteredFeedback(['In Progress']), theme),
              _buildAnalyticsView(theme),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createFeedbackSurvey(),
        icon: const Icon(Icons.add_comment),
        label: const Text('New Survey'),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredFeedback(
      [List<String>? statusFilter]) {
    var filtered = _feedbackList.where((feedback) {
      if (statusFilter != null && !statusFilter.contains(feedback['status'])) {
        return false;
      }
      if (_selectedFilter != 'All' && feedback['type'] != _selectedFilter) {
        return false;
      }
      return true;
    }).toList();

    // Sort the filtered results
    switch (_selectedSortBy) {
      case 'Recent':
        filtered.sort((a, b) => DateTime.parse(b['createdAt'])
            .compareTo(DateTime.parse(a['createdAt'])));
        break;
      case 'Oldest':
        filtered.sort((a, b) => DateTime.parse(a['createdAt'])
            .compareTo(DateTime.parse(b['createdAt'])));
        break;
      case 'Rating High to Low':
        filtered
            .sort((a, b) => (b['rating'] as int).compareTo(a['rating'] as int));
        break;
      case 'Rating Low to High':
        filtered
            .sort((a, b) => (a['rating'] as int).compareTo(b['rating'] as int));
        break;
      case 'Priority':
        final priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
        filtered.sort((a, b) => (priorityOrder[a['priority']] ?? 3)
            .compareTo(priorityOrder[b['priority']] ?? 3));
        break;
    }

    return filtered;
  }

  Widget _buildFeedbackList(
      List<Map<String, dynamic>> feedbackList, ThemeData theme) {
    if (feedbackList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.feedback_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No feedback found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or check back later',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: feedbackList.length,
      itemBuilder: (context, index) {
        return _buildFeedbackCard(feedbackList[index], theme);
      },
    );
  }

  Widget _buildFeedbackCard(Map<String, dynamic> feedback, ThemeData theme) {
    final type = feedback['type'] as String;
    final status = feedback['status'] as String;
    final priority = feedback['priority'] as String;
    final rating = feedback['rating'] as int;

    Color typeColor = _getTypeColor(type);
    Color statusColor = _getStatusColor(status);
    Color priorityColor = _getPriorityColor(priority);

    final createdAt = DateTime.parse(feedback['createdAt']);
    final timeAgo = _getTimeAgo(createdAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: typeColor.withOpacity(0.1),
                  child: Icon(
                    _getTypeIcon(type),
                    color: typeColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              feedback['subject'],
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: priorityColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: priorityColor.withOpacity(0.3)),
                            ),
                            child: Text(
                              priority,
                              style: TextStyle(
                                color: priorityColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${feedback['customerName']} • ${feedback['company']}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (rating > 0) ...[
                            // ignore: prefer_const_constructors
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Text(
                              rating.toString(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              feedback['message'],
              style: theme.textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip(Icons.category, type, typeColor, theme),
                const SizedBox(width: 8),
                _buildInfoChip(Icons.flag, status, statusColor, theme),
                const SizedBox(width: 8),
                _buildInfoChip(Icons.schedule, timeAgo, Colors.grey, theme),
              ],
            ),
            if (feedback['tags'].isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                children: (feedback['tags'] as List<String>).map((tag) {
                  return Chip(
                    label: Text(
                      tag,
                      style: const TextStyle(fontSize: 10),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Assigned to: ${feedback['assignedTo']}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const Spacer(),
                if (feedback['attachments'].isNotEmpty)
                  Icon(Icons.attach_file,
                      size: 16, color: Colors.grey.shade600),
                if (feedback['responses'].isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.comment, size: 16, color: Colors.grey.shade600),
                  Text(
                    ' ${feedback['responses'].length}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _respondToFeedback(feedback),
                    icon: const Icon(Icons.reply, size: 16),
                    label: const Text('Respond'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _updateStatus(feedback),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Update'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _viewDetails(feedback),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('Details'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(
      IconData icon, String label, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsView(ThemeData theme) {
    final totalFeedback = _feedbackList.length;
    final averageRating =
        _feedbackList.map((f) => f['rating'] as int).reduce((a, b) => a + b) /
            totalFeedback;
    final positiveCount =
        _feedbackList.where((f) => f['type'] == 'Positive').length;
    final bugReports =
        _feedbackList.where((f) => f['type'] == 'Bug Report').length;
    final featureRequests =
        _feedbackList.where((f) => f['type'] == 'Feature Request').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard(
                    'Total Feedback',
                    totalFeedback.toString(),
                    Icons.feedback,
                    Colors.blue,
                    theme),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAnalyticsCard(
                    'Average Rating',
                    averageRating.toStringAsFixed(1),
                    Icons.star,
                    Colors.amber,
                    theme),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard(
                    'Positive Feedback',
                    positiveCount.toString(),
                    Icons.thumb_up,
                    Colors.green,
                    theme),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAnalyticsCard('Bug Reports', bugReports.toString(),
                    Icons.bug_report, Colors.red, theme),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAnalyticsCard('Feature Requests', featureRequests.toString(),
              Icons.lightbulb, Colors.orange, theme),
          const SizedBox(height: 20),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Feedback Trends',
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
                          Icon(Icons.trending_up, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Feedback Trends Chart'),
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

  Widget _buildAnalyticsCard(
      String title, String value, IconData icon, Color color, ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
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
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Positive':
        return Colors.green;
      case 'Negative':
        return Colors.red;
      case 'Feature Request':
        return Colors.blue;
      case 'Bug Report':
        return Colors.orange;
      case 'General':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'New':
        return Colors.blue;
      case 'Under Review':
        return Colors.orange;
      case 'In Progress':
        return Colors.purple;
      case 'Resolved':
        return Colors.green;
      case 'Planned':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Positive':
        return Icons.thumb_up;
      case 'Negative':
        return Icons.thumb_down;
      case 'Feature Request':
        return Icons.lightbulb;
      case 'Bug Report':
        return Icons.bug_report;
      case 'General':
        return Icons.comment;
      default:
        return Icons.feedback;
    }
  }

  String _getTimeAgo(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _filters.map((filter) {
            return RadioListTile<String>(
              title: Text(filter),
              value: filter,
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _sortOptions.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: _selectedSortBy,
              onChanged: (value) {
                setState(() {
                  _selectedSortBy = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _createFeedbackSurvey() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Create feedback survey feature coming soon')),
    );
  }

  void _respondToFeedback(Map<String, dynamic> feedback) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Responding to feedback from ${feedback['customerName']}...')),
    );
  }

  void _updateStatus(Map<String, dynamic> feedback) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Updating status for ${feedback['subject']}...')),
    );
  }

  void _viewDetails(Map<String, dynamic> feedback) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing details for ${feedback['subject']}...')),
    );
  }
}
