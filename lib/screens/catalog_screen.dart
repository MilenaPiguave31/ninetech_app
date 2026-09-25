import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/app_data.dart';
import '../models/product.dart';
import '../widgets/kawaii_widgets.dart';
import 'order_form_screen.dart';

// ─────────────────────────────────────────────────────────
// catalog_screen.dart
// Pantalla 4: Catálogo de productos filtrable por categoría
// ─────────────────────────────────────────────────────────
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  /// Home puede fijar esto antes de cambiar a esta pestaña
  /// para que el catálogo abra ya filtrado por esa categoría.
  static String? pendingCategoryFilter;

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _filter = 'Todos';
  final _searchCtrl = TextEditingController();

  static const _tabs = ['Todos', 'Gadgets', 'Papelería', 'Periféricos', 'Accesorios'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (CatalogScreen.pendingCategoryFilter != null) {
      _filter = CatalogScreen.pendingCategoryFilter!;
      CatalogScreen.pendingCategoryFilter = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppData.instance,
      builder: (context, _) {
        final query = _searchCtrl.text.trim().toLowerCase();
        final items = AppData.instance.products.where((p) {
          final matchesCategory = _filter == 'Todos' || p.category == _filter;
          final matchesQuery =
              query.isEmpty || p.name.toLowerCase().contains(query);
          return matchesCategory && matchesQuery;
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Productos'),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 6)
                    ],
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Buscar productos...',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _tabs.map((t) {
                    return KawaiiPill(
                      label: t,
                      selected: _filter == t,
                      onTap: () => setState(() => _filter = t),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? const Center(
                        child: Text('No hay productos en esta categoría',
                            style: TextStyle(color: AppColors.gray)))
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        itemCount: items.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (ctx, i) {
                          final Product p = items[i];
                          return _ProductTile(
                            product: p,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        OrderFormScreen(product: p)),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  const _ProductTile({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ProductThumb(product: product),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.dark)),
                    Text('${product.category} · ${product.stockLabel}',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.gray)),
                  ],
                ),
              ),
              Text(product.priceLabel,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.pink)),
            ],
          ),
        ),
      ),
    );
  }
}
