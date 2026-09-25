import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/app_data.dart';
import '../../models/product.dart';
import '../../widgets/kawaii_widgets.dart';

// ─────────────────────────────────────────────────────────
// admin_create_product_screen.dart
// Pantalla 10: Admin: crear producto
// ─────────────────────────────────────────────────────────
class AdminCreateProductScreen extends StatefulWidget {
  const AdminCreateProductScreen({super.key});

  @override
  State<AdminCreateProductScreen> createState() =>
      _AdminCreateProductScreenState();
}

class _AdminCreateProductScreenState extends State<AdminCreateProductScreen> {
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _category = 'Gadgets';

  static const _categories = ['Gadgets', 'Papelería', 'Periféricos', 'Accesorios'];
  static const _categoryIcons = {
    'Gadgets': '🎧',
    'Papelería': '📓',
    'Periféricos': '🖱️',
    'Accesorios': '🎒',
  };

  void _save() {
    final name = _nameCtrl.text.trim();
    final price = double.tryParse(_priceCtrl.text.trim());
    final stock = int.tryParse(_stockCtrl.text.trim()) ?? 0;

    if (name.isEmpty || price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa nombre y precio válidos')),
      );
      return;
    }

    AppData.instance.addProduct(Product(
      name: name,
      category: _category,
      icon: _categoryIcons[_category] ?? '📦',
      price: price,
      stockLabel: stock > 0 ? 'En stock ✅' : 'Agotado',
      stock: stock,
      description: _descCtrl.text.trim(),
    ));

    showKawaiiSuccessDialog(
      context,
      emoji: '📦',
      title: '¡Producto guardado!',
      message: '$name ya está disponible en el catálogo.',
    ).then((_) {
      if (Navigator.canPop(context)) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        backgroundColor: AppColors.dark,
        title: const Text('Crear producto',
            style: TextStyle(color: AppColors.pinkMid)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KawaiiTextField(
                label: 'Nombre del producto', controller: _nameCtrl),
            const SizedBox(height: 12),
            const Text('Categoría',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _categories.map((c) {
                return KawaiiPill(
                  label: c,
                  selected: _category == c,
                  color: AppColors.purple,
                  onTap: () => setState(() => _category = c),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: KawaiiTextField(
                    label: 'Precio (\$)',
                    controller: _priceCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: KawaiiTextField(
                    label: 'Stock',
                    controller: _stockCtrl,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            KawaiiTextField(
                label: 'Descripción', controller: _descCtrl, maxLines: 3),
            const SizedBox(height: 12),
            const Text('Imagen del producto',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Selector de imágenes no incluido en este prototipo')),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color(0xFFCCCCCC),
                      width: 2,
                      style: BorderStyle.solid),
                ),
                child: const Column(
                  children: [
                    Text('📷', style: TextStyle(fontSize: 24)),
                    SizedBox(height: 4),
                    Text('Toca para subir imagen',
                        style: TextStyle(fontSize: 11, color: AppColors.gray)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            KawaiiButton(label: 'Guardar producto', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
