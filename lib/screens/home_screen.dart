import 'package:flutter/material.dart';
import 'pedidos_screen.dart';
import 'analiticas_screen.dart';
import 'configuracion_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3ED),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // LOGO Y ENCABEZADO COMPACTO Y BONITO
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF7EFE5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.flatware_rounded,
                        size: 54,
                        color: Color(0xFFD85A32),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'PupusApp',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Tu negocio de pupusas, organizado',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // BOTONES DE NAVEGACIÓN CENTRADOS
                _MenuButton(
                  title: 'Pedidos',
                  subtitle: 'Gestiona comandas y estados de entrega',
                  icon: Icons.shopping_bag_outlined,
                  color: const Color(0xFFD85A32),
                  textColor: Colors.white,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PedidosScreen()),
                  ),
                ),
                const SizedBox(height: 14),

                _MenuButton(
                  title: 'Analíticas',
                  subtitle: 'Monitorea ventas y productos populares',
                  icon: Icons.bar_chart_rounded,
                  color: Colors.white,
                  textColor: Colors.black87,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AnaliticasScreen()),
                  ),
                ),
                const SizedBox(height: 14),

                _MenuButton(
                  title: 'Configuración',
                  subtitle: 'Ajustes del negocio y preferencias',
                  icon: Icons.settings_outlined,
                  color: Colors.white,
                  textColor: Colors.black87,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ConfiguracionScreen()),
                  ),
                ),

                const SizedBox(height: 36),

                // FIRMA / CRÉDITOS DEL DESARROLLADOR
                Column(
                  children: const [
                    Text(
                      'Desarrollado por Marcus Melendez',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'LinkedIn: marcusmelendezzz',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _MenuButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (color == Colors.white)
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: textColor == Colors.white
                    ? Colors.white.withOpacity(0.2)
                    : const Color(0xFFFDF0ED),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: textColor == Colors.white
                    ? Colors.white
                    : const Color(0xFFD85A32),
              ),
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
                      color: textColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor == Colors.white
                          ? Colors.white70
                          : Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: textColor == Colors.white ? Colors.white70 : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}