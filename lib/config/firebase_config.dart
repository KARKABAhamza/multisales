import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

/// Firebase configuration for MULTISALES platform
class FirebaseConfig {
  static const String databaseUrl = 'https://multisales-18e57-default-rtdb.firebaseio.com';
  
  static FirebaseDatabase? _database;
  
  /// Initialize Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'YOUR_API_KEY', // À remplacer par votre clé API
        appId: 'multisales-18e57',
        messagingSenderId: 'YOUR_SENDER_ID', // À remplacer
        projectId: 'multisales-18e57',
        databaseURL: databaseUrl,
      ),
    );
    
    _database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: databaseUrl,
    );
  }
  
  /// Get Firebase Database instance
  static FirebaseDatabase get database {
    if (_database == null) {
      throw Exception('Firebase not initialized. Call FirebaseConfig.initialize() first.');
    }
    return _database!;
  }
  
  /// Get reference to a specific path
  static DatabaseReference ref(String path) {
    return database.ref(path);
  }
  
  /// Products reference
  static DatabaseReference get productsRef => ref('products');
  
  /// Orders reference
  static DatabaseReference get ordersRef => ref('orders');
  
  /// Suppliers reference
  static DatabaseReference get suppliersRef => ref('suppliers');
  
  /// Invoices reference
  static DatabaseReference get invoicesRef => ref('invoices');
  
  /// Inventory reference
  static DatabaseReference get inventoryRef => ref('inventory');
}
