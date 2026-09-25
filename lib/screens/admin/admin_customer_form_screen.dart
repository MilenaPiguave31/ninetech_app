import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/app_data.dart';
import '../../models/customer.dart';
import '../../widgets/kawaii_widgets.dart';

// ─────────────────────────────────────────────────────────
// admin_customer_form_screen.dart
// Admin: crear cliente nuevo o actualizar uno existente.
// Si se recibe [customer], la pantalla entra en modo edición
// (cédula bloqueada, botón "Eliminar cliente" visible).
// ─────────────────────────────────────────────────────────
class AdminCustomerFormScreen extends StatefulWidget {
  final Customer? customer;

  const AdminCustomerFormScreen({super.key, this.customer});

  bool get isEditing => customer != null;

  @override
  State<AdminCustomerFormScreen> createState() =>
      _AdminCustomerFormScreenState();
}

class _AdminCustomerFormScreenState extends State<AdminCustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _cedulaCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _cityCtrl;
  late String _status;

  static const _statuses = ['Nuevo', 'Activo', 'VIP'];

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    _cedulaCtrl = TextEditingController(text: c?.cedula ?? '');
    _nameCtrl = TextEditingController(text: c?.name ?? '');
    _emailCtrl = TextEditingController(text: c?.email ?? '');
    _phoneCtrl = TextEditingController(text: c?.phone ?? '');
    _cityCtrl = TextEditingController(text: c?.city ?? '');
    _status = c?.status ?? 'Nuevo';
  }

  @override
  void dispose() {
    _cedulaCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? v, {String field = 'Este campo'}) {
    if (v == null || v.trim().isEmpty) return '$field es obligatorio';
    return null;
  }

  String? _cedulaValidator(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'La cédula es obligatoria';
    if (value.length != 10 || int.tryParse(value) == null) {
      return 'Ingresa una cédula válida de 10 dígitos';
    }
    // Si estamos creando, o cambiamos la cédula al editar, no debe repetirse.
    final original = widget.customer?.cedula;
    if (value != original && AppData.instance.customerExists(value)) {
      return 'Ya existe un cliente con esta cédula';
    }
    return null;
  }

  String? _emailValidator(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'El correo es obligatorio';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final newCustomer = Customer(
      cedula: _cedulaCtrl.text.trim(),
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      status: _status,
      registeredAt: widget.customer?.registeredAt ?? DateTime.now(),
    );

    if (widget.isEditing) {
      AppData.instance.updateCustomer(widget.customer!.cedula, newCustomer);
      showKawaiiSuccessDialog(
        context,
        emoji: '✏️',
        title: '¡Cliente actualizado!',
        message: 'Los datos de ${newCustomer.name} fueron actualizados.',
      ).then((_) {
        if (Navigator.canPop(context)) Navigator.pop(context);
      });
    } else {
      AppData.instance.addCustomer(newCustomer);
      showKawaiiSuccessDialog(
        context,
        emoji: '🎉',
        title: '¡Cliente creado!',
        message: '${newCustomer.name} ya está registrado.',
      ).then((_) {
        if (Navigator.canPop(context)) Navigator.pop(context);
      });
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('¿Eliminar cliente?',
            style: TextStyle(fontWeight: FontWeight.w900)),
        content: Text(
          '${widget.customer!.name} (cédula ${widget.customer!.cedula}) '
          'se eliminará permanentemente. Esta acción no se puede deshacer.',
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // cierra el diálogo
              AppData.instance.deleteCustomer(widget.customer!.cedula);
              Navigator.pop(context); // vuelve a la lista
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('${widget.customer!.name} fue eliminado')),
              );
            },
            child: const Text('Eliminar',
                style: TextStyle(
                    color: AppColors.pink, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        backgroundColor: AppColors.dark,
        title: Text(
          widget.isEditing ? 'Editar cliente' : 'Crear cliente',
          style: const TextStyle(color: AppColors.pinkMid),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ValidatedField(
                label: 'Cédula',
                controller: _cedulaCtrl,
                keyboardType: TextInputType.number,
                readOnly: widget.isEditing,
                validator: _cedulaValidator,
              ),
              const SizedBox(height: 12),
              _ValidatedField(
                label: 'Nombre completo',
                controller: _nameCtrl,
                validator: (v) => _requiredValidator(v, field: 'El nombre'),
              ),
              const SizedBox(height: 12),
              _ValidatedField(
                label: 'Correo electrónico',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                validator: _emailValidator,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ValidatedField(
                      label: 'Teléfono',
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      validator: (v) =>
                          _requiredValidator(v, field: 'El teléfono'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ValidatedField(
                      label: 'Ciudad',
                      controller: _cityCtrl,
                      validator: (v) =>
                          _requiredValidator(v, field: 'La ciudad'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Estado del cliente',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _statuses.map((s) {
                  return KawaiiPill(
                    label: s,
                    selected: _status == s,
                    color: AppColors.purple,
                    onTap: () => setState(() => _status = s),
                  );
                }).toList(),
              ),
              if (widget.isEditing) ...[
                const SizedBox(height: 12),
                Text(
                  'Registrado el '
                  '${widget.customer!.registeredAt.day.toString().padLeft(2, '0')}/'
                  '${widget.customer!.registeredAt.month.toString().padLeft(2, '0')}/'
                  '${widget.customer!.registeredAt.year}',
                  style: const TextStyle(fontSize: 11, color: AppColors.gray),
                ),
              ],
              const SizedBox(height: 20),
              KawaiiButton(
                label: widget.isEditing
                    ? 'Guardar cambios'
                    : 'Crear cliente',
                onPressed: _save,
              ),
              if (widget.isEditing) ...[
                const SizedBox(height: 10),
                KawaiiButton(
                  label: '🗑️ Eliminar cliente',
                  style: KawaiiButtonStyle.outline,
                  onPressed: _confirmDelete,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Igual que KawaiiTextField pero conectado a un Form/validator.
class _ValidatedField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool readOnly;
  final String? Function(String?)? validator;

  const _ValidatedField({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.dark)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly ? const Color(0xFFEFEFEF) : Colors.white,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
