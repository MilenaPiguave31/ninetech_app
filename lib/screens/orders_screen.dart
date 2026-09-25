import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/app_data.dart';
import '../models/order.dart';
import '../widgets/kawaii_widgets.dart';

// ─────────────────────────────────────────────────────────
// orders_screen.dart
// Pestaña "Pedidos": historial de pedidos realizados.
// Se llena en vivo con lo que el usuario va confirmando
// desde order_form_screen.dart
// ─────────────────────────────────────────────────────────
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppData.instance,
      builder: (context, _) {
        final orders = AppData.instance.orders;
        return Scaffold(
          appBar: AppBar(title: const Text('Mis pedidos')),
          body: orders.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('📋', style: TextStyle(fontSize: 42)),
                        SizedBox(height: 10),
                        Text('Aún no tienes pedidos',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.dark)),
                        SizedBox(height: 4),
                        Text(
                            'Ve a Productos y elige algo kawaii ✨',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.gray)),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (ctx, i) {
                    final OrderItem o = orders[i];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.05),
                              blurRadius: 6)
                        ],
                      ),
                      child: Row(
                        children: [
                          ProductThumb(product: o.product),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${o.product.name} × ${o.quantity}',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800)),
                                Text('Entrega: ${o.date} · ${o.paymentMethod}',
                                    style: const TextStyle(
                                        fontSize: 11, color: AppColors.gray)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('\$${o.total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.pink)),
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.tealLight,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text('Confirmado',
                                    style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.teal)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
