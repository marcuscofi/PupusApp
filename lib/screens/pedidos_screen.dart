import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/order.dart';

class PedidosScreen extends StatelessWidget {
  const PedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Pedidos', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Color(0xFFD85A32)),
            tooltip: 'Historial por Calendario',
            onPressed: () => _showHistoryModal(context, appState),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFD85A32),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Nuevo Pedido', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => _showInteractiveOrderDialog(context, appState),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: Color(0xFFD85A32)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _showHistoryModal(context, appState),
                icon: const Icon(Icons.calendar_today, color: Color(0xFFD85A32), size: 18),
                label: const Text('Ver Historial y Calendario de Ventas', style: TextStyle(color: Color(0xFFD85A32), fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Pendientes / En Cocina', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFD85A32), borderRadius: BorderRadius.circular(10)),
                  child: Text('${appState.pendingOrders.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                )
              ],
            ),
            const SizedBox(height: 12),
            if (appState.pendingOrders.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text('No hay pedidos pendientes.', style: TextStyle(color: Colors.grey))),
              )
            else
              ...appState.pendingOrders.map((order) => _OrderCard(order: order)),

            const SizedBox(height: 24),
            const Text('Recientes (Máx 3 entregadas)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 12),
            if (appState.recentDeliveredOrders.isEmpty)
              const Text('Aún no hay entregas registradas.', style: TextStyle(color: Colors.grey, fontSize: 13))
            else
              ...appState.recentDeliveredOrders.map((order) => _OrderCard(order: order)),
          ],
        ),
      ),
    );
  }

  void _showHistoryModal(BuildContext context, AppState state) {
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final ordersForDate = state.getDeliveredOrdersForDate(selectedDate);
          final totalSales = ordersForDate.fold(0.0, (sum, o) => sum + o.totalPrice);

          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Historial de Ventas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('Fecha: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD85A32)),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2025),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setModalState(() => selectedDate = picked);
                        }
                      },
                      icon: const Icon(Icons.date_range, color: Colors.white, size: 16),
                      label: const Text('Cambiar día', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFFDF0ED), borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pedidos: ${ordersForDate.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Total: \$${totalSales.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD85A32))),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ordersForDate.isEmpty
                      ? const Center(child: Text('No hay ventas registradas en esta fecha.', style: TextStyle(color: Colors.grey)))
                      : ListView.builder(
                          itemCount: ordersForDate.length,
                          itemBuilder: (c, i) => _OrderCard(order: ordersForDate[i]),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showInteractiveOrderDialog(BuildContext context, AppState state) {
    final nameController = TextEditingController();
    final Map<String, TextEditingController> quantityControllers = {};

    for (var pupusa in state.pupusas.where((p) => p.isActive)) {
      quantityControllers[pupusa.name] = TextEditingController(text: '0');
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF6F3ED),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setStateModal) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              top: 24, left: 20, right: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nuevo Pedido Táctil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre del Cliente',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Toca los botones para agregar:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: state.pupusas.where((p) => p.isActive).map((pupusa) {
                      final ctrl = quantityControllers[pupusa.name]!;
                      int currentQty = int.tryParse(ctrl.text) ?? 0;
                      return InkWell(
                        onTap: () {
                          setStateModal(() => ctrl.text = (currentQty + 1).toString());
                        },
                        child: Container(
                          width: 105,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: currentQty > 0 ? const Color(0xFFD85A32) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFD85A32).withOpacity(0.5)),
                          ),
                          child: Column(
                            children: [
                              Text(pupusa.name, style: TextStyle(fontWeight: FontWeight.bold, color: currentQty > 0 ? Colors.white : Colors.black87), textAlign: TextAlign.center),
                              const SizedBox(height: 4),
                              Text('$currentQty', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: currentQty > 0 ? Colors.white : const Color(0xFFD85A32))),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD85A32),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      List<OrderItem> orderItems = [];
                      quantityControllers.forEach((name, ctrl) {
                        int qty = int.tryParse(ctrl.text) ?? 0;
                        if (qty > 0) {
                          final pupusaObj = state.pupusas.firstWhere((p) => p.name == name);
                          orderItems.add(OrderItem(pupusaName: name, quantity: qty, unitPrice: pupusaObj.price));
                        }
                      });

                      if (orderItems.isNotEmpty) {
                        state.addOrder(nameController.text, orderItems);
                        Navigator.pop(ctx);
                      }
                    },
                    child: const Text('Registrar Pedido', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  const _OrderCard({required this.order});

  void _confirmDeleteOrder(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar y Eliminar Pedido'),
        content: Text('¿Deseas eliminar el pedido ${order.id} de "${order.customerName}"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Provider.of<AppState>(context, listen: false).deleteOrder(order.id);
              Navigator.pop(ctx);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color statusBg;
    Color statusText;
    String statusLabel;

    switch (order.status) {
      case OrderStatus.enPreparacion:
        statusBg = const Color(0xFFFDF0ED);
        statusText = const Color(0xFFD85A32);
        statusLabel = 'En preparación';
        break;
      case OrderStatus.listaParaEntregar:
        statusBg = const Color(0xFFE8F4F8);
        statusText = const Color(0xFF2980B9);
        statusLabel = 'Lista para entregar';
        break;
      case OrderStatus.entregada:
        statusBg = const Color(0xFFEAF5EE);
        statusText = const Color(0xFF27AE60);
        statusLabel = 'Entregada';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PEDIDO ${order.id}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
                    child: Text(statusLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusText)),
                  ),
                  const SizedBox(width: 4),
                  // BOTÓN DE ELIMINAR PEDIDO
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                    onPressed: () => _confirmDeleteOrder(context),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order.customerName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('\$${order.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFD85A32))),
            ],
          ),
          const SizedBox(height: 8),
          Text(order.details, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(order.timeAgo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          if (order.status != OrderStatus.entregada) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD85A32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => Provider.of<AppState>(context, listen: false).advanceOrderStatus(order.id),
                icon: const Icon(Icons.check, size: 18, color: Colors.white),
                label: Text(
                  order.status == OrderStatus.enPreparacion ? 'Marcar Listo' : 'Completar y Entregar',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}