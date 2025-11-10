import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
	final String id;
	final String name;
	final String? description;
	final double price;
	final int stock;
	final List<String> imageUrls;
	final bool active;
	final DateTime? createdAt;
	final DateTime? updatedAt;

	const Product({
		required this.id,
		required this.name,
		this.description,
		required this.price,
		required this.stock,
		this.imageUrls = const [],
		this.active = true,
		this.createdAt,
		this.updatedAt,
	});

	factory Product.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
		final data = snap.data() ?? <String, dynamic>{};
		return Product(
			id: snap.id,
			name: (data['name'] ?? '') as String,
			description: data['description'] as String?,
			price: (data['price'] is int)
					? (data['price'] as int).toDouble()
					: (data['price'] as num?)?.toDouble() ?? 0.0,
			stock: (data['stock'] as num?)?.toInt() ?? 0,
			imageUrls: (data['imageUrls'] is List)
					? List<String>.from(data['imageUrls'] as List)
					: const <String>[],
			active: (data['active'] as bool?) ?? true,
			createdAt: (data['createdAt'] is Timestamp)
					? (data['createdAt'] as Timestamp).toDate()
					: null,
			updatedAt: (data['updatedAt'] is Timestamp)
					? (data['updatedAt'] as Timestamp).toDate()
					: null,
		);
	}

	Map<String, dynamic> toMap() {
		return {
			'name': name,
			'description': description,
			'price': price,
			'stock': stock,
			'imageUrls': imageUrls,
			'active': active,
			'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
			'updatedAt': FieldValue.serverTimestamp(),
		};
	}
}

class OrderItem {
	final String productId;
	final int qty;
	final double unitPrice;

	const OrderItem({required this.productId, required this.qty, required this.unitPrice});

	Map<String, dynamic> toMap() => {
				'productId': productId,
				'qty': qty,
				'unitPrice': unitPrice,
			};
}

class OrderModel {
	final String id;
	final String userId;
	final List<OrderItem> items;
	final double total;
	final String status;
	final DateTime? createdAt;

	const OrderModel({
		required this.id,
		required this.userId,
		required this.items,
		required this.total,
		required this.status,
		this.createdAt,
	});
}

