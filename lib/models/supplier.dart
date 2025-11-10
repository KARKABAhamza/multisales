/// Represents a supplier in the system
class Supplier {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? address;
  final String? taxId;
  final List<String>? categories;

  Supplier({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    this.taxId,
    this.categories,
  });

  /// Create a copy of the supplier with updated fields
  Supplier copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? taxId,
    List<String>? categories,
  }) {
    return Supplier(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      taxId: taxId ?? this.taxId,
      categories: categories ?? this.categories,
    );
  }

  @override
  String toString() {
    return 'Supplier(id: $id, name: $name, email: $email, phone: $phone)';
  }

  /// Convert Supplier to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'taxId': taxId,
      'categories': categories,
    };
  }

  /// Create Supplier from JSON (Firebase)
  factory Supplier.fromJson(Map<dynamic, dynamic> json) {
    return Supplier(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String?,
      taxId: json['taxId'] as String?,
      categories: json['categories'] != null
          ? List<String>.from(json['categories'] as List<dynamic>)
          : null,
    );
  }
}
