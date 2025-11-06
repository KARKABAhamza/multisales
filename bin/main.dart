import 'package:multisales/models/product.dart';
import 'package:multisales/models/order.dart';
import 'package:multisales/models/supplier.dart';
import 'package:multisales/models/invoice.dart';
import 'package:multisales/services/catalog_service.dart';
import 'package:multisales/services/order_service.dart';
import 'package:multisales/services/inventory_service.dart';
import 'package:multisales/services/invoice_service.dart';

void main() {
  print('=== MULTISALES - Plateforme B2B ===');
  print('Sourcing et approvisionnement multi-catégorie\n');
  
  // Initialize services
  final catalogService = CatalogService();
  final orderService = OrderService();
  final inventoryService = InventoryService();
  final invoiceService = InvoiceService();
  
  // Demo: Add products to catalog
  print('--- Catalogue centralisé ---');
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
  
  catalogService.addProduct(product1);
  catalogService.addProduct(product2);
  catalogService.addProduct(product3);
  
  // Initialize inventory for products
  inventoryService.initializeStock(product1.id, product1.stockQuantity);
  inventoryService.initializeStock(product2.id, product2.stockQuantity);
  inventoryService.initializeStock(product3.id, product3.stockQuantity);
  
  print('Produits ajoutés au catalogue: ${catalogService.getProductCount()}');
  catalogService.listProducts();
  
  // Demo: Create supplier
  print('\n--- Fournisseurs ---');
  final supplier = Supplier(
    id: 'S001',
    name: 'Industrial Supply Co.',
    email: 'contact@industrialsupply.com',
    phone: '+33 1 23 45 67 89',
  );
  print('Fournisseur: ${supplier.name}');
  
  // Demo: Create order
  print('\n--- Gestion de commandes ---');
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
  
  orderService.createOrder(order);
  print('Commande créée: ${order.id}');
  print('Total: ${order.totalAmount.toStringAsFixed(2)} €');
  
  // Demo: Update inventory
  print('\n--- Gestion de stock ---');
  inventoryService.updateStock(product1.id, -5);
  inventoryService.updateStock(product2.id, -10);
  print('Stock mis à jour après commande');
  
  // Demo: Generate invoice
  print('\n--- Facturation ---');
  final invoice = Invoice(
    id: 'INV001',
    orderId: order.id,
    issueDate: DateTime.now(),
    dueDate: DateTime.now().add(Duration(days: 30)),
    amount: order.totalAmount,
    status: InvoiceStatus.issued,
  );
  
  invoiceService.generateInvoice(invoice);
  print('Facture générée: ${invoice.id}');
  print('Montant: ${invoice.amount.toStringAsFixed(2)} €');
  print('Échéance: ${invoice.dueDate.toString().split(' ')[0]}');
  
  print('\n=== Plateforme opérationnelle ===');
}
