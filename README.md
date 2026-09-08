# 🫓 PupusApp — Offline-First Mobile POS & Business Intelligence

[![Flutter Version](https://img.shields.io/badge/Flutter-3.47%2B-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart Version](https://img.shields.io/badge/Dart-3.0%2B-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Linux-green?style=for-the-badge&logo=android&logoColor=white)](https://flutter.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Provider%20%2B%20Clean%20State-orange?style=for-the-badge)](https://pub.dev/packages/provider)
[![Persistence](https://img.shields.io/badge/Persistence-Local%20JSON%20Engine-purple?style=for-the-badge)](https://pub.dev/packages/shared_preferences)

> **PupusApp** es un sistema de punto de venta (POS) móvil de alto rendimiento y arquitectura *offline-first*, diseñado específicamente para optimizar el flujo operativo de comandas, el control de inventario/menú y la toma de decisiones mediante analíticas en tiempo real para microempresas gastronómicas.

---

## 📌 El Problema vs. La Solución

### 📉 El Problema
Los comercios gastronómicos de alta demanda (como pupuserías y restaurantes locales) operan bajo entornos ruidosos, acelerados y frecuentemente con conectividad a Internet inestable. Los sistemas POS tradicionales basados en la nube sufren de latencia, mensualidades costosas y fallos críticos cuando se cae la red local.

### 💡 La Solución Engine
PupusApp resuelve la brecha operativa ofreciendo una **plataforma completamente autónoma, reactiva y de cero latencia**:
* **Garantía 100% Offline-First:** Opera de manera ininterrumpida sin depender de servidores remotos o conexión a red.
* **Flujo Operativo Táctil:** Minimiza los toques en pantalla para reducir el tiempo medio de atención por pedido.
* **Métricas Locales Inmediatas:** Calcula ingresos, ticket promedio y volumen de productos vendidos al instante mediante consultas agregadas sobre la memoria persistente.

---

## 🚀 Características Clave

* 📦 **Gestión del Ciclo de Vida de Comandas:** Rastreo reactivo del estado de los pedidos (`En Preparación` $\rightarrow$ `Lista para Entregar` $\rightarrow$ `Entregada`).
* 📊 **Panel de Business Intelligence (BI):** Filtrado dinámico de ventas (Diario, Semanal, Mensual) con cálculo automático de ingresos totales y desglose por producto.
* 🛠️ **Administración Dinámica del Menú:** ABM (Alta, Baja, Modificación) de productos con control de precios, descripciones y switches de disponibilidad en tiempo real.
* 💾 **Persistencia Automática de Datos:** Motor de almacenamiento local que serializa el estado completo de la app (`Orders` y `Menu`) tras cada mutación de datos.
* 🎨 **UI/UX Táctil y Accesible:** Interfaz basada en Material Design 3 optimizada para pantallas móviles con alta respuesta háptica visual.

---

## 🏗️ Arquitectura de Software & Patrones de Diseño

El proyecto implementa una arquitectura reactiva basada en el patrón **Provider (State Management)** con separación estricta de responsabilidades en tres capas principales:

```text
┌────────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                   │
│      (UI Widgets, Modals, Screens, Material Theme)     │
└───────────────────────────▲────────────────────────────┘
                            │ (Listens & Triggers Actions)
┌───────────────────────────┴────────────────────────────┐
│                    APPLICATION STATE                   │
│        (AppState Provider / Business Logic & BI)       │
└───────────────────────────▲────────────────────────────┘
                            │ (JSON Serialization Engine)
┌───────────────────────────┴────────────────────────────┐
│                   PERSISTENCE LAYER                    │
│      (SharedPreferences / Local Disk Storage / I/O)    │
└────────────────────────────────────────────────────────┘
