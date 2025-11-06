/// Utility functions for document management
class DocumentUtils {
  /// Generate a unique document ID
  static String generateDocumentId(String prefix) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$prefix-$timestamp';
  }

  /// Format currency amount
  static String formatCurrency(double amount, {String symbol = '€'}) {
    return '${amount.toStringAsFixed(2)} $symbol';
  }

  /// Format date
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Generate invoice number
  static String generateInvoiceNumber() {
    final now = DateTime.now();
    final year = now.year.toString();
    final month = now.month.toString().padLeft(2, '0');
    final timestamp = now.millisecondsSinceEpoch % 100000;
    return 'INV-$year$month-$timestamp';
  }

  /// Generate order number
  static String generateOrderNumber() {
    final now = DateTime.now();
    final year = now.year.toString();
    final month = now.month.toString().padLeft(2, '0');
    final timestamp = now.millisecondsSinceEpoch % 100000;
    return 'ORD-$year$month-$timestamp';
  }

  /// Validate email format
  /// Uses a more comprehensive regex that handles most common email formats
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'
    );
    return emailRegex.hasMatch(email);
  }

  /// Validate phone number format (French)
  static bool isValidPhoneNumber(String phone) {
    final phoneRegex = RegExp(r'^\+?\d{10,15}$');
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }
}
