import 'package:flutter/material.dart';

enum OrderStatus {
  enPreparacion,
  listaParaEntregar,
  entregada,
  cancelada,
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.enPreparacion:
        return 'En preparación';
      case OrderStatus.listaParaEntregar:
        return 'Listo para entregar';
      case OrderStatus.entregada:
        return 'Entregado';
      case OrderStatus.cancelada:
        return 'Cancelado';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.enPreparacion:
        return const Color(0xFFD85A32);
      case OrderStatus.listaParaEntregar:
        return const Color(0xFF2E7D32);
      case OrderStatus.entregada:
        return Colors.grey;
      case OrderStatus.cancelada:
        return Colors.redAccent;
    }
  }
}

class OrderItem {
  final String pupusaName;
  final int quantity;
  final double unitPrice;

  OrderItem({
    required this.pupusaName,
    required this.quantity,
    required this.unitPrice,
  });

  Map<String, dynamic> toJson() => {
        'pupusaName': pupusaName,
        'quantity': quantity,
        'unitPrice': unitPrice,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        pupusaName: json['pupusaName'] ?? '',
        quantity: json['quantity'] ?? 0,
        unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      );
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

  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + (item.quantity * item.unitPrice));

  String get details =>
      items.map((e) => '${e.quantity}x ${e.pupusaName}').join(', ');

  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerName': customerName,
        'items': items.map((i) => i.toJson()).toList(),
        'timestamp': timestamp.toIso8601String(),
        'status': status.index,
      };

  factory Order.fromJson(Map<String, dynamic> json) {
    int statusIdx = json['status'] ?? 0;
    if (statusIdx < 0 || statusIdx >= OrderStatus.values.length) {
      statusIdx = 0;
    }
    return Order(
      id: json['id'] ?? '',
      customerName: json['customerName'] ?? 'Sin nombre',
      items: (json['items'] as List? ?? [])
          .map((i) => OrderItem.fromJson(i as Map<String, dynamic>))
          .toList(),
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      status: OrderStatus.values[statusIdx],
    );
  }
}