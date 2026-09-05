import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class AnaliticasScreen extends StatelessWidget {
  const AnaliticasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final salesMap = appState.filteredSalesByPupusaType;
    final revenueMap = appState.filteredRevenueByPupusaType;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas y Tendencias', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
            // FILTROS DE TIEMPO (DIARIO, SEMANAL, MENSUAL)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _FilterChipButton(
                  label: 'Diario',
                  isSelected: appState.selectedFilter == TimeFilter.diario,
                  onTap: () => appState.setFilter(TimeFilter.diario),
                ),
                const SizedBox(width: 8),
                _FilterChipButton(
                  label: 'Semanal',
                  isSelected: appState.selectedFilter == TimeFilter.semanal,
                  onTap: () => appState.setFilter(TimeFilter.semanal),
                ),
                const SizedBox(width: 8),
                _FilterChipButton(
                  label: 'Mensual',
                  isSelected: appState.selectedFilter == TimeFilter.mensual,
                  onTap: () => appState.setFilter(TimeFilter.mensual),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Resumen General
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Ingresos',
                    value: '\$${appState.filteredTotalRevenue.toStringAsFixed(2)}',
                    icon: Icons.attach_money,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'Pupusas Vendidas',
                    value: '${appState.filteredTotalPupusasSold}',
                    icon: Icons.local_fire_department,
                    color: const Color(0xFFD85A32),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text('Ventas por Especialidad', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            if (salesMap.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: const Column(
                  children: [
                    Icon(Icons.bar_chart, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'No hay ventas registradas para este periodo.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            else
              ...salesMap.entries.map((entry) {
                final String pupusaName = entry.key;
                final int unitsSold = entry.value;
                final double totalEarned = revenueMap[pupusaName] ?? 0.0;
                final double progress = appState.filteredTotalPupusasSold > 0 ? (unitsSold / appState.filteredTotalPupusasSold) : 0.0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(pupusaName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text('\$${totalEarned.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('$unitsSold unidades vendidas', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[200],
                        color: const Color(0xFFD85A32),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
      selected: isSelected,
      selectedColor: const Color(0xFFD85A32),
      backgroundColor: Colors.white,
      onSelected: (_) => onTap(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}