import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant, color: Theme.of(context).primaryColor, size: 28),
                  const SizedBox(width: 8),
                  const Text(
                    'PupusApp',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Text(
                'Tu negocio de pupusas, organizado',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 24),
              // Contenedor de Imagen Ilustrativa
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF2E6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.flatware, size: 80, color: Color(0xFFD85A32)),
              ),
              const SizedBox(height: 28),
              // Botones de Menú
              _MenuCard(
                title: 'Pedidos',
                subtitle: 'Gestiona comandas y estados de entrega',
                icon: Icons.shopping_bag_outlined,
                isPrimary: true,
                onTap: () => Navigator.pushNamed(context, '/pedidos'),
              ),
              const SizedBox(height: 12),
              _MenuCard(
                title: 'Analíticas',
                subtitle: 'Monitorea ventas y productos populares',
                icon: Icons.bar_chart_rounded,
                onTap: () => Navigator.pushNamed(context, '/analiticas'),
              ),
              const SizedBox(height: 12),
              _MenuCard(
                title: 'Configuración',
                subtitle: 'Ajustes del negocio y preferencias',
                icon: Icons.settings_outlined,
                onTap: () => Navigator.pushNamed(context, '/configuracion'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isPrimary = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFFD85A32) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isPrimary ? Colors.white.withOpacity(0.2) : const Color(0xFFFAF2E6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: isPrimary ? Colors.white : const Color(0xFFD85A32)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isPrimary ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isPrimary ? Colors.white70 : Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isPrimary ? Colors.white : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}