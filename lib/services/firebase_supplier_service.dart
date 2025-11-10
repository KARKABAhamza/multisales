import 'package:firebase_database/firebase_database.dart';
import '../models/supplier.dart';
import '../config/firebase_config.dart';

/// Firebase-enabled service for managing suppliers
class FirebaseSupplierService {
  final DatabaseReference _suppliersRef = FirebaseConfig.suppliersRef;

  /// Add a supplier
  Future<void> addSupplier(Supplier supplier) async {
    await _suppliersRef.child(supplier.id).set(supplier.toJson());
  }

  /// Get a supplier by ID
  Future<Supplier?> getSupplier(String id) async {
    final snapshot = await _suppliersRef.child(id).get();
    if (snapshot.exists) {
      return Supplier.fromJson(snapshot.value as Map<dynamic, dynamic>);
    }
    return null;
  }

  /// Get all suppliers
  Future<List<Supplier>> getAllSuppliers() async {
    final snapshot = await _suppliersRef.get();
    if (!snapshot.exists) {
      return [];
    }
    
    final data = snapshot.value as Map<dynamic, dynamic>;
    return data.entries
        .map((entry) => Supplier.fromJson(entry.value as Map<dynamic, dynamic>))
        .toList();
  }

  /// Search suppliers by name (client-side filtering)
  Future<List<Supplier>> searchSuppliers(String query) async {
    final allSuppliers = await getAllSuppliers();
    final lowerQuery = query.toLowerCase();
    return allSuppliers
        .where((supplier) => supplier.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Update a supplier
  Future<bool> updateSupplier(String id, Supplier supplier) async {
    try {
      await _suppliersRef.child(id).update(supplier.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Remove a supplier
  Future<bool> removeSupplier(String id) async {
    try {
      await _suppliersRef.child(id).remove();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get the total number of suppliers
  Future<int> getSupplierCount() async {
    final snapshot = await _suppliersRef.get();
    if (!snapshot.exists) {
      return 0;
    }
    final data = snapshot.value as Map<dynamic, dynamic>;
    return data.length;
  }

  /// Listen to real-time updates for all suppliers
  Stream<List<Supplier>> watchSuppliers() {
    return _suppliersRef.onValue.map((event) {
      if (!event.snapshot.exists) {
        return <Supplier>[];
      }
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      return data.entries
          .map((entry) => Supplier.fromJson(entry.value as Map<dynamic, dynamic>))
          .toList();
    });
  }

  /// Listen to real-time updates for a specific supplier
  Stream<Supplier?> watchSupplier(String id) {
    return _suppliersRef.child(id).onValue.map((event) {
      if (!event.snapshot.exists) {
        return null;
      }
      return Supplier.fromJson(event.snapshot.value as Map<dynamic, dynamic>);
    });
  }
}
