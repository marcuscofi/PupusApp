enum OrderStatus { enPreparacion, listaParaEntregar, entregada }

class OrderItem {
  final String pupusaName;
  final int quantity;
  final double unitPrice;

  OrderItem({
    required this.pupusaName,
    required this.quantity,
    required this.unitPrice,
  });
}

class Order {
  final String id;
  final String customerName;
  final List<OrderItem> items;
  final DateTime timestamp;
  OrderStatus status;

  Order({
    required this.id,
    required this.customerName,
    required this.items,
    required this.timestamp,
    required this.status,
  });

  String get details {
    return items.map((i) => '${i.quantity} de ${i.pupusaName}').join(', ');
  }

  double get totalPrice {
    return items.fold(0.0, (sum, item) => sum + (item.quantity * item.unitPrice));
  }

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'Justo ahora';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}