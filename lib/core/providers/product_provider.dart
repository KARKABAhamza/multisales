import 'package:flutter/foundation.dart';
import '../services/product_service.dart';
import '../../models/product_models.dart';

class ProductProvider with ChangeNotifier {
  final ProductServiceBase _service;
  ProductProvider({ProductServiceBase? service}) : _service = service ?? ProductService();

  bool _isLoading = false;
  String? _errorMessage;
  List<Product> _products = const [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _products = await _service.listProducts();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
