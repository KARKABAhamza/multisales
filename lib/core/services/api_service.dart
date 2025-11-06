// ApiService stub for demo

class ApiService {
  Future<ProductResponse> getProducts() async {
    // Return dummy data
    return ProductResponse(products: [
      ProductSummary(id: '1', name: 'Demo Product', price: 99.99, imageUrl: null, inStock: true),
    ]);
  }

  Future<DashboardAnalytics> getDashboardAnalytics() async {
    // Return dummy data
    return DashboardAnalytics(totalSales: 10000, totalOrders: 50, totalProducts: 20);
  }
}

class ProductResponse {
  final List<ProductSummary> products;
  ProductResponse({required this.products});
}

class ProductSummary {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final bool inStock;
  ProductSummary({required this.id, required this.name, required this.price, this.imageUrl, required this.inStock});
}

class DashboardAnalytics {
  final double totalSales;
  final int totalOrders;
  final int totalProducts;
  DashboardAnalytics({required this.totalSales, required this.totalOrders, required this.totalProducts});
}
