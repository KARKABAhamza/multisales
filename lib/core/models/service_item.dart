/// Service item model for MultiSales app
class ServiceItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final String categoryName;
  final String? imageUrl;
  final List<String> features;
  final Map<String, dynamic> details;
  final bool isAvailable;
  final bool isPopular;
  final String billingType; // one-time, monthly, yearly
  final double? setupFee;
  final int? contractDuration; // in months
  final double rating;
  final int reviewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.categoryName,
    this.imageUrl,
    this.features = const [],
    this.details = const {},
    this.isAvailable = true,
    this.isPopular = false,
    this.billingType = 'monthly',
    this.setupFee,
    this.contractDuration,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create ServiceItem from Firestore document
  factory ServiceItem.fromMap(Map<String, dynamic> map) {
    return ServiceItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ?? '',
      imageUrl: map['imageUrl'],
      features: List<String>.from(map['features'] ?? []),
      details: Map<String, dynamic>.from(map['details'] ?? {}),
      isAvailable: map['isAvailable'] ?? true,
      isPopular: map['isPopular'] ?? false,
      billingType: map['billingType'] ?? 'monthly',
      setupFee: map['setupFee']?.toDouble(),
      contractDuration: map['contractDuration'],
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt']?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map['updatedAt']?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  /// Convert ServiceItem to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'imageUrl': imageUrl,
      'features': features,
      'details': details,
      'isAvailable': isAvailable,
      'isPopular': isPopular,
      'billingType': billingType,
      'setupFee': setupFee,
      'contractDuration': contractDuration,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Get formatted price based on billing type
  String getFormattedPrice({String currency = 'USD'}) {
    String priceStr;
    switch (currency) {
      case 'EUR':
        priceStr = '€${price.toStringAsFixed(2)}';
        break;
      case 'GBP':
        priceStr = '£${price.toStringAsFixed(2)}';
        break;
      default:
        priceStr = '\$${price.toStringAsFixed(2)}';
    }

    switch (billingType.toLowerCase()) {
      case 'yearly':
        return '$priceStr/year';
      case 'one-time':
        return priceStr;
      default:
        return '$priceStr/month';
    }
  }

  /// Get total first-year cost including setup fee
  double get firstYearCost {
    double totalCost = price;

    if (billingType.toLowerCase() == 'monthly') {
      totalCost *= 12;
    }

    if (setupFee != null) {
      totalCost += setupFee!;
    }

    return totalCost;
  }

  /// Check if service has contract commitment
  bool get hasContract => contractDuration != null && contractDuration! > 0;

  /// Get contract duration in readable format
  String get contractDurationText {
    if (contractDuration == null || contractDuration! <= 0) {
      return 'No contract';
    }

    if (contractDuration! == 12) {
      return '1 year contract';
    } else if (contractDuration! == 24) {
      return '2 year contract';
    } else {
      return '$contractDuration month contract';
    }
  }

  /// Create a copy with updated fields
  ServiceItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? categoryId,
    String? categoryName,
    String? imageUrl,
    List<String>? features,
    Map<String, dynamic>? details,
    bool? isAvailable,
    bool? isPopular,
    String? billingType,
    double? setupFee,
    int? contractDuration,
    double? rating,
    int? reviewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      imageUrl: imageUrl ?? this.imageUrl,
      features: features ?? this.features,
      details: details ?? this.details,
      isAvailable: isAvailable ?? this.isAvailable,
      isPopular: isPopular ?? this.isPopular,
      billingType: billingType ?? this.billingType,
      setupFee: setupFee ?? this.setupFee,
      contractDuration: contractDuration ?? this.contractDuration,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ServiceItem(id: $id, name: $name, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
