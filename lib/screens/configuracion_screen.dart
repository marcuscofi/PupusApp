import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class ConfiguracionScreen extends StatelessWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner de Información
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF0ED),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: const [
                  Icon(Icons.settings, color: Color(0xFFD85A32)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Configura tu Menú', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD85A32))),
                        Text('Define los precios y disponibilidad de las pupusas que vendes hoy.', style: TextStyle(fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Título de Sección
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Mis Pupusas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${appState.activePupusasCount} activas', style: const TextStyle(fontSize: 12, color: Color(0xFFD85A32), fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            // Lista de pupusas
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: appState.pupusas.length,
              itemBuilder: (context, index) {
                final item = appState.pupusas[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text(item.description, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Text('\$ ${item.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Switch(
                        value: item.isActive,
                        activeColor: const Color(0xFFD85A32),
                        onChanged: (val) => appState.togglePupusaStatus(index, val),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            // Botón bordes punteados
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: const BorderSide(color: Color(0xFFD85A32), style: BorderStyle.solid),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _showAddPupusaDialog(context, appState),
              child: const Text('+ Agregar tipo de pupusa', style: TextStyle(color: Color(0xFFD85A32))),
            ),
            const SizedBox(height: 20),
            // Botón Guardar Cambios
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD85A32),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cambios guardados con éxito')),
                );
              },
              child: const Text('Guardar Cambios', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPupusaDialog(BuildContext context, AppState state) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final priceCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nuevo Sabor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Ingredientes')),
            TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Precio (\$)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final price = double.tryParse(priceCtrl.text) ?? 1.00;
              if (nameCtrl.text.isNotEmpty) {
                state.addPupusa(nameCtrl.text, descCtrl.text, price);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}