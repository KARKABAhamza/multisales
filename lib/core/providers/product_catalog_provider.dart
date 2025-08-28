import 'package:flutter/foundation.dart' hide Category;
import '../services/firestore_service.dart';
import '../models/product.dart';
import '../models/service_item.dart';
import '../models/category.dart';

/// Provider for product and service catalog management
class ProductCatalogProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  // Catalog state
  List<Product> _products = [];
  List<ServiceItem> _services = [];
  List<Category> _categories = [];
  List<Product> _featuredProducts = [];
  List<ServiceItem> _popularServices = [];

  // Filter and search state
  String _searchQuery = '';
  String? _selectedCategoryId;
  final Map<String, dynamic> _priceFilter = {};
  final List<String> _selectedFeatures = [];

  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Product> get products => _filteredProducts;
  List<ServiceItem> get services => _filteredServices;
  List<Category> get categories => _categories;
  List<Product> get featuredProducts => _featuredProducts;
  List<ServiceItem> get popularServices => _popularServices;
  String get searchQuery => _searchQuery;
  String? get selectedCategoryId => _selectedCategoryId;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Initialize catalog data
  Future<void> initialize() async {
    _setLoading(true);
    try {
      await Future.wait([
        _loadCategories(),
        _loadProducts(),
        _loadServices(),
        _loadFeaturedContent(),
      ]);
      _setError(null);
    } catch (e) {
      _setError('Failed to load catalog: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Load product categories
  Future<void> _loadCategories() async {
    try {
      // Try to load from Firestore first
      final result =
          await _firestoreService.getCollection(collection: 'categories');
      if (result['success'] == true && result['data'] != null) {
        final List<dynamic> categoriesData = result['data'];
        _categories =
            categoriesData.map((data) => Category.fromMap(data)).toList();
        return;
      }
    } catch (e) {
      // Fall back to mock data if Firestore fails
      debugPrint('Failed to load categories from Firestore: $e');
    }

    // Mock data as fallback
    final now = DateTime.now();
    _categories = [
      Category(
          id: '1',
          name: 'Internet Services',
          icon: 'wifi',
          createdAt: now,
          updatedAt: now),
      Category(
          id: '2',
          name: 'Mobile Plans',
          icon: 'phone',
          createdAt: now,
          updatedAt: now),
      Category(
          id: '3',
          name: 'Business Solutions',
          icon: 'business',
          createdAt: now,
          updatedAt: now),
      Category(
          id: '4',
          name: 'Equipment',
          icon: 'router',
          createdAt: now,
          updatedAt: now),
    ];
  }

  /// Load products
  Future<void> _loadProducts() async {
    try {
      // Try to load from Firestore first
      final result =
          await _firestoreService.getCollection(collection: 'products');
      if (result['success'] == true && result['data'] != null) {
        final List<dynamic> productsData = result['data'];
        _products = productsData.map((data) => Product.fromMap(data)).toList();
        return;
      }
    } catch (e) {
      // Fall back to mock data if Firestore fails
      debugPrint('Failed to load products from Firestore: $e');
    }

    // Mock data as fallback
    final now = DateTime.now();
    _products = [
      Product(
        id: '1',
        name: 'Fiber Internet 100MB',
        description: 'High-speed fiber internet connection',
        price: 299.99,
        categoryId: '1',
        categoryName: 'Internet Services',
        imageUrls: ['https://example.com/fiber.jpg'],
        features: ['100MB Download', '50MB Upload', 'Unlimited Data'],
        isAvailable: true,
        sku: 'FIBER-100MB',
        createdAt: now,
        updatedAt: now,
      ),
      // Add more products...
    ];
  }

  /// Load services
  Future<void> _loadServices() async {
    try {
      // Try to load from Firestore first
      final result =
          await _firestoreService.getCollection(collection: 'services');
      if (result['success'] == true && result['data'] != null) {
        final List<dynamic> servicesData = result['data'];
        _services =
            servicesData.map((data) => ServiceItem.fromMap(data)).toList();
        return;
      }
    } catch (e) {
      // Fall back to mock data if Firestore fails
      debugPrint('Failed to load services from Firestore: $e');
    }

    // Mock data as fallback
    final now = DateTime.now();
    _services = [
      ServiceItem(
        id: '1',
        name: 'Technical Support',
        description: '24/7 technical support service',
        price: 99.99,
        categoryId: '1',
        categoryName: 'Internet Services',
        billingType: 'monthly',
        contractDuration: 12,
        isAvailable: true,
        createdAt: now,
        updatedAt: now,
      ),
      // Add more services...
    ];
  }

  /// Load featured content
  Future<void> _loadFeaturedContent() async {
    _featuredProducts = _products.where((p) => p.isFeatured).toList();
    _popularServices = _services.where((s) => s.isPopular).toList();
  }

  /// Get filtered products based on current filters
  List<Product> get _filteredProducts {
    var filtered = _products.where((product) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!product.name.toLowerCase().contains(query) &&
            !product.description.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Category filter
      if (_selectedCategoryId != null &&
          product.categoryId != _selectedCategoryId) {
        return false;
      }

      // Price filter
      if (_priceFilter.isNotEmpty) {
        final minPrice = _priceFilter['min'] as double?;
        final maxPrice = _priceFilter['max'] as double?;
        if (minPrice != null && product.price < minPrice) return false;
        if (maxPrice != null && product.price > maxPrice) return false;
      }

      // Features filter
      if (_selectedFeatures.isNotEmpty) {
        final hasAllFeatures = _selectedFeatures.every(
          (feature) => product.features.contains(feature),
        );
        if (!hasAllFeatures) return false;
      }

      return true;
    }).toList();

    return filtered;
  }

  /// Get filtered services
  List<ServiceItem> get _filteredServices {
    var filtered = _services.where((service) {
      // Similar filtering logic for services
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!service.name.toLowerCase().contains(query) &&
            !service.description.toLowerCase().contains(query)) {
          return false;
        }
      }

      if (_selectedCategoryId != null &&
          service.categoryId != _selectedCategoryId) {
        return false;
      }

      return true;
    }).toList();

    return filtered;
  }

  /// Update search query
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Set category filter
  void setCategoryFilter(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  /// Set price filter
  void setPriceFilter(double? minPrice, double? maxPrice) {
    _priceFilter.clear();
    if (minPrice != null) _priceFilter['min'] = minPrice;
    if (maxPrice != null) _priceFilter['max'] = maxPrice;
    notifyListeners();
  }

  /// Toggle feature filter
  void toggleFeatureFilter(String feature) {
    if (_selectedFeatures.contains(feature)) {
      _selectedFeatures.remove(feature);
    } else {
      _selectedFeatures.add(feature);
    }
    notifyListeners();
  }

  /// Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategoryId = null;
    _priceFilter.clear();
    _selectedFeatures.clear();
    notifyListeners();
  }

  /// Get product by ID
  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get service by ID
  ServiceItem? getServiceById(String id) {
    try {
      return _services.firstWhere((service) => service.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get category by ID
  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Compare products
  List<Map<String, dynamic>> compareProducts(List<String> productIds) {
    final products = productIds
        .map((id) => getProductById(id))
        .where((product) => product != null)
        .cast<Product>()
        .toList();

    return products
        .map((product) => {
              'id': product.id,
              'name': product.name,
              'price': product.price,
              'features': product.features,
              'rating': product.rating,
            })
        .toList();
  }

  /// Add a new product
  Future<bool> addProduct(Product product) async {
    try {
      final result = await _firestoreService.createDocument(
        collection: 'products',
        documentId: product.id,
        data: product.toMap(),
      );

      if (result['success'] == true) {
        _products.add(product);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to add product: ${e.toString()}');
      return false;
    }
  }

  /// Update an existing product
  Future<bool> updateProduct(Product product) async {
    try {
      final result = await _firestoreService.updateDocument(
        collection: 'products',
        documentId: product.id,
        data: product.toMap(),
      );

      if (result['success'] == true) {
        final index = _products.indexWhere((p) => p.id == product.id);
        if (index != -1) {
          _products[index] = product;
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to update product: ${e.toString()}');
      return false;
    }
  }

  /// Delete a product
  Future<bool> deleteProduct(String productId) async {
    try {
      final result = await _firestoreService.deleteDocument(
        collection: 'products',
        documentId: productId,
      );

      if (result['success'] == true) {
        _products.removeWhere((p) => p.id == productId);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to delete product: ${e.toString()}');
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }
}
