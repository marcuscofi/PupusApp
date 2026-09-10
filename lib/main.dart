import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'providers/app_state.dart';
import 'screens/home_screen.dart';
import 'screens/pedidos_screen.dart';
import 'screens/analiticas_screen.dart';
import 'screens/configuracion_screen.dart';
import 'screens/historial_datos_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const PupusApp(),
    ),
  );
}

class PupusApp extends StatelessWidget {
  const PupusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PupusApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/pedidos': (context) => const PedidosScreen(),
        '/analiticas': (context) => const AnaliticasScreen(),
        '/configuracion': (context) => const ConfiguracionScreen(),
        '/historial_datos': (context) => const HistorialDatosScreen(),
      },
    );
  }
}