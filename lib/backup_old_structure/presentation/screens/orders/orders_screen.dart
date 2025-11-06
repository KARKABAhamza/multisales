// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/enhanced_ui_components.dart';
import '../../widgets/enhanced_dashboard_widgets.dart';

// --- Stub Models & Enums for UI Testing ---
enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  returned,
  refunded,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.returned:
        return 'Returned';
      case OrderStatus.refunded:
        return 'Refunded';
    }
  }
}

enum PaymentMethod { creditCard, paypal, bankTransfer }
enum PaymentStatus { paid, pending, failed }

class Address {
  final String street, city, state, zipCode, country;
  Address({required this.street, required this.city, required this.state, required this.zipCode, required this.country});
}

class OrderItem {
  final String productId, productName, productSku, productImageUrl;
  final int quantity;
  final double unitPrice, totalPrice;
  OrderItem({required this.productId, required this.productName, required this.productSku, required this.productImageUrl, required this.quantity, required this.unitPrice, required this.totalPrice});
}

class Order {
  final String id, userId, trackingNumber;
  final List<OrderItem> items;
  final double subtotal, tax, shipping, total;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final Address shippingAddress;
  final DateTime createdAt, updatedAt;
  final DateTime? deliveredAt, estimatedDelivery;
  Order({required this.id, required this.userId, required this.items, required this.subtotal, required this.tax, required this.shipping, required this.total, required this.status, required this.paymentMethod, required this.paymentStatus, required this.shippingAddress, required this.createdAt, required this.updatedAt, this.deliveredAt, this.estimatedDelivery, this.trackingNumber = ''});
  String get orderNumber => 'ORD-$id';
  bool get isTrackable => trackingNumber.isNotEmpty;
  bool get canBeCancelled => status == OrderStatus.pending || status == OrderStatus.confirmed || status == OrderStatus.processing;
}

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  OrderStatus? _selectedStatus;
  String _searchQuery = '';
  OrderSortOption _sortOption = OrderSortOption.dateDesc;
  bool _showFilters = false;

  // Sample order data
  final List<Order> _allOrders = [
    Order(
      id: '1',
      userId: 'user1',
      items: [
        OrderItem(
          productId: '1',
          productName: 'Professional Laptop',
          productSku: 'LAP-001',
          productImageUrl: 'https://example.com/laptop.jpg',
          quantity: 1,
          unitPrice: 1199.99,
          totalPrice: 1199.99,
        ),
      ],
      subtotal: 1199.99,
      tax: 95.99,
      shipping: 9.99,
      total: 1305.97,
      status: OrderStatus.delivered,
      paymentMethod: PaymentMethod.creditCard,
      paymentStatus: PaymentStatus.paid,
      shippingAddress: Address(
        street: '123 Business Ave',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        country: 'USA',
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      deliveredAt: DateTime.now().subtract(const Duration(days: 2)),
      trackingNumber: 'TRK123456789',
    ),
    Order(
      id: '2',
      userId: 'user1',
      items: [
        OrderItem(
          productId: '2',
          productName: 'Wireless Headphones',
          productSku: 'HEAD-002',
          productImageUrl: 'https://example.com/headphones.jpg',
          quantity: 2,
          unitPrice: 299.99,
          totalPrice: 599.98,
        ),
      ],
      subtotal: 599.98,
      tax: 47.99,
      shipping: 9.99,
      total: 657.96,
      status: OrderStatus.shipped,
      paymentMethod: PaymentMethod.creditCard,
      paymentStatus: PaymentStatus.paid,
      shippingAddress: Address(
        street: '123 Business Ave',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        country: 'USA',
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
      trackingNumber: 'TRK987654321',
    ),
    Order(
      id: '3',
      userId: 'user1',
      items: [
        OrderItem(
          productId: '3',
          productName: 'Business Suit',
          productSku: 'SUIT-003',
          productImageUrl: 'https://example.com/suit.jpg',
          quantity: 1,
          unitPrice: 499.99,
          totalPrice: 499.99,
        ),
      ],
      subtotal: 499.99,
      tax: 39.99,
      shipping: 14.99,
      total: 554.97,
      status: OrderStatus.processing,
      paymentMethod: PaymentMethod.creditCard,
      paymentStatus: PaymentStatus.paid,
      shippingAddress: Address(
        street: '123 Business Ave',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        country: 'USA',
      ),
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  List<Order> get _filteredOrders {
    var orders = _allOrders.where((order) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        if (!order.orderNumber.toLowerCase().contains(searchLower) &&
            !order.items.any((item) =>
                item.productName.toLowerCase().contains(searchLower))) {
          return false;
        }
      }

      // Status filter
      if (_selectedStatus != null && order.status != _selectedStatus) {
        return false;
      }

      return true;
    }).toList();

    // Sort orders
    switch (_sortOption) {
      case OrderSortOption.dateDesc:
        orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case OrderSortOption.dateAsc:
        orders.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case OrderSortOption.amountDesc:
        orders.sort((a, b) => b.total.compareTo(a.total));
        break;
      case OrderSortOption.amountAsc:
        orders.sort((a, b) => a.total.compareTo(b.total));
        break;
      case OrderSortOption.statusAsc:
        orders.sort(
            (a, b) => a.status.displayName.compareTo(b.status.displayName));
        break;
    }

    return orders;
  }

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

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
    HapticFeedback.lightImpact();
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedStatus = null;
      _sortOption = OrderSortOption.dateDesc;
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
            ),
            onPressed: _toggleFilters,
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order history opened'),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.list_alt),
              text: 'All Orders',
            ),
            Tab(
              icon: Icon(Icons.local_shipping),
              text: 'Active',
            ),
            Tab(
              icon: Icon(Icons.history),
              text: 'Completed',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          EnhancedSearchBar(
            hintText: 'Search orders...',
            onSearch: _onSearch,
          ),

          // Filters Panel
          if (_showFilters)
            EnhancedCard(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filters',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        TextButton(
                          onPressed: _clearFilters,
                          child: const Text('Clear All'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Status Filter
                    Text(
                      'Order Status',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: OrderStatus.values.map((status) {
                        final isSelected = _selectedStatus == status;
                        return FilterChip(
                          label: Text(status.displayName),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedStatus = selected ? status : null;
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // Sort Options
                    Text(
                      'Sort By',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<OrderSortOption>(
                      value: _sortOption,
                      isExpanded: true,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _sortOption = value;
                          });
                        }
                      },
                      items: OrderSortOption.values.map((option) {
                        return DropdownMenuItem(
                          value: option,
                          child: Text(option.displayName),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

          // Orders List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOrdersList(_filteredOrders),
                _buildOrdersList(_filteredOrders
                    .where((order) =>
                        order.status == OrderStatus.pending ||
                        order.status == OrderStatus.processing ||
                        order.status == OrderStatus.shipped)
                    .toList()),
                _buildOrdersList(_filteredOrders
                    .where((order) =>
                        order.status == OrderStatus.delivered ||
                        order.status == OrderStatus.cancelled)
                    .toList()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/catalog');
        },
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Shop Now'),
      ),
    );
  }

  Widget _buildOrdersList(List<Order> orders) {
    if (orders.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Order order) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => _showOrderDetails(order),
        child: EnhancedCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.orderNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    _buildStatusChip(order.status),
                  ],
                ),

                const SizedBox(height: 8),

                // Order date
                Text(
                  'Ordered on ${_formatDate(order.createdAt)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 12),

                // Items summary
                Text(
                  '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),

                // First item preview
                if (order.items.isNotEmpty)
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.image,
                          color: Colors.grey[400],
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.items.first.productName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Qty: ${order.items.first.quantity}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (order.items.length > 1)
                        Text(
                          '+${order.items.length - 1} more',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),

                const SizedBox(height: 12),

                // Total and actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: \$${order.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        if (order.isTrackable)
                          TextButton(
                            onPressed: () => _trackOrder(order),
                            child: const Text('Track'),
                          ),
                        if (order.canBeCancelled)
                          TextButton(
                            onPressed: () => _cancelOrder(order),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Cancel'),
                          ),
                        if (order.status == OrderStatus.delivered)
                          TextButton(
                            onPressed: () => _reorderItems(order),
                            child: const Text('Reorder'),
                          ),
                      ],
                    ),
                  ],
                ),

                // Delivery info
                if (order.estimatedDelivery != null ||
                    order.deliveredAt != null)
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getDeliveryInfoColor(order.status)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getDeliveryInfoColor(order.status)
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getDeliveryIcon(order.status),
                          color: _getDeliveryInfoColor(order.status),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _getDeliveryText(order),
                            style: TextStyle(
                              color: _getDeliveryInfoColor(order.status),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    Color color;
    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        break;
      case OrderStatus.confirmed:
        color = Colors.blue;
        break;
      case OrderStatus.processing:
        color = Colors.blue;
        break;
      case OrderStatus.shipped:
        color = Colors.purple;
        break;
      case OrderStatus.delivered:
        color = Colors.green;
        break;
      case OrderStatus.cancelled:
        color = Colors.red;
        break;
      case OrderStatus.returned:
        color = Colors.red;
        break;
      case OrderStatus.refunded:
        color = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No orders found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start shopping to see your orders here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/catalog');
            },
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }

  Color _getDeliveryInfoColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
      case OrderStatus.confirmed:
      case OrderStatus.processing:
        return Colors.orange;
      case OrderStatus.shipped:
        return Colors.blue;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
      case OrderStatus.returned:
        return Colors.red;
      case OrderStatus.refunded:
        return Colors.grey;
    }
  }

  IconData _getDeliveryIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
      case OrderStatus.confirmed:
      case OrderStatus.processing:
        return Icons.schedule;
      case OrderStatus.shipped:
        return Icons.local_shipping;
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.cancelled:
      case OrderStatus.returned:
        return Icons.cancel;
      case OrderStatus.refunded:
        return Icons.money_off;
    }
  }

  String _getDeliveryText(Order order) {
    switch (order.status) {
      case OrderStatus.pending:
        return 'Order being prepared';
      case OrderStatus.confirmed:
        return 'Order confirmed';
      case OrderStatus.processing:
        return 'Order is being processed';
      case OrderStatus.shipped:
        return order.estimatedDelivery != null
            ? 'Estimated delivery: ${_formatDate(order.estimatedDelivery!)}'
            : 'Order shipped';
      case OrderStatus.delivered:
        return order.deliveredAt != null
            ? 'Delivered on ${_formatDate(order.deliveredAt!)}'
            : 'Order delivered';
      case OrderStatus.cancelled:
        return 'Order cancelled';
      case OrderStatus.returned:
        return 'Order returned';
      case OrderStatus.refunded:
        return 'Order refunded';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showOrderDetails(Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => OrderDetailsSheet(order: order),
    );
  }

  void _trackOrder(Order order) {
  if (order.trackingNumber.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Order Tracking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order: ${order.orderNumber}'),
              const SizedBox(height: 8),
              Text('Tracking Number: ${order.trackingNumber}'),
              const SizedBox(height: 8),
              Text('Status: ${order.status.displayName}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening tracking details...'),
                  ),
                );
              },
              child: const Text('Track Package'),
            ),
          ],
        ),
      );
    }
  }

  void _cancelOrder(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content:
            Text('Are you sure you want to cancel order ${order.orderNumber}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order ${order.orderNumber} cancelled'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _reorderItems(Order order) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Items from order ${order.orderNumber} added to cart'),
        action: SnackBarAction(
          label: 'VIEW CART',
          onPressed: () {
            // Navigate to cart
          },
        ),
      ),
    );
  }
}

class OrderDetailsSheet extends StatelessWidget {
  final Order order;

  const OrderDetailsSheet({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
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

          // Order header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.orderNumber,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getStatusColor(order.status).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  order.status.displayName,
                  style: TextStyle(
                    color: _getStatusColor(order.status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            'Ordered on ${_formatDate(order.createdAt)}',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: 20),

          // Items
          Text(
            'Items (${order.items.length})',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: ListView.builder(
              itemCount: order.items.length,
              itemBuilder: (context, index) {
                final item = order.items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.image,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Qty: ${item.quantity} × \$${item.unitPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${item.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const Divider(),

          // Shipping address
          Text(
            'Shipping Address',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '${order.shippingAddress.street}\n'
            '${order.shippingAddress.city}, ${order.shippingAddress.state} ${order.shippingAddress.zipCode}\n'
            '${order.shippingAddress.country}',
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),

          const SizedBox(height: 16),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Actions
          Row(
            children: [
              if (order.isTrackable) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Track order
                    },
                    child: const Text('Track Order'),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              if (order.status == OrderStatus.delivered)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Reorder
                    },
                    child: const Text('Reorder'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.shipped:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
      case OrderStatus.returned:
        return Colors.red;
      case OrderStatus.refunded:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

enum OrderSortOption {
  dateDesc,
  dateAsc,
  amountDesc,
  amountAsc,
  statusAsc,
}

extension OrderSortOptionExtension on OrderSortOption {
  String get displayName {
    switch (this) {
      case OrderSortOption.dateDesc:
        return 'Newest First';
      case OrderSortOption.dateAsc:
        return 'Oldest First';
      case OrderSortOption.amountDesc:
        return 'Highest Amount';
      case OrderSortOption.amountAsc:
        return 'Lowest Amount';
      case OrderSortOption.statusAsc:
        return 'Status';
    }
  }
}
