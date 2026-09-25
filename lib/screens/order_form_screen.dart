import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/app_data.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../widgets/kawaii_widgets.dart';

// ─────────────────────────────────────────────────────────
// order_form_screen.dart
// Pantalla 5: Formulario de pedido
// ─────────────────────────────────────────────────────────
class OrderFormScreen extends StatefulWidget {
  final Product product;
  const OrderFormScreen({super.key, required this.product});

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  int _quantity = 1;
  final _addressCtrl = TextEditingController(text: 'Av. 9 de Octubre, Guayaquil');
  final _notesCtrl = TextEditingController(text: 'Empaque kawaii por favor ✨');
  DateTime _date = DateTime.now().add(const Duration(days: 5));
  String _payment = 'Tarjeta';

  double get _total => widget.product.price * _quantity;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _confirm() {
    final order = OrderItem(
      product: widget.product,
      quantity: _quantity,
      address: _addressCtrl.text.trim(),
      date: _formattedDate(_date),
      paymentMethod: _payment,
      notes: _notesCtrl.text.trim(),
    );
    AppData.instance.addOrder(order);

    showKawaiiSuccessDialog(
      context,
      emoji: '🛍️',
      title: '¡Pedido confirmado!',
      message: 'Tu pedido de ${widget.product.name} por \$${_total.toStringAsFixed(2)} fue registrado.',
    ).then((_) {
      if (Navigator.canPop(context)) Navigator.pop(context);
    });
  }

  String _formattedDate(DateTime d) {
    const months = [
      'enero','febrero','marzo','abril','mayo','junio',
      'julio','agosto','septiembre','octubre','noviembre','diciembre'
    ];
    return '${d.day} de ${months[d.month - 1]}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      appBar: AppBar(title: const Text('Hacer pedido')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.pinkLight,
                borderRadius: BorderRadius.circular(12),
                border: const Border(
                    left: BorderSide(color: AppColors.pink, width: 3)),
              ),
              child: Row(
                children: [
                  ProductThumb(product: p, size: 52, borderRadius: 12),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Producto seleccionado',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: AppColors.pink)),
                        const SizedBox(height: 4),
                        Text('${p.name} · ${p.priceLabel}',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.dark)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            const Text('Cantidad',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            const SizedBox(height: 6),
            Row(
              children: [
                _StepperButton(
                  icon: Icons.remove,
                  onTap: () {
                    if (_quantity > 1) setState(() => _quantity--);
                  },
                ),
                Container(
                  width: 50,
                  alignment: Alignment.center,
                  child: Text('$_quantity',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800)),
                ),
                _StepperButton(
                  icon: Icons.add,
                  onTap: () => setState(() => _quantity++),
                ),
              ],
            ),
            const SizedBox(height: 14),

            KawaiiTextField(
                label: 'Dirección de entrega', controller: _addressCtrl),
            const SizedBox(height: 12),

            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: KawaiiTextField(
                  label: 'Fecha de entrega deseada',
                  controller:
                      TextEditingController(text: '📅  ${_formattedDate(_date)}'),
                ),
              ),
            ),
            const SizedBox(height: 12),

            const Text('Método de pago',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              children: ['Tarjeta', 'Efectivo', 'QR'].map((m) {
                final icon = m == 'Tarjeta' ? '💳' : (m == 'Efectivo' ? '💵' : '📱');
                return KawaiiPill(
                  label: '$icon $m',
                  selected: _payment == m,
                  onTap: () => setState(() => _payment = m),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            KawaiiTextField(
                label: 'Notas adicionales', controller: _notesCtrl, maxLines: 2),
            const SizedBox(height: 14),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:',
                    style: TextStyle(fontSize: 13, color: AppColors.gray)),
                Text('\$${_total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.pink)),
              ],
            ),
            const SizedBox(height: 16),
            KawaiiButton(label: 'Confirmar pedido 🛍️', onPressed: _confirm),
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.pinkLight,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          child: Icon(icon, color: AppColors.pink, size: 18),
        ),
      ),
    );
  }
}
