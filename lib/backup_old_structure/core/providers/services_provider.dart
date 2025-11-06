import 'package:flutter/material.dart';
import '../services/services_service.dart';

class ServicesProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<ServiceProduct> _services = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ServiceProduct> get services => _services;

  final ServicesService _service = ServicesService();

  Future<void> fetchServices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _services = await _service.fetchServices();
    } catch (e) {
      _errorMessage = 'Erreur lors du chargement des services';
    }
    _isLoading = false;
    notifyListeners();
  }
}

class ServiceProduct {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  ServiceProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory ServiceProduct.fromJson(Map<String, dynamic> json) {
    return ServiceProduct(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
