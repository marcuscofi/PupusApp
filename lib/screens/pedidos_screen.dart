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
        title: const Text('Pedidos Activos', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD85A32),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
        onPressed: () => _showAddOrderDialog(context, appState),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: appState.orders.length,
        itemBuilder: (context, index) {
          final order = appState.orders[index];
          return _OrderCard(order: order);
        },
      ),
    );
  }

  void _showAddOrderDialog(BuildContext context, AppState state) {
    final nameController = TextEditingController();
    final detailsController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Nuevo Pedido', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre del Cliente (Opcional)'),
            ),
            TextField(
              controller: detailsController,
              decoration: const InputDecoration(labelText: 'Detalle (ej. 3 Revueltas, 2 Queso)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD85A32),
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                if (detailsController.text.isNotEmpty) {
                  state.addOrder(nameController.text, detailsController.text);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Registrar Pedido', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;

  const _OrderCard({required this.order});

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
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PEDIDO ${order.id}',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  statusLabel,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusText),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            order.customerName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            order.details,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 12),
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
                onPressed: () {
                  Provider.of<AppState>(context, listen: false).advanceOrderStatus(order.id);
                },
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