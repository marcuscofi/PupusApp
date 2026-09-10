import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/order.dart';
import 'historial_ventas_screen.dart';

class PedidosScreen extends StatelessWidget {
  const PedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final pendingMap = appState.pendingPupusasCount;
    final totalPending = appState.totalPendingPupusasSum;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Pedidos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // BOTONERA PRINCIPAL
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddOrderModal(context, appState),
                    icon: const Icon(Icons.add_circle, size: 28),
                    label: const Text('NUEVO PEDIDO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD85A32),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 3,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HistorialVentasScreen()),
                    );
                  },
                  icon: const Icon(Icons.calendar_month_rounded, size: 26, color: Color(0xFFD85A32)),
                  label: const Text('Historial\npor Fecha', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFD85A32))),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    side: const BorderSide(color: Color(0xFFD85A32), width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // DASHBOARD PENDIENTES
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              color: totalPending == 0 ? const Color(0xFFE8F5E9) : const Color(0xFFFFF8F6),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.soup_kitchen_rounded, color: Color(0xFFD85A32), size: 28),
                            SizedBox(width: 10),
                            Text('PUPUSAS PENDIENTES', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: totalPending == 0 ? const Color(0xFF2E7D32) : const Color(0xFFD85A32),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$totalPending Total',
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Se restan automáticamente al entregar el pedido:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    const Divider(height: 20),
                    if (totalPending == 0)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Center(
                          child: Text('¡Sin pupusas pendientes en la plancha! 🎉', style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      )
                    else
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: pendingMap.entries.where((e) => e.value > 0).map((entry) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFD85A32), width: 1.5),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: const Color(0xFFD85A32), borderRadius: BorderRadius.circular(8)),
                                  child: Text('${entry.value}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text('PEDIDOS EN CURSO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            const SizedBox(height: 10),

            if (appState.pendingOrders.isEmpty)
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: const Padding(
                  padding: EdgeInsets.all(28.0),
                  child: Center(child: Text('No hay pedidos pendientes.', style: TextStyle(color: Colors.grey, fontSize: 16))),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: appState.pendingOrders.length,
                itemBuilder: (context, index) {
                  final order = appState.pendingOrders[index];
                  return _OrderCard(order: order, appState: appState);
                },
              ),

            const SizedBox(height: 28),
            const Text('ÚLTIMAS 3 VENTAS ENTREGADAS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            const SizedBox(height: 10),

            if (appState.recentDeliveredOrders.isEmpty)
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(child: Text('Aún no hay ventas entregadas hoy.', style: TextStyle(color: Colors.grey, fontSize: 15))),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: appState.recentDeliveredOrders.length,
                itemBuilder: (context, index) {
                  final order = appState.recentDeliveredOrders[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Colors.grey[100],
                    child: ListTile(
                      title: Text('${order.id} - ${order.customerName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      subtitle: Text('${order.details}\nEntregado a las ${order.formattedTime}', style: const TextStyle(fontSize: 14)),
                      trailing: Text('\$${order.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF2E7D32))),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  // MODAL TOUCH-FRIENDLY MEJORADO
  static void _showAddOrderModal(BuildContext context, AppState appState) {
    final nameController = TextEditingController();
    final Map<String, int> selectedQuantities = {};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            double calculateTotal() {
              double total = 0.0;
              selectedQuantities.forEach((name, qty) {
                final p = appState.pupusas.firstWhere((e) => e.name == name, orElse: () => appState.pupusas.first);
                total += qty * p.price;
              });
              return total;
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 20,
                left: 16,
                right: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Nuevo Pedido', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameController,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        labelText: 'Nombre del Cliente (Opcional)',
                        labelStyle: const TextStyle(fontSize: 16),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        prefixIcon: const Icon(Icons.person_outline, size: 28),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      '👇 Toca para sumar (+1):',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFFD85A32)),
                    ),
                    const SizedBox(height: 12),

                    // BOTONES TOUCH JUGOSOS CON ANIMACIÓN DE REBOTE
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: appState.pupusas.where((p) => p.isActive).map((pupusa) {
                        final currentQty = selectedQuantities[pupusa.name] ?? 0;
                        return _JuicyButton(
                          label: pupusa.name,
                          quantity: currentQty,
                          onTap: () {
                            setModalState(() {
                              selectedQuantities[pupusa.name] = currentQty + 1;
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),
                    const Divider(),
                    const Text('Ajuste de cantidades:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),

                    // LISTA MANUAL
                    ...appState.pupusas.where((p) => p.isActive).map((pupusa) {
                      final qty = selectedQuantities[pupusa.name] ?? 0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${pupusa.name}\n\$${pupusa.price.toStringAsFixed(2)} c/u',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            InkWell(
                              onTap: qty > 0
                                  ? () {
                                      setModalState(() {
                                        selectedQuantities[pupusa.name] = qty - 1;
                                      });
                                    }
                                  : null,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: qty > 0 ? Colors.grey[300] : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.remove, size: 26),
                              ),
                            ),
                            Container(
                              width: 50,
                              alignment: Alignment.center,
                              child: Text('$qty', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                            ),
                            InkWell(
                              onTap: () {
                                setModalState(() {
                                  selectedQuantities[pupusa.name] = qty + 1;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD85A32),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.add, color: Colors.white, size: 26),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 20),

                    // TOTAL Y GUARDAR
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xFFFDF0ED), borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('TOTAL PEDIDO:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('\$${calculateTotal().toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Color(0xFFD85A32))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final items = <OrderItem>[];
                        selectedQuantities.forEach((name, qty) {
                          if (qty > 0) {
                            final p = appState.pupusas.firstWhere((element) => element.name == name);
                            items.add(OrderItem(pupusaName: name, quantity: qty, unitPrice: p.price));
                          }
                        });

                        if (items.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona al menos una pupusa.')));
                          return;
                        }

                        appState.addOrder(nameController.text.trim(), items);
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD85A32),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('GUARDAR PEDIDO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// COMPONENTE NATIVO: BOTÓN TOUCH JUGOSO CON EFECTO DE REBOTE
class _JuicyButton extends StatefulWidget {
  final String label;
  final int quantity;
  final VoidCallback onTap;

  const _JuicyButton({
    required this.label,
    required this.quantity,
    required this.onTap,
  });

  @override
  State<_JuicyButton> createState() => _JuicyButtonState();
}

class _JuicyButtonState extends State<_JuicyButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.88 : 1.0, // <-- Efecto táctil al presionar
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: widget.quantity > 0 ? const Color(0xFFD85A32) : const Color(0xFFFDF0ED),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFD85A32), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD85A32).withOpacity(_isPressed ? 0.1 : 0.25),
                blurRadius: _isPressed ? 2 : 8,
                offset: Offset(0, _isPressed ? 2 : 5),
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '+1 ${widget.label}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.quantity > 0 ? Colors.white : const Color(0xFFD85A32),
                ),
              ),
              if (widget.quantity > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${widget.quantity}',
                    style: const TextStyle(
                      color: Color(0xFFD85A32),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final AppState appState;

  const _OrderCard({required this.order, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${order.id} - ${order.customerName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: order.status.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(order.status.label, style: TextStyle(color: order.status.color, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(order.details, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: \$${order.totalPrice.toStringAsFixed(2)} • ${order.formattedTime}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
                Row(
                  children: [
                    if (order.status == OrderStatus.enPreparacion)
                      ElevatedButton.icon(
                        onPressed: () => appState.advanceOrderStatus(order.id),
                        icon: const Icon(Icons.check, size: 20),
                        label: const Text('Marcar Listo', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white),
                      ),
                    if (order.status == OrderStatus.listaParaEntregar)
                      ElevatedButton.icon(
                        onPressed: () => appState.advanceOrderStatus(order.id),
                        icon: const Icon(Icons.done_all, size: 20),
                        label: const Text('Entregar', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700], foregroundColor: Colors.white),
                      ),
                    PopupMenuButton<String>(
                      onSelected: (val) {
                        if (val == 'cancel') {
                          appState.setOrderStatus(order.id, OrderStatus.cancelada);
                        } else if (val == 'delete') {
                          appState.deleteOrder(order.id);
                        }
                      },
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(value: 'cancel', child: Text('Cancelar pedido')),
                        const PopupMenuItem(value: 'delete', child: Text('Eliminar pedido', style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}