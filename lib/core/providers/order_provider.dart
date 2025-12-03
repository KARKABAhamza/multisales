import 'package:flutter/foundation.dart';
import '../services/order_service.dart';
import '../../models/product_models.dart';

class OrderProvider with ChangeNotifier {
  final OrderServiceBase _service;
  OrderProvider({OrderServiceBase? service}) : _service = service ?? OrderService();

  bool _isLoading = false;
  String? _errorMessage;
  List<OrderModel> _orders = const [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<OrderModel> get orders => _orders;

  Future<String?> placeOrder({required String userId, required List<OrderItem> items}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
  final id = await _service.placeOrder(userId: userId, items: items);
      return id;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOrdersForUser(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _orders = await _service.listOrdersForUser(userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
