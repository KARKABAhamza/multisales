import 'package:firebase_database/firebase_database.dart';
import '../models/invoice.dart';
import '../config/firebase_config.dart';

/// Firebase-enabled service for managing invoices and billing
class FirebaseInvoiceService {
  final DatabaseReference _invoicesRef = FirebaseConfig.invoicesRef;

  /// Generate a new invoice
  Future<void> generateInvoice(Invoice invoice) async {
    await _invoicesRef.child(invoice.id).set(invoice.toJson());
  }

  /// Get an invoice by ID
  Future<Invoice?> getInvoice(String id) async {
    final snapshot = await _invoicesRef.child(id).get();
    if (snapshot.exists) {
      return Invoice.fromJson(snapshot.value as Map<dynamic, dynamic>);
    }
    return null;
  }

  /// Get all invoices
  Future<List<Invoice>> getAllInvoices() async {
    final snapshot = await _invoicesRef.get();
    if (!snapshot.exists) {
      return [];
    }
    
    final data = snapshot.value as Map<dynamic, dynamic>;
    return data.entries
        .map((entry) => Invoice.fromJson(entry.value as Map<dynamic, dynamic>))
        .toList();
  }

  /// Get invoices by status
  Future<List<Invoice>> getInvoicesByStatus(InvoiceStatus status) async {
    final snapshot = await _invoicesRef
        .orderByChild('status')
        .equalTo(status.name)
        .get();
    
    if (!snapshot.exists) {
      return [];
    }
    
    final data = snapshot.value as Map<dynamic, dynamic>;
    return data.entries
        .map((entry) => Invoice.fromJson(entry.value as Map<dynamic, dynamic>))
        .toList();
  }

  /// Get invoices by order ID
  Future<List<Invoice>> getInvoicesByOrder(String orderId) async {
    final snapshot = await _invoicesRef
        .orderByChild('orderId')
        .equalTo(orderId)
        .get();
    
    if (!snapshot.exists) {
      return [];
    }
    
    final data = snapshot.value as Map<dynamic, dynamic>;
    return data.entries
        .map((entry) => Invoice.fromJson(entry.value as Map<dynamic, dynamic>))
        .toList();
  }

  /// Update invoice status
  Future<bool> updateInvoiceStatus(String id, InvoiceStatus newStatus) async {
    try {
      await _invoicesRef.child(id).update({'status': newStatus.name});
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Mark invoice as paid
  Future<bool> markAsPaid(String id) async {
    return updateInvoiceStatus(id, InvoiceStatus.paid);
  }

  /// Cancel an invoice
  Future<bool> cancelInvoice(String id) async {
    return updateInvoiceStatus(id, InvoiceStatus.cancelled);
  }

  /// Get overdue invoices (client-side filtering)
  Future<List<Invoice>> getOverdueInvoices() async {
    final allInvoices = await getAllInvoices();
    return allInvoices.where((invoice) => invoice.isOverdue).toList();
  }

  /// Calculate total outstanding amount
  Future<double> getTotalOutstanding() async {
    final allInvoices = await getAllInvoices();
    return allInvoices
        .where((invoice) =>
            invoice.status == InvoiceStatus.issued ||
            invoice.status == InvoiceStatus.overdue)
        .fold(0.0, (sum, invoice) => sum + invoice.totalAmount);
  }

  /// Calculate total paid amount
  Future<double> getTotalPaid() async {
    final allInvoices = await getAllInvoices();
    return allInvoices
        .where((invoice) => invoice.status == InvoiceStatus.paid)
        .fold(0.0, (sum, invoice) => sum + invoice.totalAmount);
  }

  /// Get invoices within a date range (inclusive) - client-side filtering
  Future<List<Invoice>> getInvoicesByDateRange(DateTime start, DateTime end) async {
    final allInvoices = await getAllInvoices();
    return allInvoices
        .where((invoice) =>
            !invoice.issueDate.isBefore(start) && !invoice.issueDate.isAfter(end))
        .toList();
  }

  /// Get the total number of invoices
  Future<int> getInvoiceCount() async {
    final snapshot = await _invoicesRef.get();
    if (!snapshot.exists) {
      return 0;
    }
    final data = snapshot.value as Map<dynamic, dynamic>;
    return data.length;
  }

  /// Listen to real-time updates for all invoices
  Stream<List<Invoice>> watchInvoices() {
    return _invoicesRef.onValue.map((event) {
      if (!event.snapshot.exists) {
        return <Invoice>[];
      }
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      return data.entries
          .map((entry) => Invoice.fromJson(entry.value as Map<dynamic, dynamic>))
          .toList();
    });
  }

  /// Listen to real-time updates for a specific invoice
  Stream<Invoice?> watchInvoice(String id) {
    return _invoicesRef.child(id).onValue.map((event) {
      if (!event.snapshot.exists) {
        return null;
      }
      return Invoice.fromJson(event.snapshot.value as Map<dynamic, dynamic>);
    });
  }
}
