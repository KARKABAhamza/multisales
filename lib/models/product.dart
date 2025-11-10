import 'package:flutter/foundation.dart';

@immutable
class Product {
  final String id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final List<String> imageUrls;

  const Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.imageUrls = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        price: (json['price'] as num).toDouble(),
        stock: (json['stock'] as num).toInt(),
        imageUrls: (json['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        'imageUrls': imageUrls,
      };
}