import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/app_data.dart';
import '../../widgets/kawaii_widgets.dart';
import 'admin_create_product_screen.dart';
import 'admin_customers_screen.dart';
import 'admin_customer_form_screen.dart';
import '../orders_screen.dart';

// ─────────────────────────────────────────────────────────
// admin_dashboard_screen.dart
// Pantalla 9: Panel de administración
// ─────────────────────────────────────────────────────────
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppData.instance,
      builder: (context, _) {
        final productsCount = AppData.instance.products.length;
        final ordersToday = AppData.instance.orders.length;
        final revenue = AppData.instance.orders
            .fold<double>(0, (sum, o) => sum + o.total);

        return Scaffold(
          backgroundColor: const Color(0xFFF5F3FF),
          appBar: AppBar(
            backgroundColor: AppColors.dark,
            title: const Text('Admin Panel 🔑',
                style: TextStyle(color: AppColors.pinkMid)),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.4,
                children: [
                  _StatCard(
                      label: 'Clientes',
                      value: '${AppData.instance.customers.length}',
                      color: AppColors.pink,
                      bg: AppColors.pinkLight,
                      icon: '👥'),
                  _StatCard(
                      label: 'Productos',
                      value: '$productsCount',
                      color: AppColors.purple,
                      bg: AppColors.purpleLight,
                      icon: '📦'),
                  _StatCard(
                      label: 'Pedidos',
                      value: '$ordersToday',
                      color: AppColors.teal,
                      bg: AppColors.tealLight,
                      icon: '🛒'),
                  _StatCard(
                      label: 'Ingresos',
                      value: '\$${revenue.toStringAsFixed(0)}',
                      color: AppColors.amber,
                      bg: AppColors.amberLight,
                      icon: '💰'),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Acciones rápidas',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
              const SizedBox(height: 10),
              KawaiiButton(
                label: '➕ Crear producto/servicio',
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AdminCreateProductScreen())),
              ),
              const SizedBox(height: 8),
              KawaiiButton(
                label: '👥 Ver clientes registrados',
                style: KawaiiButtonStyle.outline,
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AdminCustomersScreen())),
              ),
              const SizedBox(height: 8),
              KawaiiButton(
                label: '🧑\u200d💼 Nuevo cliente',
                style: KawaiiButtonStyle.outline,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AdminCustomerFormScreen())),
              ),
              const SizedBox(height: 8),
              KawaiiButton(
                label: '📦 Gestionar pedidos',
                style: KawaiiButtonStyle.dark,
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const OrdersScreen())),
              ),
              const SizedBox(height: 18),
              const Text('Pedidos recientes',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
              const SizedBox(height: 10),
              if (AppData.instance.orders.isEmpty)
                const Text('Sin pedidos todavía',
                    style: TextStyle(fontSize: 12, color: AppColors.gray))
              else
                ...AppData.instance.orders.take(3).map((o) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          ProductThumb(
                              product: o.product,
                              size: 32,
                              borderRadius: 8,
                              emojiFontSize: 16),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                                '${AppData.instance.currentUserName} — ${o.product.name}',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w700)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.tealLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('Nuevo',
                                style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.teal)),
                          ),
                        ],
                      ),
                    )),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value, icon;
  final Color color, bg;
  const _StatCard(
      {required this.label,
      required this.value,
      required this.color,
      required this.bg,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700, color: color)),
              Text(value,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w900, color: color)),
            ],
          ),
          Text(icon, style: const TextStyle(fontSize: 22)),
        ],
      ),
    );
  }
}
