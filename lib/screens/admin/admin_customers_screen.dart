import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/app_data.dart';
import '../../models/customer.dart';
import '../../widgets/kawaii_widgets.dart';
import 'admin_customer_form_screen.dart';

// ─────────────────────────────────────────────────────────
// admin_customers_screen.dart
// Pantalla 11: Admin — CRUD de clientes
//  · Consulta masiva (con filtro por fecha de registro)
//  · Consulta específica por cédula
//  · Crear / Actualizar / Eliminar
// ─────────────────────────────────────────────────────────
class AdminCustomersScreen extends StatefulWidget {
  const AdminCustomersScreen({super.key});

  @override
  State<AdminCustomersScreen> createState() => _AdminCustomersScreenState();
}

class _AdminCustomersScreenState extends State<AdminCustomersScreen> {
  final _searchCtrl = TextEditingController();
  DateTimeRange? _dateFilter;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'VIP':
        return AppColors.pink;
      case 'Activo':
        return AppColors.teal;
      default:
        return const Color(0xFF888888);
    }
  }

  Color _statusBg(String status) {
    switch (status) {
      case 'VIP':
        return AppColors.pinkLight;
      case 'Activo':
        return AppColors.tealLight;
      default:
        return const Color(0xFFEEEEEE);
    }
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 3),
      lastDate: DateTime(now.year + 1),
      initialDateRange: _dateFilter,
    );
    if (picked != null) {
      setState(() => _dateFilter = picked);
    }
  }

  // Consulta específica de cliente por cédula.
  Future<void> _searchByCedula() async {
    final ctrl = TextEditingController();
    final cedula = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Buscar cliente por cédula',
            style: TextStyle(fontWeight: FontWeight.w900)),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Ej. 0912345678'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Buscar',
                style: TextStyle(
                    color: AppColors.pink, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );

    if (cedula == null || cedula.isEmpty || !mounted) return;

    final customer = AppData.instance.findCustomerByCedula(cedula);
    if (!mounted) return;

    if (customer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No existe un cliente con cédula $cedula')),
      );
      return;
    }
    _showCustomerDetail(customer);
  }

  void _showCustomerDetail(Customer c) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.purple,
                  child: Text(c.initial,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w800)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 15)),
                      Text('Cédula: ${c.cedula}',
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.gray)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusBg(c.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(c.status,
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: _statusColor(c.status))),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _DetailRow(icon: '📧', label: c.email),
            _DetailRow(icon: '📱', label: c.phone.isEmpty ? '—' : c.phone),
            _DetailRow(icon: '📍', label: c.city),
            _DetailRow(icon: '🗓️', label: 'Registrado el ${_fmt(c.registeredAt)}'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: KawaiiButton(
                    label: '✏️ Editar',
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminCustomerFormScreen(customer: c),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: KawaiiButton(
                    label: '🗑️ Eliminar',
                    style: KawaiiButtonStyle.outline,
                    onPressed: () {
                      Navigator.pop(ctx);
                      _confirmDelete(c);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(Customer c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('¿Eliminar cliente?',
            style: TextStyle(fontWeight: FontWeight.w900)),
        content: Text(
          '${c.name} (cédula ${c.cedula}) se eliminará permanentemente.',
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              AppData.instance.deleteCustomer(c.cedula);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${c.name} fue eliminado')),
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
    return AnimatedBuilder(
      animation: AppData.instance,
      builder: (context, _) {
        final query = _searchCtrl.text.trim().toLowerCase();

        final customers = AppData.instance
            .queryCustomers(from: _dateFilter?.start, to: _dateFilter?.end)
            .where((c) =>
                query.isEmpty ||
                c.name.toLowerCase().contains(query) ||
                c.cedula.contains(query))
            .toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF5F3FF),
          appBar: AppBar(
            backgroundColor: AppColors.dark,
            title: const Text('Clientes registrados',
                style: TextStyle(color: AppColors.pinkMid)),
            actions: [
              IconButton(
                tooltip: 'Buscar por cédula',
                icon: const Icon(Icons.badge_outlined, color: Colors.white),
                onPressed: _searchByCedula,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.pink,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Nuevo cliente',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const AdminCustomerFormScreen()),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Buscar por nombre o cédula...',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickDateRange,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: _dateFilter == null
                                ? Colors.white
                                : AppColors.purpleLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.date_range,
                                  size: 16, color: AppColors.purple),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  _dateFilter == null
                                      ? 'Filtrar por fecha de registro'
                                      : '${_fmt(_dateFilter!.start)} – ${_fmt(_dateFilter!.end)}',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.purple),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_dateFilter != null) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        tooltip: 'Quitar filtro',
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => setState(() => _dateFilter = null),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total: ${customers.length} clientes',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 12)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.tealLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                          '${AppData.instance.customers.length} en total',
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.teal)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: customers.isEmpty
                    ? const Center(
                        child: Text('No se encontraron clientes',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.gray)),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                        itemCount: customers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (ctx, i) {
                          final Customer c = customers[i];
                          return GestureDetector(
                            onTap: () => _showCustomerDetail(c),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: AppColors.purple,
                                    child: Text(c.initial,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800)),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(c.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 12)),
                                        Text('CI: ${c.cedula} · ${c.city}',
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: AppColors.gray)),
                                        Text('📧 ${c.email}',
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: AppColors.gray)),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: _statusBg(c.status),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(c.status,
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    _statusColor(c.status))),
                                      ),
                                      const SizedBox(height: 6),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: const Icon(Icons.delete_outline,
                                            size: 18, color: AppColors.gray),
                                        onPressed: () => _confirmDelete(c),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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

class _DetailRow extends StatelessWidget {
  final String icon;
  final String label;
  const _DetailRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
