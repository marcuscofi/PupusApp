import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/pupusa_item.dart';

enum TimeFilter { diario, semanal, mensual }

class AppState extends ChangeNotifier {
  TimeFilter _selectedFilter = TimeFilter.diario;
  TimeFilter get selectedFilter => _selectedFilter;

  void setFilter(TimeFilter filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  final List<PupusaItem> _pupusas = [
    PupusaItem(id: '1', name: 'Revueltas', description: 'Chicharrón, frijol y queso', price: 1.00, isActive: true),
    PupusaItem(id: '2', name: 'Queso con Loroco', description: 'Queso artesanal y loroco fresco', price: 1.25, isActive: true),
    PupusaItem(id: '3', name: 'Frijol con Queso', description: 'Frijoles rojos refritos y queso', price: 1.00, isActive: true),
    PupusaItem(id: '4', name: 'Chicharrón', description: 'Chicharrón molido sazonado', price: 1.25, isActive: true),
    PupusaItem(id: '5', name: 'Queso', description: 'Solo queso fundido elástico', price: 1.00, isActive: true),
  ];

  final List<Order> _orders = [
    Order(
      id: '#1084',
      customerName: 'María Santos',
      items: [
        OrderItem(pupusaName: 'Queso', quantity: 3, unitPrice: 1.00),
        OrderItem(pupusaName: 'Frijol con Queso', quantity: 2, unitPrice: 1.00),
        OrderItem(pupusaName: 'Revueltas', quantity: 1, unitPrice: 1.00),
      ],
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      status: OrderStatus.enPreparacion,
    ),
    Order(
      id: '#1083',
      customerName: 'Carlos Gómez',
      items: [
        OrderItem(pupusaName: 'Revueltas', quantity: 4, unitPrice: 1.00),
        OrderItem(pupusaName: 'Chicharrón', quantity: 2, unitPrice: 1.25),
      ],
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      status: OrderStatus.entregada,
    ),
  ];

  List<PupusaItem> get pupusas => _pupusas;
  List<Order> get orders => _orders;

  List<Order> get pendingOrders => _orders
      .where((o) => o.status == OrderStatus.enPreparacion || o.status == OrderStatus.listaParaEntregar)
      .toList();

  List<Order> get recentDeliveredOrders => _orders
      .where((o) => o.status == OrderStatus.entregada)
      .take(3)
      .toList();

  List<Order> get historyDeliveredOrders => _orders
      .where((o) => o.status == OrderStatus.entregada)
      .toList();

  int get activePupusasCount => _pupusas.where((p) => p.isActive).length;

  void togglePupusaStatus(int index, bool value) {
    _pupusas[index].isActive = value;
    notifyListeners();
  }

  void updatePupusa(String id, String name, String description, double price) {
    final index = _pupusas.indexWhere((p) => p.id == id);
    if (index != -1) {
      _pupusas[index].name = name;
      _pupusas[index].description = description;
      _pupusas[index].price = price;
      notifyListeners();
    }
  }

  void deletePupusa(String id) {
    _pupusas.removeWhere((p) => p.id == id);
    notifyListeners();
  }

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

  void deleteOrder(String id) {
    _orders.removeWhere((o) => o.id == id);
    notifyListeners();
  }

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

  void addOrder(String customerName, List<OrderItem> items) {
    final nextNumber = 1085 + _orders.length;
    _orders.insert(
      0,
      Order(
        id: '#$nextNumber',
        customerName: customerName.isEmpty ? 'Sin nombre' : customerName,
        items: items,
        timestamp: DateTime.now(),
        status: OrderStatus.enPreparacion,
      ),
    );
    notifyListeners();
  }

  List<Order> getDeliveredOrdersForDate(DateTime date) {
    return _orders.where((o) {
      return o.status == OrderStatus.entregada &&
          o.timestamp.year == date.year &&
          o.timestamp.month == date.month &&
          o.timestamp.day == date.day;
    }).toList();
  }

  // --- FILTRADO DE ESTADÍSTICAS ---
  List<Order> get filteredDeliveredOrders {
    final now = DateTime.now();
    return historyDeliveredOrders.where((o) {
      switch (_selectedFilter) {
        case TimeFilter.diario:
          return o.timestamp.year == now.year &&
              o.timestamp.month == now.month &&
              o.timestamp.day == now.day;
        case TimeFilter.semanal:
          final diff = now.difference(o.timestamp).inDays;
          return diff >= 0 && diff < 7;
        case TimeFilter.mensual:
          return o.timestamp.year == now.year && o.timestamp.month == now.month;
      }
    }).toList();
  }

  double get filteredTotalRevenue {
    return filteredDeliveredOrders.fold(0.0, (sum, o) => sum + o.totalPrice);
  }

  int get filteredTotalPupusasSold {
    int total = 0;
    for (var order in filteredDeliveredOrders) {
      for (var item in order.items) {
        total += item.quantity;
      }
    }
    return total;
  }

  Map<String, int> get filteredSalesByPupusaType {
    final Map<String, int> map = {};
    for (var order in filteredDeliveredOrders) {
      for (var item in order.items) {
        map[item.pupusaName] = (map[item.pupusaName] ?? 0) + item.quantity;
      }
    }
    return map;
  }

  Map<String, double> get filteredRevenueByPupusaType {
    final Map<String, double> map = {};
    for (var order in filteredDeliveredOrders) {
      for (var item in order.items) {
        final totalItemPrice = item.quantity * item.unitPrice;
        map[item.pupusaName] = (map[item.pupusaName] ?? 0.0) + totalItemPrice;
      }
    }
    return map;
  }
}