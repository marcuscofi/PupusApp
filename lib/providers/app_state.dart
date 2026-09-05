import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/pupusa_item.dart';

class AppState extends ChangeNotifier {
  // Lista inicial de Pupusas (Configuración)
  final List<PupusaItem> _pupusas = [
    PupusaItem(id: '1', name: 'Revueltas', description: 'Chicharrón, frijol y queso', price: 1.00, isActive: true),
    PupusaItem(id: '2', name: 'Queso con Loroco', description: 'Queso artesanal y loroco fresco', price: 1.25, isActive: true),
    PupusaItem(id: '3', name: 'Frijol con Queso', description: 'Frijoles rojos refritos y queso', price: 1.00, isActive: true),
    PupusaItem(id: '4', name: 'Chicharrón', description: 'Chicharrón molido sazonado', price: 1.25, isActive: true),
    PupusaItem(id: '5', name: 'Queso', description: 'Solo queso fundido elástico', price: 1.00, isActive: true),
    PupusaItem(id: '6', name: 'Ajo con Queso', description: 'Ajo rostizado y queso fundido', price: 1.50, isActive: false),
  ];

  // Lista inicial de Pedidos
  final List<Order> _orders = [
    Order(id: '#1084', customerName: 'María Santos', details: '3 de Queso, 2 de Frijol con Queso, 1 Revuelta', timeAgo: 'Hace 5 min', status: OrderStatus.enPreparacion),
    Order(id: '#1083', customerName: 'Sin nombre', details: '4 Revueltas, 2 de Chicharrón, 2 de Loroco', timeAgo: 'Hace 12 min', status: OrderStatus.listaParaEntregar),
    Order(id: '#1082', customerName: 'Sin nombre', details: '5 de Loroco con Queso, 2 de Frijol', timeAgo: 'Hace 20 min', status: OrderStatus.entregada),
    Order(id: '#1081', customerName: 'Sin nombre', details: '10 Revueltas familiares', timeAgo: 'Hace 35 min', status: OrderStatus.entregada),
  ];

  List<PupusaItem> get pupusas => _pupusas;
  List<Order> get orders => _orders;

  int get activePupusasCount => _pupusas.where((p) => p.isActive).length;

  // Cambiar estado de una pupusa (Activa/Inactiva)
  void togglePupusaStatus(int index, bool value) {
    _pupusas[index].isActive = value;
    notifyListeners();
  }

  // Actualizar precio de pupusa
  void updatePupusaPrice(int index, double newPrice) {
    _pupusas[index].price = newPrice;
    notifyListeners();
  }

  // Agregar nuevo sabor
  void addPupusa(String name, String description, double price) {
    _pupusas.add(PupusaItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      price: price,
      isActive: true,
    ));
    notifyListeners();
  }

  // Avanzar estado del pedido
  void advanceOrderStatus(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      if (_orders[index].status == OrderStatus.enPreparacion) {
        _orders[index].status = OrderStatus.listaParaEntregar;
      } else if (_orders[index].status == OrderStatus.listaParaEntregar) {
        _orders[index].status = OrderStatus.entregada;
      }
      notifyListeners();
    }
  }

  // Agregar pedido rápido
  void addOrder(String customerName, String details) {
    final nextNumber = 1085 + _orders.length - 4;
    _orders.insert(
      0,
      Order(
        id: '#$nextNumber',
        customerName: customerName.isEmpty ? 'Sin nombre' : customerName,
        details: details,
        timeAgo: 'Justo ahora',
        status: OrderStatus.enPreparacion,
      ),
    );
    notifyListeners();
  }
}