enum OrderStatus { enPreparacion, listaParaEntregar, entregada }

class PupusaItem {
  final String id;
  final String name;
  final String description;
  double price;
  bool isActive;

  PupusaItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.isActive = true,
  });
}

class Order {
  final String id;
  final String customerName;
  final String details;
  final String timeAgo;
  OrderStatus status;

  Order({
    required this.id,
    required this.customerName,
    required this.details,
    required this.timeAgo,
    required this.status,
  });
}