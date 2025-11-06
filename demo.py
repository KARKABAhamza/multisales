#!/usr/bin/env python3
"""
MULTISALES - B2B Multi-Category Sourcing and Procurement Platform
Demo script to showcase the platform functionality
"""

from datetime import datetime, timedelta
from typing import List, Dict, Optional
from dataclasses import dataclass, field
from enum import Enum


class OrderStatus(Enum):
    PENDING = "pending"
    CONFIRMED = "confirmed"
    PROCESSING = "processing"
    SHIPPED = "shipped"
    DELIVERED = "delivered"
    CANCELLED = "cancelled"


class InvoiceStatus(Enum):
    DRAFT = "draft"
    ISSUED = "issued"
    PAID = "paid"
    OVERDUE = "overdue"
    CANCELLED = "cancelled"


@dataclass
class Product:
    id: str
    name: str
    category: str
    price: float
    stock_quantity: int
    description: Optional[str] = None
    supplier: Optional[str] = None

    def __str__(self):
        return f"{self.name} ({self.category}): €{self.price:.2f} - Stock: {self.stock_quantity}"


@dataclass
class OrderItem:
    product_id: str
    quantity: int
    unit_price: float

    @property
    def total_price(self):
        return self.quantity * self.unit_price


@dataclass
class Order:
    id: str
    supplier_id: str
    items: List[OrderItem]
    status: OrderStatus
    order_date: datetime
    delivery_date: Optional[datetime] = None
    notes: Optional[str] = None

    @property
    def total_amount(self):
        return sum(item.total_price for item in self.items)

    def __str__(self):
        return f"Order {self.id}: {len(self.items)} items, Total: €{self.total_amount:.2f}, Status: {self.status.value}"


@dataclass
class Supplier:
    id: str
    name: str
    email: str
    phone: str
    address: Optional[str] = None
    tax_id: Optional[str] = None

    def __str__(self):
        return f"{self.name} ({self.email}, {self.phone})"


@dataclass
class Invoice:
    id: str
    order_id: str
    issue_date: datetime
    due_date: datetime
    amount: float
    status: InvoiceStatus
    notes: Optional[str] = None
    tax_amount: float = 0.0
    discount_amount: float = 0.0

    @property
    def total_amount(self):
        return self.amount + self.tax_amount - self.discount_amount

    @property
    def is_overdue(self):
        return self.status == InvoiceStatus.ISSUED and datetime.now() > self.due_date

    def __str__(self):
        return f"Invoice {self.id}: €{self.amount:.2f}, Status: {self.status.value}, Due: {self.due_date.strftime('%Y-%m-%d')}"


class CatalogService:
    def __init__(self):
        self.products: Dict[str, Product] = {}

    def add_product(self, product: Product):
        self.products[product.id] = product

    def get_product(self, product_id: str) -> Optional[Product]:
        return self.products.get(product_id)

    def get_all_products(self) -> List[Product]:
        return list(self.products.values())

    def get_products_by_category(self, category: str) -> List[Product]:
        return [p for p in self.products.values() if p.category == category]

    def search_products(self, query: str) -> List[Product]:
        query_lower = query.lower()
        return [p for p in self.products.values() if query_lower in p.name.lower()]

    def get_product_count(self) -> int:
        return len(self.products)


class OrderService:
    def __init__(self):
        self.orders: Dict[str, Order] = {}

    def create_order(self, order: Order):
        self.orders[order.id] = order

    def get_order(self, order_id: str) -> Optional[Order]:
        return self.orders.get(order_id)

    def get_all_orders(self) -> List[Order]:
        return list(self.orders.values())

    def get_orders_by_status(self, status: OrderStatus) -> List[Order]:
        return [o for o in self.orders.values() if o.status == status]

    def update_order_status(self, order_id: str, new_status: OrderStatus) -> bool:
        if order_id in self.orders:
            order = self.orders[order_id]
            self.orders[order_id] = Order(
                id=order.id,
                supplier_id=order.supplier_id,
                items=order.items,
                status=new_status,
                order_date=order.order_date,
                delivery_date=order.delivery_date,
                notes=order.notes
            )
            return True
        return False

    def get_total_revenue(self) -> float:
        return sum(order.total_amount for order in self.orders.values())


class InventoryService:
    def __init__(self):
        self.inventory: Dict[str, int] = {}

    def initialize_stock(self, product_id: str, quantity: int):
        self.inventory[product_id] = quantity

    def get_stock(self, product_id: str) -> int:
        return self.inventory.get(product_id, 0)

    def update_stock(self, product_id: str, change: int) -> bool:
        current_stock = self.get_stock(product_id)
        new_stock = current_stock + change
        
        if new_stock < 0:
            print(f"Erreur: Stock insuffisant pour le produit {product_id}")
            return False
        
        self.inventory[product_id] = new_stock
        return True

    def is_in_stock(self, product_id: str, required_quantity: int) -> bool:
        return self.get_stock(product_id) >= required_quantity


class InvoiceService:
    def __init__(self):
        self.invoices: Dict[str, Invoice] = {}

    def generate_invoice(self, invoice: Invoice):
        self.invoices[invoice.id] = invoice

    def get_invoice(self, invoice_id: str) -> Optional[Invoice]:
        return self.invoices.get(invoice_id)

    def get_all_invoices(self) -> List[Invoice]:
        return list(self.invoices.values())

    def get_invoices_by_status(self, status: InvoiceStatus) -> List[Invoice]:
        return [i for i in self.invoices.values() if i.status == status]

    def mark_as_paid(self, invoice_id: str) -> bool:
        if invoice_id in self.invoices:
            invoice = self.invoices[invoice_id]
            self.invoices[invoice_id] = Invoice(
                id=invoice.id,
                order_id=invoice.order_id,
                issue_date=invoice.issue_date,
                due_date=invoice.due_date,
                amount=invoice.amount,
                status=InvoiceStatus.PAID,
                notes=invoice.notes,
                tax_amount=invoice.tax_amount,
                discount_amount=invoice.discount_amount
            )
            return True
        return False

    def get_total_outstanding(self) -> float:
        return sum(
            i.total_amount for i in self.invoices.values()
            if i.status in [InvoiceStatus.ISSUED, InvoiceStatus.OVERDUE]
        )


def main():
    print("=" * 60)
    print("MULTISALES - Plateforme B2B")
    print("Sourcing et approvisionnement multi-catégorie")
    print("=" * 60)
    print()

    # Initialize services
    catalog_service = CatalogService()
    order_service = OrderService()
    inventory_service = InventoryService()
    invoice_service = InvoiceService()

    # Demo: Add products to catalog
    print("--- Catalogue centralisé ---")
    products = [
        Product(
            id="P001",
            name="Chaise de bureau ergonomique",
            category="Mobilier de bureau",
            price=150.00,
            stock_quantity=50,
            description="Chaise ergonomique avec support lombaire"
        ),
        Product(
            id="P002",
            name="Draps hôteliers 100% coton",
            category="Équipements hôteliers",
            price=45.00,
            stock_quantity=200,
            description="Draps de qualité supérieure"
        ),
        Product(
            id="P003",
            name="Gants de protection industriels",
            category="Consommables industriels",
            price=12.50,
            stock_quantity=500,
            description="Gants résistants aux produits chimiques"
        ),
    ]

    for product in products:
        catalog_service.add_product(product)
        inventory_service.initialize_stock(product.id, product.stock_quantity)

    print(f"Produits ajoutés au catalogue: {catalog_service.get_product_count()}")
    for product in catalog_service.get_all_products():
        print(f"  - {product}")
    print()

    # Demo: Create supplier
    print("--- Fournisseurs ---")
    supplier = Supplier(
        id="S001",
        name="Industrial Supply Co.",
        email="contact@industrialsupply.com",
        phone="+33 1 23 45 67 89",
        address="123 Rue de l'Industrie, Paris"
    )
    print(f"Fournisseur: {supplier}")
    print()

    # Demo: Create order
    print("--- Gestion de commandes ---")
    order = Order(
        id="O001",
        supplier_id=supplier.id,
        items=[
            OrderItem(product_id="P001", quantity=5, unit_price=150.00),
            OrderItem(product_id="P002", quantity=10, unit_price=45.00),
        ],
        status=OrderStatus.PENDING,
        order_date=datetime.now()
    )

    order_service.create_order(order)
    print(f"Commande créée: {order}")
    print(f"Détails des articles:")
    for item in order.items:
        product = catalog_service.get_product(item.product_id)
        print(f"  - {product.name if product else 'Unknown'}: {item.quantity} x €{item.unit_price:.2f} = €{item.total_price:.2f}")
    print()

    # Demo: Update inventory
    print("--- Gestion de stock ---")
    inventory_service.update_stock("P001", -5)
    inventory_service.update_stock("P002", -10)
    print("Stock mis à jour après commande:")
    for product in products:
        stock = inventory_service.get_stock(product.id)
        print(f"  - {product.name}: {stock} unités")
    print()

    # Demo: Generate invoice
    print("--- Facturation ---")
    invoice = Invoice(
        id="INV001",
        order_id=order.id,
        issue_date=datetime.now(),
        due_date=datetime.now() + timedelta(days=30),
        amount=order.total_amount,
        status=InvoiceStatus.ISSUED,
        tax_amount=order.total_amount * 0.20,  # 20% TVA
    )

    invoice_service.generate_invoice(invoice)
    print(f"Facture générée: {invoice}")
    print(f"Montant HT: €{invoice.amount:.2f}")
    print(f"TVA (20%): €{invoice.tax_amount:.2f}")
    print(f"Total TTC: €{invoice.total_amount:.2f}")
    print(f"Échéance: {invoice.due_date.strftime('%d/%m/%Y')}")
    print()

    # Demo: Statistics
    print("--- Statistiques de la plateforme ---")
    print(f"Produits au catalogue: {catalog_service.get_product_count()}")
    print(f"Commandes en cours: {len(order_service.get_orders_by_status(OrderStatus.PENDING))}")
    print(f"Chiffre d'affaires total: €{order_service.get_total_revenue():.2f}")
    print(f"Factures en attente: €{invoice_service.get_total_outstanding():.2f}")
    print(f"Stock total: {sum(inventory_service.get_stock(p.id) for p in products)} unités")
    print()

    print("=" * 60)
    print("Plateforme opérationnelle")
    print("Repository: https://github.com/KARKABAhamza/multisales")
    print("=" * 60)


if __name__ == "__main__":
    main()
