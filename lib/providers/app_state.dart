import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';
import '../models/pupusa_item.dart';

enum TimeFilter { diario, semanal, mensual }

class BackupValidationResult {
  final bool isValid;
  final String? errorMessage;
  final int formatVersion;
  final String exportedAt;
  final int ordersCount;
  final int pupusasCount;
  final Map<String, dynamic>? rawData;

  BackupValidationResult({
    required this.isValid,
    this.errorMessage,
    this.formatVersion = 1,
    this.exportedAt = '',
    this.ordersCount = 0,
    this.pupusasCount = 0,
    this.rawData,
  });
}

class AppState extends ChangeNotifier {
  AppState() {
    _cargarDeMemoria();
  }

  TimeFilter _selectedFilter = TimeFilter.diario;
  TimeFilter get selectedFilter => _selectedFilter;

  void setFilter(TimeFilter filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  List<PupusaItem> _pupusas = [
    PupusaItem(id: '1', name: 'Revueltas', description: 'Chicharrón, frijol y queso', price: 1.00, isActive: true),
    PupusaItem(id: '2', name: 'Queso con Loroco', description: 'Queso artesanal y loroco fresco', price: 1.25, isActive: true),
    PupusaItem(id: '3', name: 'Frijol con Queso', description: 'Frijoles rojos refritos y queso', price: 1.00, isActive: true),
    PupusaItem(id: '4', name: 'Chicharrón', description: 'Chicharrón molido sazonado', price: 1.25, isActive: true),
    PupusaItem(id: '5', name: 'Queso', description: 'Solo queso fundido elástico', price: 1.00, isActive: true),
  ];

  List<Order> _orders = [];

  List<PupusaItem> get pupusas => _pupusas;
  List<Order> get orders => _orders;

  // --- PEDIDOS PENDIENTES ---
  List<Order> get pendingOrders => _orders
      .where((o) => o.status == OrderStatus.enPreparacion || o.status == OrderStatus.listaParaEntregar)
      .toList();

  // --- ÚLTIMAS 3 VENTAS ENTREGADAS ---
  List<Order> get recentDeliveredOrders {
    final delivered = _orders.where((o) => o.status == OrderStatus.entregada).toList();
    delivered.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return delivered.take(3).toList();
  }

  List<Order> get historyDeliveredOrders => _orders
      .where((o) => o.status == OrderStatus.entregada)
      .toList();

  int get activePupusasCount => _pupusas.where((p) => p.isActive).length;

  // --- DASHBOARD AUTOMÁTICO DE PUPUSAS PENDIENTES ---
  // Se calcula en tiempo real a partir de los pedidos en preparación o listos.
  // Al marcar un pedido como 'ENTREGADO', automáticamente desaparece de pendingOrders
  // y se resta del conteo sin intervención de la pupusera.
  Map<String, int> get pendingPupusasCount {
    final Map<String, int> map = {};
    for (var p in _pupusas) {
      if (p.isActive) map[p.name] = 0;
    }
    for (var order in pendingOrders) {
      for (var item in order.items) {
        map[item.pupusaName] = (map[item.pupusaName] ?? 0) + item.quantity;
      }
    }
    return map;
  }

  int get totalPendingPupusasSum {
    return pendingPupusasCount.values.fold(0, (sum, qty) => sum + qty);
  }

  // --- CONSULTA DE HISTORIAL POR FECHA ESPECÍFICA ---
  List<Order> getOrdersByDate(DateTime date) {
    return _orders.where((o) {
      return o.timestamp.year == date.year &&
          o.timestamp.month == date.month &&
          o.timestamp.day == date.day &&
          o.status == OrderStatus.entregada;
    }).toList();
  }

  // --- PERSISTENCIA LOCAL (SharedPreferences) ---
  Future<void> _cargarDeMemoria() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final String? ordersJson = prefs.getString('orders_data');
      if (ordersJson != null) {
        final List<dynamic> decoded = jsonDecode(ordersJson);
        _orders = decoded.map((o) => Order.fromJson(o)).toList();
      }

      final String? pupusasJson = prefs.getString('pupusas_data');
      if (pupusasJson != null) {
        final List<dynamic> decoded = jsonDecode(pupusasJson);
        _pupusas = decoded.map((p) => PupusaItem.fromJson(p)).toList();
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error cargando memoria local: $e');
    }
  }

  Future<void> _guardarEnMemoria() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String ordersEncoded = jsonEncode(_orders.map((o) => o.toJson()).toList());
      await prefs.setString('orders_data', ordersEncoded);

      final String pupusasEncoded = jsonEncode(_pupusas.map((p) => p.toJson()).toList());
      await prefs.setString('pupusas_data', pupusasEncoded);
    } catch (e) {
      debugPrint('Error guardando en memoria local: $e');
    }
  }

  // --- EXPORTACIÓN E IMPORTACIÓN DE RESPALDOS ---
  String exportBackupJson() {
    final Map<String, dynamic> backupMap = {
      'app': 'PupusApp',
      'formatVersion': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'data': {
        'orders': _orders.map((o) => o.toJson()).toList(),
        'pupusas': _pupusas.map((p) => p.toJson()).toList(),
      }
    };
    return const JsonEncoder.withIndent('  ').convert(backupMap);
  }

  BackupValidationResult validateBackupJson(String jsonStr) {
    try {
      if (jsonStr.trim().isEmpty) {
        return BackupValidationResult(isValid: false, errorMessage: 'El texto del respaldo está vacío.');
      }
      final decoded = jsonDecode(jsonStr);
      if (decoded is! Map<String, dynamic>) {
        return BackupValidationResult(isValid: false, errorMessage: 'El formato no es un objeto JSON válido.');
      }

      final String app = decoded['app'] ?? '';
      if (app != 'PupusApp') {
        return BackupValidationResult(isValid: false, errorMessage: 'El archivo no pertenece a PupusApp.');
      }

      final int formatVersion = decoded['formatVersion'] ?? 0;
      if (formatVersion > 1) {
        return BackupValidationResult(isValid: false, errorMessage: 'La versión del formato no es compatible.');
      }

      final data = decoded['data'];
      if (data == null || data is! Map<String, dynamic>) {
        return BackupValidationResult(isValid: false, errorMessage: 'Estructura de datos no encontrada.');
      }

      final ordersRaw = data['orders'];
      final pupusasRaw = data['pupusas'];

      if (ordersRaw == null || ordersRaw is! List) {
        return BackupValidationResult(isValid: false, errorMessage: 'Lista de pedidos inválida.');
      }

      return BackupValidationResult(
        isValid: true,
        formatVersion: formatVersion,
        exportedAt: decoded['exportedAt'] ?? '',
        ordersCount: ordersRaw.length,
        pupusasCount: pupusasRaw is List ? pupusasRaw.length : 0,
        rawData: decoded,
      );
    } catch (e) {
      return BackupValidationResult(isValid: false, errorMessage: 'Error al procesar JSON: ${e.toString()}');
    }
  }

  Future<bool> importBackupData(String jsonStr, {required bool mergeMode}) async {
    final validation = validateBackupJson(jsonStr);
    if (!validation.isValid || validation.rawData == null) {
      return false;
    }

    try {
      final data = validation.rawData!['data'] as Map<String, dynamic>;
      final List ordersList = data['orders'] ?? [];
      final List pupusasList = data['pupusas'] ?? [];

      final importedOrders = ordersList.map((o) => Order.fromJson(o as Map<String, dynamic>)).toList();
      final importedPupusas = pupusasList.map((p) => PupusaItem.fromJson(p as Map<String, dynamic>)).toList();

      if (!mergeMode) {
        _orders = importedOrders;
        if (importedPupusas.isNotEmpty) _pupusas = importedPupusas;
      } else {
        final existingOrderIds = _orders.map((o) => o.id).toSet();
        for (var o in importedOrders) {
          if (!existingOrderIds.contains(o.id)) {
            _orders.add(o);
          }
        }
        _orders.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }

      await _guardarEnMemoria();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error en la importación: $e');
      return false;
    }
  }

  // --- GETTERS PARA ANALÍTICAS ---
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

  double get filteredTotalRevenue =>
      filteredDeliveredOrders.fold(0.0, (sum, o) => sum + o.totalPrice);

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
        map[item.pupusaName] = (map[item.pupusaName] ?? 0.0) + (item.quantity * item.unitPrice);
      }
    }
    return map;
  }

  // --- ACCIONES DE PEDIDOS Y MENÚ ---
  void advanceOrderStatus(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      if (_orders[index].status == OrderStatus.enPreparacion) {
        _orders[index].status = OrderStatus.listaParaEntregar;
      } else if (_orders[index].status == OrderStatus.listaParaEntregar) {
        _orders[index].status = OrderStatus.entregada;
      }
      _guardarEnMemoria();
      notifyListeners();
    }
  }

  void setOrderStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].status = status;
      _guardarEnMemoria();
      notifyListeners();
    }
  }

  void addOrder(String customerName, List<OrderItem> items) {
    final nextNumber = 1001 + _orders.length;
    _orders.insert(
      0,
      Order(
        id: '#$nextNumber',
        customerName: customerName.isEmpty ? 'Cliente #${_orders.length + 1}' : customerName,
        items: items,
        timestamp: DateTime.now(),
        status: OrderStatus.enPreparacion,
      ),
    );
    _guardarEnMemoria();
    notifyListeners();
  }

  void deleteOrder(String id) {
    _orders.removeWhere((o) => o.id == id);
    _guardarEnMemoria();
    notifyListeners();
  }

  void togglePupusaStatus(int index, bool value) {
    _pupusas[index].isActive = value;
    _guardarEnMemoria();
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
    _guardarEnMemoria();
    notifyListeners();
  }

  void updatePupusa(String id, String name, String description, double price) {
    final index = _pupusas.indexWhere((p) => p.id == id);
    if (index != -1) {
      _pupusas[index].name = name;
      _pupusas[index].description = description;
      _pupusas[index].price = price;
      _guardarEnMemoria();
      notifyListeners();
    }
  }

  void deletePupusa(String id) {
    _pupusas.removeWhere((p) => p.id == id);
    _guardarEnMemoria();
    notifyListeners();
  }
}