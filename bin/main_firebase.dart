import 'package:multisales/models/product.dart';
import 'package:multisales/models/order.dart';
import 'package:multisales/models/supplier.dart';
import 'package:multisales/models/invoice.dart';
import 'package:multisales/config/firebase_config.dart';
import 'package:multisales/services/firebase_catalog_service.dart';
import 'package:multisales/services/firebase_order_service.dart';
import 'package:multisales/services/firebase_inventory_service.dart';
import 'package:multisales/services/firebase_invoice_service.dart';
import 'package:multisales/services/firebase_supplier_service.dart';

/// Example demonstrating Firebase integration with MULTISALES
Future<void> main() async {
  print('=== MULTISALES - Firebase Integration ===');
  print('Plateforme B2B avec synchronisation en temps réel\n');
  
  try {
    // Initialize Firebase
    print('Initialisation de Firebase...');
    await FirebaseConfig.initialize();
    print('✓ Firebase initialisé\n');
    
    // Initialize services
    final catalogService = FirebaseCatalogService();
    final orderService = FirebaseOrderService();
    final inventoryService = FirebaseInventoryService();
    final invoiceService = FirebaseInvoiceService();
    final supplierService = FirebaseSupplierService();
    
    // Demo: Add products to catalog
    print('--- Catalogue centralisé (Firebase) ---');
    final product1 = Product(
      id: 'P001',
      name: 'Chaise de bureau ergonomique',
      category: 'Mobilier de bureau',
      price: 150.00,
      stockQuantity: 50,
    );
    
    final product2 = Product(
      id: 'P002',
      name: 'Draps hôteliers 100% coton',
      category: 'Équipements hôteliers',
      price: 45.00,
      stockQuantity: 200,
    );
    
    final product3 = Product(
      id: 'P003',
      name: 'Gants de protection industriels',
      category: 'Consommables industriels',
      price: 12.50,
      stockQuantity: 500,
    );
    
    await catalogService.addProduct(product1);
    await catalogService.addProduct(product2);
    await catalogService.addProduct(product3);
    
    // Initialize inventory
    await inventoryService.initializeStock(product1.id, product1.stockQuantity);
    await inventoryService.initializeStock(product2.id, product2.stockQuantity);
    await inventoryService.initializeStock(product3.id, product3.stockQuantity);
    
    final productCount = await catalogService.getProductCount();
    print('Produits ajoutés au catalogue Firebase: $productCount');
    
    final allProducts = await catalogService.getAllProducts();
    for (var product in allProducts) {
      print('  - ${product.name} (${product.category}): €${product.price.toStringAsFixed(2)}');
    }
    print();
    
    // Demo: Create supplier
    print('--- Fournisseurs (Firebase) ---');
    final supplier = Supplier(
      id: 'S001',
      name: 'Industrial Supply Co.',
      email: 'contact@industrialsupply.com',
      phone: '+33 1 23 45 67 89',
      address: '123 Rue de l\'Industrie, Paris',
    );
    
    await supplierService.addSupplier(supplier);
    print('Fournisseur ajouté: ${supplier.name}');
    print();
    
    // Demo: Create order
    print('--- Gestion de commandes (Firebase) ---');
    final order = Order(
      id: 'O001',
      supplierId: supplier.id,
      items: [
        OrderItem(productId: product1.id, quantity: 5, unitPrice: product1.price),
        OrderItem(productId: product2.id, quantity: 10, unitPrice: product2.price),
      ],
      status: OrderStatus.pending,
      orderDate: DateTime.now(),
    );
    
    await orderService.createOrder(order);
    print('Commande créée: ${order.id}');
    print('Total: €${order.totalAmount.toStringAsFixed(2)}');
    print();
    
    // Demo: Update inventory
    print('--- Gestion de stock (Firebase) ---');
    await inventoryService.updateStock(product1.id, -5);
    await inventoryService.updateStock(product2.id, -10);
    
    final stock1 = await inventoryService.getStock(product1.id);
    final stock2 = await inventoryService.getStock(product2.id);
    
    print('Stock mis à jour:');
    print('  - ${product1.name}: $stock1 unités');
    print('  - ${product2.name}: $stock2 unités');
    print();
    
    // Demo: Generate invoice
    print('--- Facturation (Firebase) ---');
    final invoice = Invoice(
      id: 'INV001',
      orderId: order.id,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(Duration(days: 30)),
      amount: order.totalAmount,
      status: InvoiceStatus.issued,
      taxAmount: order.totalAmount * 0.20,
    );
    
    await invoiceService.generateInvoice(invoice);
    print('Facture générée: ${invoice.id}');
    print('Montant HT: €${invoice.amount.toStringAsFixed(2)}');
    print('TVA (20%): €${invoice.taxAmount!.toStringAsFixed(2)}');
    print('Total TTC: €${invoice.totalAmount.toStringAsFixed(2)}');
    print();
    
    // Demo: Statistics
    print('--- Statistiques (Firebase) ---');
    final totalProducts = await catalogService.getProductCount();
    final totalOrders = await orderService.getOrderCount();
    final totalRevenue = await orderService.getTotalRevenue();
    final totalOutstanding = await invoiceService.getTotalOutstanding();
    final totalInventory = await inventoryService.getTotalItemsCount();
    
    print('Produits au catalogue: $totalProducts');
    print('Commandes: $totalOrders');
    print('Chiffre d\'affaires: €${totalRevenue.toStringAsFixed(2)}');
    print('Factures en attente: €${totalOutstanding.toStringAsFixed(2)}');
    print('Stock total: $totalInventory unités');
    print();
    
    print('=== Plateforme opérationnelle avec Firebase ===');
    print('URL: ${FirebaseConfig.databaseUrl}');
    
  } catch (e) {
    print('Erreur: $e');
    print('\nNote: Assurez-vous de configurer correctement Firebase:');
    print('1. Remplacez les valeurs dans lib/config/firebase_config.dart');
    print('2. Mettez à jour les règles de sécurité dans votre console Firebase');
    print('3. Configurez l\'authentification Firebase si nécessaire');
  }
}
