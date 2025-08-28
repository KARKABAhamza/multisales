// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/enhanced_ui_components.dart';
import '../../widgets/enhanced_dashboard_widgets.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  SupportCategory? _selectedCategory;

  final List<SupportArticle> _articles = [
    SupportArticle(
      id: '1',
      title: 'How to place an order',
      content:
          'Step-by-step guide to placing your first order on MultiSales...',
      category: SupportCategory.orders,
      isPopular: true,
      views: 1250,
      lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
    ),
    SupportArticle(
      id: '2',
      title: 'Managing your account settings',
      content:
          'Learn how to update your profile, change password, and manage preferences...',
      category: SupportCategory.account,
      isPopular: true,
      views: 890,
      lastUpdated: DateTime.now().subtract(const Duration(days: 5)),
    ),
    SupportArticle(
      id: '3',
      title: 'Understanding shipping options',
      content: 'Different shipping methods and their delivery times...',
      category: SupportCategory.shipping,
      isPopular: false,
      views: 456,
      lastUpdated: DateTime.now().subtract(const Duration(days: 7)),
    ),
    SupportArticle(
      id: '4',
      title: 'Payment methods and billing',
      content: 'Accepted payment methods and billing information...',
      category: SupportCategory.billing,
      isPopular: true,
      views: 723,
      lastUpdated: DateTime.now().subtract(const Duration(days: 3)),
    ),
    SupportArticle(
      id: '5',
      title: 'Troubleshooting app issues',
      content: 'Common app problems and their solutions...',
      category: SupportCategory.technical,
      isPopular: false,
      views: 334,
      lastUpdated: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  final List<SupportTicket> _tickets = [
    SupportTicket(
      id: '1',
      subject: 'Order not received',
      description: 'I placed an order 5 days ago but haven\'t received it yet.',
      status: SupportTicketStatus.open,
      priority: SupportPriority.medium,
      category: SupportCategory.orders,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      lastResponse: DateTime.now().subtract(const Duration(hours: 2)),
      assignedAgent: 'Sarah Johnson',
    ),
    SupportTicket(
      id: '2',
      subject: 'Billing question',
      description: 'I was charged twice for the same order.',
      status: SupportTicketStatus.resolved,
      priority: SupportPriority.high,
      category: SupportCategory.billing,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      lastResponse: DateTime.now().subtract(const Duration(days: 1)),
      assignedAgent: 'Mike Chen',
      resolvedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  List<SupportArticle> get _filteredArticles {
    var articles = _articles.where((article) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        if (!article.title.toLowerCase().contains(searchLower) &&
            !article.content.toLowerCase().contains(searchLower)) {
          return false;
        }
      }

      // Category filter
      if (_selectedCategory != null && article.category != _selectedCategory) {
        return false;
      }

      return true;
    }).toList();

    // Sort by popularity and views
    articles.sort((a, b) {
      if (a.isPopular && !b.isPopular) return -1;
      if (!a.isPopular && b.isPopular) return 1;
      return b.views.compareTo(a.views);
    });

    return articles;
  }

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

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Support Center',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.headset_mic_outlined),
            onPressed: () => _startLiveChat(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(
              icon: Icon(Icons.help_outline),
              text: 'Help Center',
            ),
            Tab(
              icon: Icon(Icons.support_agent),
              text: 'My Tickets',
            ),
            Tab(
              icon: Icon(Icons.chat),
              text: 'Live Chat',
            ),
            Tab(
              icon: Icon(Icons.contact_support),
              text: 'Contact Us',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHelpCenter(),
          _buildMyTickets(),
          _buildLiveChat(),
          _buildContactUs(),
        ],
      ),
    );
  }

  Widget _buildHelpCenter() {
    return Column(
      children: [
        // Search Bar
        EnhancedSearchBar(
          hintText: 'Search help articles...',
          onSearch: _onSearch,
        ),

        // Quick Actions
        EnhancedCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionButton(
                        icon: Icons.chat,
                        label: 'Live Chat',
                        onPressed: () => _startLiveChat(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionButton(
                        icon: Icons.phone,
                        label: 'Call Support',
                        onPressed: () => _callSupport(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionButton(
                        icon: Icons.email,
                        label: 'Email Us',
                        onPressed: () => _emailSupport(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Categories
        if (_searchQuery.isEmpty)
          EnhancedCard(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Browse by Category',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: SupportCategory.values.map((category) {
                      final isSelected = _selectedCategory == category;
                      return FilterChip(
                        label: Text(category.displayName),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? category : null;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

        // Articles
        Expanded(
          child: _buildArticlesList(),
        ),
      ],
    );
  }

  Widget _buildArticlesList() {
    final articles = _filteredArticles;

    if (articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No articles found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return _buildArticleCard(article);
      },
    );
  }

  Widget _buildArticleCard(SupportArticle article) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => _openArticle(article),
        child: EnhancedCard(
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: article.category.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                article.category.icon,
                color: article.category.color,
                size: 20,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    article.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                if (article.isPopular)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Popular',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  article.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.visibility,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${article.views} views',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.update,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(article.lastUpdated),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }

  Widget _buildMyTickets() {
    if (_tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.support_agent,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No support tickets',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'You haven\'t created any support tickets yet',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _createTicket(),
              child: const Text('Create Ticket'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Support Tickets',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              ElevatedButton(
                onPressed: () => _createTicket(),
                child: const Text('New Ticket'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _tickets.length,
            itemBuilder: (context, index) {
              final ticket = _tickets[index];
              return _buildTicketCard(ticket);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTicketCard(SupportTicket ticket) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => _openTicket(ticket),
        child: EnhancedCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#${ticket.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        _buildPriorityChip(ticket.priority),
                        const SizedBox(width: 8),
                        _buildStatusChip(ticket.status),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  ticket.subject,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ticket.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Assigned to ${ticket.assignedAgent}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Last response: ${_formatDate(ticket.lastResponse)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLiveChat() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          EnhancedCard(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(
                    Icons.chat,
                    size: 64,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Live Chat Support',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Get instant help from our support team',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _startLiveChat(),
                      child: const Text('Start Chat'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          EnhancedCard(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Support Hours',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _buildSupportHour('Monday - Friday', '9:00 AM - 6:00 PM'),
                  _buildSupportHour('Saturday', '10:00 AM - 4:00 PM'),
                  _buildSupportHour('Sunday', 'Closed'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Currently online',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactUs() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildContactOption(
            icon: Icons.phone,
            title: 'Phone Support',
            subtitle: '+1 (555) 123-4567',
            onTap: () => _callSupport(),
          ),
          const SizedBox(height: 12),
          _buildContactOption(
            icon: Icons.email,
            title: 'Email Support',
            subtitle: 'support@multisales.com',
            onTap: () => _emailSupport(),
          ),
          const SizedBox(height: 12),
          _buildContactOption(
            icon: Icons.location_on,
            title: 'Visit Us',
            subtitle: '123 Business Street, Suite 100\nNew York, NY 10001',
            onTap: () => _openLocation(),
          ),
          const SizedBox(height: 24),
          EnhancedCard(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Business Hours',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _buildSupportHour('Monday - Friday', '8:00 AM - 8:00 PM EST'),
                  _buildSupportHour('Saturday', '9:00 AM - 5:00 PM EST'),
                  _buildSupportHour('Sunday', '10:00 AM - 3:00 PM EST'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip(SupportPriority priority) {
    Color color;
    switch (priority) {
      case SupportPriority.low:
        color = Colors.green;
        break;
      case SupportPriority.medium:
        color = Colors.orange;
        break;
      case SupportPriority.high:
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        priority.displayName,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusChip(SupportTicketStatus status) {
    Color color;
    switch (status) {
      case SupportTicketStatus.open:
        color = Colors.blue;
        break;
      case SupportTicketStatus.inProgress:
        color = Colors.orange;
        break;
      case SupportTicketStatus.resolved:
        color = Colors.green;
        break;
      case SupportTicketStatus.closed:
        color = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: EnhancedCard(
        child: ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }

  Widget _buildSupportHour(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            hours,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _openArticle(SupportArticle article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailScreen(article: article),
      ),
    );
  }

  void _openTicket(SupportTicket ticket) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketDetailScreen(ticket: ticket),
      ),
    );
  }

  void _createTicket() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const CreateTicketSheet(),
    );
  }

  void _startLiveChat() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Starting live chat...'),
      ),
    );
  }

  void _callSupport() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening phone dialer...'),
      ),
    );
  }

  void _emailSupport() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening email client...'),
      ),
    );
  }

  void _openLocation() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening maps...'),
      ),
    );
  }
}

// Data Models
class SupportArticle {
  final String id;
  final String title;
  final String content;
  final SupportCategory category;
  final bool isPopular;
  final int views;
  final DateTime lastUpdated;

  SupportArticle({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.isPopular,
    required this.views,
    required this.lastUpdated,
  });
}

class SupportTicket {
  final String id;
  final String subject;
  final String description;
  final SupportTicketStatus status;
  final SupportPriority priority;
  final SupportCategory category;
  final DateTime createdAt;
  final DateTime lastResponse;
  final String assignedAgent;
  final DateTime? resolvedAt;

  SupportTicket({
    required this.id,
    required this.subject,
    required this.description,
    required this.status,
    required this.priority,
    required this.category,
    required this.createdAt,
    required this.lastResponse,
    required this.assignedAgent,
    this.resolvedAt,
  });
}

enum SupportCategory {
  orders,
  account,
  shipping,
  billing,
  technical,
  general,
}

extension SupportCategoryExtension on SupportCategory {
  String get displayName {
    switch (this) {
      case SupportCategory.orders:
        return 'Orders';
      case SupportCategory.account:
        return 'Account';
      case SupportCategory.shipping:
        return 'Shipping';
      case SupportCategory.billing:
        return 'Billing';
      case SupportCategory.technical:
        return 'Technical';
      case SupportCategory.general:
        return 'General';
    }
  }

  IconData get icon {
    switch (this) {
      case SupportCategory.orders:
        return Icons.shopping_bag;
      case SupportCategory.account:
        return Icons.person;
      case SupportCategory.shipping:
        return Icons.local_shipping;
      case SupportCategory.billing:
        return Icons.payment;
      case SupportCategory.technical:
        return Icons.build;
      case SupportCategory.general:
        return Icons.help;
    }
  }

  Color get color {
    switch (this) {
      case SupportCategory.orders:
        return Colors.blue;
      case SupportCategory.account:
        return Colors.green;
      case SupportCategory.shipping:
        return Colors.orange;
      case SupportCategory.billing:
        return Colors.purple;
      case SupportCategory.technical:
        return Colors.red;
      case SupportCategory.general:
        return Colors.grey;
    }
  }
}

enum SupportTicketStatus {
  open,
  inProgress,
  resolved,
  closed,
}

extension SupportTicketStatusExtension on SupportTicketStatus {
  String get displayName {
    switch (this) {
      case SupportTicketStatus.open:
        return 'Open';
      case SupportTicketStatus.inProgress:
        return 'In Progress';
      case SupportTicketStatus.resolved:
        return 'Resolved';
      case SupportTicketStatus.closed:
        return 'Closed';
    }
  }
}

enum SupportPriority {
  low,
  medium,
  high,
}

extension SupportPriorityExtension on SupportPriority {
  String get displayName {
    switch (this) {
      case SupportPriority.low:
        return 'Low';
      case SupportPriority.medium:
        return 'Medium';
      case SupportPriority.high:
        return 'High';
    }
  }
}

// Placeholder screens
class ArticleDetailScreen extends StatelessWidget {
  final SupportArticle article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(article.content),
          ],
        ),
      ),
    );
  }
}

class TicketDetailScreen extends StatelessWidget {
  final SupportTicket ticket;

  const TicketDetailScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket #${ticket.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.subject,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(ticket.description),
          ],
        ),
      ),
    );
  }
}

class CreateTicketSheet extends StatelessWidget {
  const CreateTicketSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Create Support Ticket',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          const Text('Subject'),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Enter ticket subject',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Description'),
          const SizedBox(height: 8),
          const Expanded(
            child: TextField(
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: 'Describe your issue in detail',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Support ticket created successfully'),
                  ),
                );
              },
              child: const Text('Create Ticket'),
            ),
          ),
        ],
      ),
    );
  }
}
