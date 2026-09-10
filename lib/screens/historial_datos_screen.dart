import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class HistorialDatosScreen extends StatefulWidget {
  const HistorialDatosScreen({super.key});

  @override
  State<HistorialDatosScreen> createState() => _HistorialDatosScreenState();
}

class _HistorialDatosScreenState extends State<HistorialDatosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _importController = TextEditingController();
  BackupValidationResult? _validationResult;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _importController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archivo de Historial', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFD85A32),
          labelColor: const Color(0xFFD85A32),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.file_upload_outlined), text: 'Ver y Copiar Archivo'),
            Tab(icon: Icon(Icons.file_download_outlined), text: 'Cargar / Importar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildExportarTab(appState),
          _buildImportarTab(appState),
        ],
      ),
    );
  }

  Widget _buildExportarTab(AppState appState) {
    final backupJson = appState.exportBackupJson();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Resumen del Archivo Actual', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.receipt_long, color: Color(0xFFD85A32), size: 28),
                    title: const Text('Pedidos registrados', style: TextStyle(fontSize: 16)),
                    trailing: Text('${appState.orders.length}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.restaurant_menu, color: Color(0xFFD85A32), size: 28),
                    title: const Text('Especialidades del menú', style: TextStyle(fontSize: 16)),
                    trailing: Text('${appState.pupusas.length}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: backupJson));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Archivo copiado al portapapeles con éxito!'),
                  backgroundColor: Color(0xFF2E7D32),
                ),
              );
            },
            icon: const Icon(Icons.copy, size: 24),
            label: const Text('COPIAR ARCHIVO DE RESPALDO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD85A32),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Vista previa del contenido:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!),
            ),
            constraints: const BoxConstraints(maxHeight: 220),
            child: SingleChildScrollView(
              child: Text(backupJson, style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportarTab(AppState appState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Pegar archivo de respaldo (JSON) para cargar:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          TextField(
            controller: _importController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Pega aquí el texto del archivo de respaldo...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              final result = appState.validateBackupJson(_importController.text);
              setState(() => _validationResult = result);
            },
            icon: const Icon(Icons.fact_check_outlined),
            label: const Text('Validar Archivo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          if (_validationResult != null) ...[
            if (!_validationResult!.isValid)
              Card(
                color: const Color(0xFFFFEBEE),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _validationResult!.errorMessage ?? 'Error de validación.',
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              Card(
                color: const Color(0xFFE8F5E9),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.check_circle_outline, color: Color(0xFF2E7D32), size: 28),
                          SizedBox(width: 8),
                          Text('Archivo Válido', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32), fontSize: 18)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('• Pedidos a importar: ${_validationResult!.ordersCount}', style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _import(appState, mergeMode: true),
                      child: const Text('Combinar con actual', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _import(appState, mergeMode: false),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700], foregroundColor: Colors.white),
                      child: const Text('Reemplazar todo', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  void _import(AppState appState, {required bool mergeMode}) async {
    final success = await appState.importBackupData(_importController.text, mergeMode: mergeMode);
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Historial cargado con éxito!'), backgroundColor: Color(0xFF2E7D32)),
        );
        setState(() {
          _importController.clear();
          _validationResult = null;
        });
      }
    }
  }
}