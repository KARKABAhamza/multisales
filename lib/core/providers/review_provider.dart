import 'package:flutter/foundation.dart';
import '../services/review_service.dart';

class ReviewProvider with ChangeNotifier {
  final ReviewServiceBase _service;
  ReviewProvider({ReviewServiceBase? service}) : _service = service ?? ReviewService();

  bool _isLoading = false;
  String? _errorMessage;
  List<ProductReview> _reviews = const [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ProductReview> get reviews => _reviews;

  Future<void> fetchReviewsForProduct(String productId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _reviews = await _service.getReviewsForProduct(productId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearReviews() {
    _reviews = const [];
    _errorMessage = null;
    notifyListeners();
  }

  Future<String?> addReview(String productId, int rating, String? comment) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final id = await _service.addReview(productId, rating, comment);
      await fetchReviewsForProduct(productId); // Refresh reviews
      return id;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}