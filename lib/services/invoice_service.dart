import '../models/invoice.dart';

/// Service for managing invoices and billing
class InvoiceService {
  final Map<String, Invoice> _invoices = {};

  /// Generate a new invoice
  void generateInvoice(Invoice invoice) {
    _invoices[invoice.id] = invoice;
  }

  /// Get an invoice by ID
  Invoice? getInvoice(String id) {
    return _invoices[id];
  }

  /// Get all invoices
  List<Invoice> getAllInvoices() {
    return _invoices.values.toList();
  }

  /// Get invoices by status
  List<Invoice> getInvoicesByStatus(InvoiceStatus status) {
    return _invoices.values
        .where((invoice) => invoice.status == status)
        .toList();
  }

  /// Get invoices by order ID
  List<Invoice> getInvoicesByOrder(String orderId) {
    return _invoices.values
        .where((invoice) => invoice.orderId == orderId)
        .toList();
  }

  /// Update invoice status
  bool updateInvoiceStatus(String id, InvoiceStatus newStatus) {
    final invoice = _invoices[id];
    if (invoice != null) {
      _invoices[id] = invoice.copyWith(status: newStatus);
      return true;
    }
    return false;
  }

  /// Mark invoice as paid
  bool markAsPaid(String id) {
    return updateInvoiceStatus(id, InvoiceStatus.paid);
  }

  /// Cancel an invoice
  bool cancelInvoice(String id) {
    return updateInvoiceStatus(id, InvoiceStatus.cancelled);
  }

  /// Get overdue invoices
  List<Invoice> getOverdueInvoices() {
    return _invoices.values.where((invoice) => invoice.isOverdue).toList();
  }

  /// Calculate total outstanding amount
  double getTotalOutstanding() {
    return _invoices.values
        .where((invoice) =>
            invoice.status == InvoiceStatus.issued ||
            invoice.status == InvoiceStatus.overdue)
        .fold(0.0, (sum, invoice) => sum + invoice.totalAmount);
  }

  /// Calculate total paid amount
  double getTotalPaid() {
    return _invoices.values
        .where((invoice) => invoice.status == InvoiceStatus.paid)
        .fold(0.0, (sum, invoice) => sum + invoice.totalAmount);
  }

  /// Get invoices within a date range
  List<Invoice> getInvoicesByDateRange(DateTime start, DateTime end) {
    return _invoices.values
        .where((invoice) =>
            invoice.issueDate.isAfter(start) && invoice.issueDate.isBefore(end))
        .toList();
  }

  /// Get the total number of invoices
  int getInvoiceCount() {
    return _invoices.length;
  }
}
