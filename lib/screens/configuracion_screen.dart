import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'historial_datos_screen.dart';

class ConfiguracionScreen extends StatelessWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración del Menú', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ESPECIALIDADES EN MENÚ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddPupusaModal(context, appState),
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Agregar', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD85A32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: appState.pupusas.length,
              itemBuilder: (context, index) {
                final pupusa = appState.pupusas[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(
                      pupusa.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        decoration: pupusa.isActive ? null : TextDecoration.lineThrough,
                        color: pupusa.isActive ? Colors.black87 : Colors.grey,
                      ),
                    ),
                    subtitle: Text('${pupusa.description}\n\$${pupusa.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14)),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: pupusa.isActive,
                          activeColor: const Color(0xFFD85A32),
                          onChanged: (val) => appState.togglePupusaStatus(index, val),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (val) {
                            if (val == 'delete') {
                              appState.deletePupusa(pupusa.id);
                            }
                          },
                          itemBuilder: (ctx) => [
                            const PopupMenuItem(value: 'delete', child: Text('Eliminar', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 28),

            const Text('OPCIONES AVANZADAS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            const SizedBox(height: 12),

            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: ListTile(
                leading: const Icon(Icons.folder_zip_rounded, size: 32, color: Color(0xFFD85A32)),
                title: const Text('Archivo e Importación de Historial', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: const Text('Ver archivo, copiar respaldo o cargar datos externos'),
                trailing: const Icon(Icons.chevron_right, size: 28),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistorialDatosScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showAddPupusaModal(BuildContext context, AppState appState) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final priceCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + 16, top: 20, left: 16, right: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Nueva Especialidad', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre de la pupusa', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Descripción / Ingredientes', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: priceCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Precio (\$) ', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  final desc = descCtrl.text.trim();
                  final price = double.tryParse(priceCtrl.text) ?? 0.0;
                  if (name.isNotEmpty && price > 0) {
                    appState.addPupusa(name, desc, price);
                    Navigator.pop(ctx);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD85A32),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Guardar Especialidad', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }
}