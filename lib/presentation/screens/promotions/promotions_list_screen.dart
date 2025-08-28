// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/optimized_auth_provider.dart';

class PromotionsListScreen extends StatefulWidget {
  const PromotionsListScreen({super.key});

  @override
  State<PromotionsListScreen> createState() => _PromotionsListScreenState();
}

class _PromotionsListScreenState extends State<PromotionsListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All', 'New Product', 'Seasonal', 'Bundle', 'Discount', 'Limited Time'
  ];

  final List<Map<String, dynamic>> _promotions = [
    {
      'id': 'PROMO001',
      'title': 'Spring Software Bundle',
      'description': 'Complete productivity suite with 30% discount for new customers',
      'category': 'Bundle',
      'discount': '30%',
      'startDate': '2024-03-01',
      'endDate': '2024-04-30',
      'status': 'Active',
      'priority': 'High',
      'targetAudience': 'New Customers',
      'usage': 45,
      'maxUsage': 100,
      'revenue': 125000,
      'image': 'https://via.placeholder.com/150',
    },
    {
      'id': 'PROMO002',
      'title': 'Enterprise Upgrade Deal',
      'description': 'Upgrade to Enterprise plan and save 25% for the first year',
      'category': 'Discount',
      'discount': '25%',
      'startDate': '2024-02-15',
      'endDate': '2024-06-15',
      'status': 'Active',
      'priority': 'Medium',
      'targetAudience': 'Existing Customers',
      'usage': 23,
      'maxUsage': 50,
      'revenue': 87500,
      'image': 'https://via.placeholder.com/150',
    },
    {
      'id': 'PROMO003',
      'title': 'Black Friday Special',
      'description': 'Biggest sale of the year - up to 50% off on all products',
      'category': 'Seasonal',
      'discount': '50%',
      'startDate': '2024-11-24',
      'endDate': '2024-11-30',
      'status': 'Scheduled',
      'priority': 'High',
      'targetAudience': 'All Customers',
      'usage': 0,
      'maxUsage': 500,
      'revenue': 0,
      'image': 'https://via.placeholder.com/150',
    },
    {
      'id': 'PROMO004',
      'title': 'Loyalty Rewards Program',
      'description': 'Earn points for every purchase and redeem for exclusive benefits',
      'category': 'New Product',
      'discount': 'Variable',
      'startDate': '2024-01-01',
      'endDate': '2024-12-31',
      'status': 'Active',
      'priority': 'Medium',
      'targetAudience': 'Loyal Customers',
      'usage': 187,
      'maxUsage': 1000,
      'revenue': 342000,
      'image': 'https://via.placeholder.com/150',
    },
    {
      'id': 'PROMO005',
      'title': 'Flash Sale - 24 Hours Only',
      'description': 'Lightning deal on premium features for today only',
      'category': 'Limited Time',
      'discount': '40%',
      'startDate': '2024-03-15',
      'endDate': '2024-03-16',
      'status': 'Expired',
      'priority': 'High',
      'targetAudience': 'All Customers',
      'usage': 78,
      'maxUsage': 100,
      'revenue': 45600,
      'image': 'https://via.placeholder.com/150',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Promotions'),
        backgroundColor: theme.colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active', icon: Icon(Icons.play_circle_outline)),
            Tab(text: 'Scheduled', icon: Icon(Icons.schedule)),
            Tab(text: 'Analytics', icon: Icon(Icons.analytics)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _createNewPromotion(),
          ),
        ],
      ),
      body: Consumer<OptimizedAuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              _buildFilterBar(theme),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPromotionsList(['Active'], theme),
                    _buildPromotionsList(['Scheduled'], theme),
                    _buildAnalyticsView(theme),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createNewPromotion(),
        icon: const Icon(Icons.add),
        label: const Text('New Promotion'),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter by Category',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionsList(List<String> statusFilter, ThemeData theme) {
    final filteredPromotions = _promotions.where((promo) {
      final matchesStatus = statusFilter.contains(promo['status']);
      final matchesCategory = _selectedCategory == 'All' || promo['category'] == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          promo['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          promo['description'].toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesStatus && matchesCategory && matchesSearch;
    }).toList();

    if (filteredPromotions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.campaign,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No promotions found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or create a new promotion',
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
      itemCount: filteredPromotions.length,
      itemBuilder: (context, index) {
        return _buildPromotionCard(filteredPromotions[index], theme);
      },
    );
  }

  Widget _buildPromotionCard(Map<String, dynamic> promotion, ThemeData theme) {
    final status = promotion['status'] as String;
    final priority = promotion['priority'] as String;

    Color statusColor;
    Color priorityColor;
    IconData statusIcon;

    switch (status) {
      case 'Active':
        statusColor = Colors.green;
        statusIcon = Icons.play_circle_filled;
        break;
      case 'Scheduled':
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        break;
      case 'Expired':
        statusColor = Colors.red;
        statusIcon = Icons.stop_circle;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    switch (priority) {
      case 'High':
        priorityColor = Colors.red;
        break;
      case 'Medium':
        priorityColor = Colors.orange;
        break;
      case 'Low':
        priorityColor = Colors.green;
        break;
      default:
        priorityColor = Colors.grey;
    }

    final usagePercentage = (promotion['usage'] as int) / (promotion['maxUsage'] as int);

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
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.campaign, size: 30, color: Colors.grey),
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
                              promotion['title'],
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: priorityColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: priorityColor.withOpacity(0.3)),
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
                      Text(
                        promotion['description'],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip(Icons.local_offer, promotion['discount'], theme),
                const SizedBox(width: 8),
                _buildInfoChip(Icons.category, promotion['category'], theme),
                const SizedBox(width: 8),
                _buildInfoChip(statusIcon, status, theme, color: statusColor),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Usage Progress',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: usagePercentage,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                usagePercentage > 0.8 ? Colors.red :
                                usagePercentage > 0.6 ? Colors.orange : Colors.green,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${promotion['usage']}/${promotion['maxUsage']}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Revenue',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '\$${(promotion['revenue'] as int).toStringAsFixed(0)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Valid: ${promotion['startDate']} - ${promotion['endDate']}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const Spacer(),
                Text(
                  'Target: ${promotion['targetAudience']}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _editPromotion(promotion),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _sharePromotion(promotion),
                    icon: const Icon(Icons.share, size: 16),
                    label: const Text('Share'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _viewDetails(promotion),
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

  Widget _buildInfoChip(IconData icon, String label, ThemeData theme, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? theme.primaryColor).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: (color ?? theme.primaryColor).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color ?? theme.primaryColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color ?? theme.primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsView(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildAnalyticsCard('Total Promotions', '5', Icons.campaign, Colors.blue, theme),
          const SizedBox(height: 16),
          _buildAnalyticsCard('Active Promotions', '3', Icons.play_circle_filled, Colors.green, theme),
          const SizedBox(height: 16),
          _buildAnalyticsCard('Total Revenue', '\$600,100', Icons.attach_money, Colors.orange, theme),
          const SizedBox(height: 16),
          _buildAnalyticsCard('Avg. Usage Rate', '67%', Icons.trending_up, Colors.purple, theme),
          const SizedBox(height: 20),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Performance Overview',
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
                          Icon(Icons.bar_chart, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Analytics Chart'),
                          Text('Coming Soon', style: TextStyle(color: Colors.grey)),
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

  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color, ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Promotions'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter promotion name or description...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
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

  void _createNewPromotion() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create new promotion feature coming soon')),
    );
  }

  void _editPromotion(Map<String, dynamic> promotion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editing ${promotion['title']}...')),
    );
  }

  void _sharePromotion(Map<String, dynamic> promotion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${promotion['title']}...')),
    );
  }

  void _viewDetails(Map<String, dynamic> promotion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing details for ${promotion['title']}...')),
    );
  }
}
