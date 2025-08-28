import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import all the new responsive components
import '../../core/utils/responsive_layout.dart';
import '../widgets/responsive_navigation.dart';
import '../widgets/interactive_widgets.dart';
import '../widgets/display_widgets.dart';
import '../widgets/custom_widgets.dart';
import '../../core/services/api_service.dart';
import '../../core/providers/auth_provider.dart';
import '../../data/models/product_model.dart';

/// Main dashboard demonstrating all responsive components with API integration
class ResponsiveDashboard extends StatefulWidget {
  const ResponsiveDashboard({super.key});

  @override
  State<ResponsiveDashboard> createState() => _ResponsiveDashboardState();
}

class _ResponsiveDashboardState extends State<ResponsiveDashboard> {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  Map<String, dynamic> _analytics = {};
  bool _isLoading = true;
  String _currentRoute = '/dashboard';

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    try {
      // Load data from API service
      final productResponse = await _apiService.getProducts();
      final analyticsResponse = await _apiService.getDashboardAnalytics();

      setState(() {
        // Convert ProductSummary to Product for compatibility
        _products = productResponse.products
            .take(6)
            .map((summary) => Product(
                  id: summary.id,
                  name: summary.name,
                  description: 'Product description', // Default description
                  price: summary.price,
                  category: 'General', // Default category
                  imageUrls:
                      summary.imageUrl != null ? [summary.imageUrl!] : [],
                  stock: summary.inStock ? 10 : 0, // Default stock
                  isActive: true,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ))
            .toList();

        // Convert DashboardAnalytics to Map for compatibility
        _analytics = {
          'totalSales': analyticsResponse.totalSales.toStringAsFixed(2),
          'activeOrders': analyticsResponse.totalOrders,
          'totalProducts': analyticsResponse.totalProducts,
          'customerSatisfaction': 95, // Default value since not in analytics
        };

        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading dashboard data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Responsive Navigation Header
          ResponsiveNavigationHeader(
            currentRoute: _currentRoute,
            onNavigate: _handleNavigation,
            showUserActions: true,
          ),

          // Main Content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CustomLoadingIndicator(
                      style: LoadingStyle.pulse,
                      size: 60,
                    ),
                  )
                : ResponsiveContainer(
                    padding: EdgeInsets.all(context.responsiveValue(
                      mobile: 16.0,
                      tablet: 24.0,
                      desktop: 32.0,
                    )),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildWelcomeSection(),
                          const SizedBox(height: 32),
                          _buildStatsSection(),
                          const SizedBox(height: 32),
                          _buildChartsSection(),
                          const SizedBox(height: 32),
                          _buildProductsSection(),
                          const SizedBox(height: 32),
                          _buildRecentActivitySection(),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),

      // Custom Floating Action Button
      floatingActionButton: CustomFloatingButton(
        onPressed: () => _showQuickActions(context),
        showRipple: true,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.firebaseUser;
        return AnimatedGradientBackground(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
          ],
          child: ResponsiveCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveText(
                  'Welcome back, ${user?.displayName ?? 'User'}!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  mobileFontSize: 24,
                  tabletFontSize: 28,
                  desktopFontSize: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  'Here\'s what\'s happening with your business today.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                ),
                const SizedBox(height: 16),
                ResponsiveNotificationBanner(
                  message: 'You have 3 new orders and 2 pending reviews!',
                  type: NotificationType.info,
                  showAction: true,
                  actionLabel: 'View Details',
                  onAction: () => _handleNavigation('/orders'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsSection() {
    return ResponsiveLayout(
      mobile: _buildMobileStats(),
      tablet: _buildTabletStats(),
      desktop: _buildDesktopStats(),
      largeDesktop: _buildDesktopStats(),
    );
  }

  Widget _buildMobileStats() {
    return Column(
      children: _getStatsCards().map((card) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: card,
        );
      }).toList(),
    );
  }

  Widget _buildTabletStats() {
    final stats = _getStatsCards();
    return ResponsiveGrid(
      mobileColumns: 1,
      tabletColumns: 2,
      desktopColumns: 4,
      children: stats,
    );
  }

  Widget _buildDesktopStats() {
    return ResponsiveGrid(
      mobileColumns: 1,
      tabletColumns: 2,
      desktopColumns: 4,
      children: _getStatsCards(),
    );
  }

  List<Widget> _getStatsCards() {
    return [
      ResponsiveStatsCard(
        title: 'Total Sales',
        value: '\$${_analytics['totalSales'] ?? '0'}',
        subtitle: 'This month',
        icon: Icons.attach_money,
        iconColor: Colors.green,
        trend: '+12%',
        isPositiveTrend: true,
        onTap: () => _handleNavigation('/sales'),
      ),
      ResponsiveStatsCard(
        title: 'Active Orders',
        value: '${_analytics['activeOrders'] ?? '0'}',
        subtitle: 'In progress',
        icon: Icons.shopping_cart,
        iconColor: Colors.blue,
        trend: '+5%',
        isPositiveTrend: true,
        onTap: () => _handleNavigation('/orders'),
      ),
      ResponsiveStatsCard(
        title: 'Total Products',
        value: '${_analytics['totalProducts'] ?? '0'}',
        subtitle: 'In catalog',
        icon: Icons.inventory,
        iconColor: Colors.orange,
        trend: '+8%',
        isPositiveTrend: true,
        onTap: () => _handleNavigation('/catalog'),
      ),
      ResponsiveStatsCard(
        title: 'Customer Satisfaction',
        value: '${_analytics['customerSatisfaction'] ?? '0'}%',
        subtitle: 'Average rating',
        icon: Icons.star,
        iconColor: Colors.amber,
        trend: '+2%',
        isPositiveTrend: true,
        onTap: () => _handleNavigation('/analytics'),
      ),
    ];
  }

  Widget _buildChartsSection() {
    return ResponsiveTabs(
      tabs: [
        TabData(
          title: 'Sales',
          icon: const Icon(Icons.trending_up),
          content: ResponsiveChart(
            title: 'Monthly Sales',
            type: ChartType.line,
            data: [
              ChartData(label: 'Jan', value: 12000),
              ChartData(label: 'Feb', value: 15000),
              ChartData(label: 'Mar', value: 18000),
              ChartData(label: 'Apr', value: 22000),
              ChartData(label: 'May', value: 25000),
              ChartData(label: 'Jun', value: 28000),
            ],
          ),
        ),
        TabData(
          title: 'Products',
          icon: const Icon(Icons.pie_chart),
          content: ResponsiveChart(
            title: 'Product Categories',
            type: ChartType.pie,
            data: [
              ChartData(label: 'Electronics', value: 35),
              ChartData(label: 'Clothing', value: 25),
              ChartData(label: 'Home & Garden', value: 20),
              ChartData(label: 'Sports', value: 15),
              ChartData(label: 'Books', value: 5),
            ],
          ),
        ),
        TabData(
          title: 'Performance',
          icon: const Icon(Icons.bar_chart),
          content: ResponsiveChart(
            title: 'Weekly Performance',
            type: ChartType.bar,
            data: [
              ChartData(label: 'Mon', value: 85),
              ChartData(label: 'Tue', value: 92),
              ChartData(label: 'Wed', value: 78),
              ChartData(label: 'Thu', value: 88),
              ChartData(label: 'Fri', value: 95),
              ChartData(label: 'Sat', value: 82),
              ChartData(label: 'Sun', value: 90),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ResponsiveText(
              'Featured Products',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              mobileFontSize: 20,
              tabletFontSize: 22,
              desktopFontSize: 24,
            ),
            TextButton(
              onPressed: () => _handleNavigation('/catalog'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _products.isEmpty
            ? const ResponsiveEmptyState(
                title: 'No Products Found',
                description: 'Add some products to get started.',
                icon: Icons.inventory_2_outlined,
                actionLabel: 'Add Product',
              )
            : ResponsiveGrid(
                mobileColumns: 1,
                tabletColumns: 2,
                desktopColumns: 3,
                children: _products.map((product) {
                  return ResponsiveProductCard(
                    name: product.name,
                    description: product.description,
                    price: '\$${product.price.toStringAsFixed(2)}',
                    originalPrice: null, // Not available in current model
                    imageUrl: product.imageUrls.isNotEmpty
                        ? product.imageUrls.first
                        : null,
                    category: product.category,
                    rating: 4.5, // Default rating since not in model
                    reviewCount: 25, // Default review count
                    isOnSale: false, // Default since not in model
                    onTap: () => _viewProductDetails(product),
                    onFavorite: () => _toggleProductFavorite(product),
                    onAddToCart: () => _addToCart(product),
                    isFavorite: false, // Default since not in model
                  );
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          'Recent Activity',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          mobileFontSize: 20,
          tabletFontSize: 22,
          desktopFontSize: 24,
        ),
        const SizedBox(height: 16),
        ResponsiveTimeline(
          items: [
            TimelineItem(
              title: 'New Order Received',
              description: 'Order #12345 from John Doe',
              timestamp: '2 minutes ago',
              icon: Icons.shopping_bag,
              isCompleted: true,
            ),
            TimelineItem(
              title: 'Payment Processed',
              description: 'Payment of \$299.99 confirmed',
              timestamp: '15 minutes ago',
              icon: Icons.payment,
              isCompleted: true,
            ),
            TimelineItem(
              title: 'Product Review',
              description: 'New 5-star review for Product XYZ',
              timestamp: '1 hour ago',
              icon: Icons.star,
              isCompleted: true,
            ),
            TimelineItem(
              title: 'Inventory Alert',
              description: 'Low stock alert for Product ABC',
              timestamp: '2 hours ago',
              icon: Icons.warning,
              isCompleted: false,
            ),
          ],
        ),
      ],
    );
  }

  void _handleNavigation(String route) {
    setState(() {
      _currentRoute = route;
    });
    // Implement actual navigation logic here
    if (kDebugMode) {
      print('Navigating to: $route');
    }
  }

  void _viewProductDetails(Product product) {
    showDialog(
      context: context,
      builder: (context) => ResponsiveProductDetailsDialog(product: product),
    );
  }

  Future<void> _toggleProductFavorite(Product product) async {
    try {
      // For demonstration, just show a message since the API method doesn't exist yet
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Favorite toggled for ${product.name}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating favorite: $e')),
        );
      }
    }
  }

  Future<void> _addToCart(Product product) async {
    try {
      // For demonstration, just show a message since the API method doesn't exist yet
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product.name} added to cart!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding to cart: $e')),
        );
      }
    }
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      // ignore: prefer_const_constructors
      builder: (context) => ResponsiveQuickActionsSheet(),
    );
  }
}

/// Product details dialog with responsive design
class ResponsiveProductDetailsDialog extends StatelessWidget {
  final Product product;

  const ResponsiveProductDetailsDialog({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ResponsiveContainer(
        maxWidth: context.responsiveValue(
          mobile: double.infinity,
          tablet: 600.0,
          desktop: 800.0,
        ),
        child: ResponsiveCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ResponsiveText(
                    product.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    mobileFontSize: 20,
                    tabletFontSize: 22,
                    desktopFontSize: 24,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (product.imageUrls.isNotEmpty) ...[
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(product.imageUrls.first),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                product.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ResponsiveText(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    mobileFontSize: 20,
                    tabletFontSize: 22,
                    desktopFontSize: 24,
                  ),
                  ResponsiveButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Add to cart logic
                    },
                    child: const Text('Add to Cart'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Quick actions bottom sheet
class ResponsiveQuickActionsSheet extends StatelessWidget {
  const ResponsiveQuickActionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ResponsiveContainer(
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

            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: ResponsiveGrid(
                mobileColumns: 2,
                tabletColumns: 3,
                desktopColumns: 4,
                children: [
                  _buildQuickAction(
                    context,
                    'Add Product',
                    Icons.add_shopping_cart,
                    () => Navigator.pop(context),
                  ),
                  _buildQuickAction(
                    context,
                    'New Order',
                    Icons.receipt_long,
                    () => Navigator.pop(context),
                  ),
                  _buildQuickAction(
                    context,
                    'Send Message',
                    Icons.message,
                    () => Navigator.pop(context),
                  ),
                  _buildQuickAction(
                    context,
                    'View Analytics',
                    Icons.analytics,
                    () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ResponsiveCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BreathingWidget(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Demo form showcasing responsive form builder
class ResponsiveFormDemo extends StatefulWidget {
  const ResponsiveFormDemo({super.key});

  @override
  State<ResponsiveFormDemo> createState() => _ResponsiveFormDemoState();
}

class _ResponsiveFormDemoState extends State<ResponsiveFormDemo> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ResponsiveAppBar(
        title: Text('Form Demo'),
      ),
      body: ResponsiveContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              ResponsiveFormBuilder(
                isLoading: _isLoading,
                submitButtonText: 'Submit Form',
                onSubmit: _handleSubmit,
                fields: [
                  FormFieldConfig(
                    key: 'name',
                    label: 'Full Name',
                    hintText: 'Enter your full name',
                    type: FormFieldType.text,
                    prefixIcon: const Icon(Icons.person),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  FormFieldConfig(
                    key: 'email',
                    label: 'Email Address',
                    hintText: 'Enter your email',
                    type: FormFieldType.email,
                  ),
                  FormFieldConfig(
                    key: 'phone',
                    label: 'Phone Number',
                    hintText: 'Enter your phone number',
                    type: FormFieldType.text,
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  FormFieldConfig(
                    key: 'country',
                    label: 'Country',
                    hintText: 'Select your country',
                    type: FormFieldType.dropdown,
                    options: [
                      DropdownOption(label: 'United States', value: 'us'),
                      DropdownOption(label: 'Canada', value: 'ca'),
                      DropdownOption(label: 'United Kingdom', value: 'uk'),
                      DropdownOption(label: 'Australia', value: 'au'),
                      DropdownOption(label: 'Germany', value: 'de'),
                    ],
                  ),
                  FormFieldConfig(
                    key: 'birthdate',
                    label: 'Birth Date',
                    hintText: 'Select your birth date',
                    type: FormFieldType.date,
                  ),
                  FormFieldConfig(
                    key: 'bio',
                    label: 'Biography',
                    hintText: 'Tell us about yourself',
                    type: FormFieldType.multiline,
                  ),
                  FormFieldConfig(
                    key: 'newsletter',
                    hintText: 'Subscribe to newsletter',
                    type: FormFieldType.checkbox,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit(Map<String, dynamic> formData) {
    setState(() => _isLoading = true);

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form submitted successfully!')),
        );
        if (kDebugMode) {
          print('Form data: $formData');
        }
      }
    });
    if (kDebugMode) {}
  }
}
