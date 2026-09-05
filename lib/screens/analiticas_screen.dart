import 'package:flutter/material.dart';

class AnaliticasScreen extends StatelessWidget {
  const AnaliticasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rendimiento y Ventas', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
            // Grid de Métricas
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: const [
                _MetricCard(title: 'Pupusas hoy', value: '147', icon: Icons.local_fire_department, iconColor: Colors.deepOrange),
                _MetricCard(title: 'Ingresos', value: '\$183.75', icon: Icons.attach_money, iconColor: Colors.deepOrange),
                _MetricCard(title: 'Completados', value: '23', icon: Icons.check_circle_outline, iconColor: Colors.orange),
                _MetricCard(title: 'Promedio / Pedido', value: '\$7.98', icon: Icons.trending_up, iconColor: Colors.deepOrange),
              ],
            ),
            const SizedBox(height: 24),
            // Sección Ventas por Especialidad
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Ventas por Especialidad', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 16),
                  _BarItem(label: 'Queso', count: 52, maxCount: 60, color: Color(0xFFD85A32)),
                  _BarItem(label: 'Revueltas', count: 45, maxCount: 60, color: Color(0xFFE67E22)),
                  _BarItem(label: 'Frijol', count: 30, maxCount: 60, color: Color(0xFFF1C40F)),
                  _BarItem(label: 'Loroco', count: 25, maxCount: 60, color: Color(0xFFD5DBDB)),
                  _BarItem(label: 'Chicharrón', count: 18, maxCount: 60, color: Color(0xFF5D4037)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Tendencia Semanal
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Tendencia Semanal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        SizedBox(height: 4),
                        Text('Incremento del +12% vs la semana pasada', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFEAF5EE), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.north_east, color: Color(0xFF27AE60)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _MetricCard({required this.title, required this.value, required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
              Icon(icon, size: 18, color: iconColor),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  final String label;
  final int count;
  final int maxCount;
  final Color color;

  const _BarItem({required this.label, required this.count, required this.maxCount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
          Expanded(
            child: Stack(
              children: [
                Container(height: 12, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(6))),
                FractionallySizedBox(
                  widthFactor: count / maxCount,
                  child: Container(height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6))),
                ),
              ],
            ),
          ),
          SizedBox(width: 30, child: Text('$count', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}