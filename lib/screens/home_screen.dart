import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/app_data.dart';
import '../models/product.dart';
import '../widgets/kawaii_widgets.dart';
import 'catalog_screen.dart';
import 'order_form_screen.dart';
import 'main_navigation_screen.dart';

// ─────────────────────────────────────────────────────────
// home_screen.dart
// Pantalla 3: Pantalla principal — Estética Digital Kawaii
// ─────────────────────────────────────────────────────────
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _categories = [
    {
      'icon': '🎧',
      'label': 'Gadgets',
      'sub': 'Audifonos, teclados...',
      'color': AppColors.pinkLight,
      'textColor': AppColors.pink,
    },
    {
      'icon': '📓',
      'label': 'Papelería',
      'sub': 'Agendas, cuadernos...',
      'color': AppColors.purpleLight,
      'textColor': AppColors.purple,
    },
    {
      'icon': '🖱️',
      'label': 'Periféricos',
      'sub': 'Mouse, cables...',
      'color': AppColors.blueLight,
      'textColor': AppColors.blue,
    },
    {
      'icon': '🎒',
      'label': 'Accesorios',
      'sub': 'Mochilas, estuches...',
      'color': AppColors.tealLight,
      'textColor': AppColors.teal,
    },
  ];

  void _openCatalog(BuildContext context, {String? category}) {
    // Cambia a la pestaña "Productos" dentro del bottom nav
    NavTab.go(context, 1);
    if (category != null) {
      CatalogScreen.pendingCategoryFilter = category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppData.instance,
      builder: (context, _) {
        final featured = AppData.instance.products.take(3).toList();
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.dark,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => NavTab.go(context, 3), // atajo a Perfil
            ),
            title: Text(
              'Hola, ${AppData.instance.currentUserName} 👋',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Colors.amber),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Banner oferta del mes ─────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 22, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [AppColors.purple, AppColors.pink],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Column(
                    children: [
                      Text('✨ Oferta del mes',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900)),
                      SizedBox(height: 4),
                      Text('Hasta 50% OFF en gadgets kawaii',
                          style: TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Barra de búsqueda (funcional → abre catálogo) ──
                GestureDetector(
                  onTap: () => _openCatalog(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2)),
                      ],
                    ),
                    child: const Row(children: [
                      Icon(Icons.search, color: AppColors.gray, size: 20),
                      SizedBox(width: 8),
                      Text('Buscar productos...',
                          style:
                              TextStyle(color: AppColors.gray, fontSize: 14)),
                    ]),
                  ),
                ),
                const SizedBox(height: 20),

                const Text('Categorías',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1232))),
                const SizedBox(height: 10),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.55,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (ctx, i) {
                    final cat = _categories[i];
                    return GestureDetector(
                      onTap: () => _openCatalog(context,
                          category: cat['label'] as String),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cat['color'] as Color,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(cat['icon']! as String,
                                style: const TextStyle(fontSize: 28)),
                            const SizedBox(height: 6),
                            Text(cat['label']! as String,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: cat['textColor'] as Color)),
                            const SizedBox(height: 2),
                            Text(cat['sub']! as String,
                                style: const TextStyle(
                                    fontSize: 11, color: AppColors.gray)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                const Text('Destacados',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1232))),
                const SizedBox(height: 10),

                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: featured.length,
                    itemBuilder: (ctx, i) {
                      final Product p = featured[i];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    OrderFormScreen(product: p)),
                          );
                        },
                        child: Container(
                          width: 110,
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.pinkLight,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ProductThumb(
                                  product: p,
                                  size: 60,
                                  borderRadius: 14,
                                  emojiFontSize: 34),
                              const SizedBox(height: 6),
                              Text(p.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1E1232))),
                              const SizedBox(height: 4),
                              Text(p.priceLabel,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.pink)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
