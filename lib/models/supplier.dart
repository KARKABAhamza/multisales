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
}
