import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/app_data.dart';
import '../widgets/kawaii_widgets.dart';

// ─────────────────────────────────────────────────────────
// reservation_screen.dart
// Pantalla 6: Reserva de servicio / asesoría personalizada
// ─────────────────────────────────────────────────────────
class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  static const _types = [
    '🎧 Gadgets y periféricos',
    '📓 Papelería y agendas',
    '🎨 Armado de setup kawaii',
  ];

  String _type = _types.first;
  DateTime _date = DateTime.now().add(const Duration(days: 8));
  TimeOfDay _time = const TimeOfDay(hour: 10, minute: 0);
  String _mode = 'Presencial';
  final _messageCtrl =
      TextEditingController(text: 'Quiero armar mi setup completo');

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  void _confirm() {
    final desc =
        '$_type · ${_formattedDate(_date)} · ${_time.format(context)} · $_mode';
    AppData.instance.addReservation(desc);

    showKawaiiSuccessDialog(
      context,
      emoji: '📅',
      title: '¡Cita reservada!',
      message: 'Te esperamos el ${_formattedDate(_date)} a las ${_time.format(context)}.',
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
    return Scaffold(
      appBar: AppBar(title: const Text('Reservar servicio')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppColors.teal, AppColors.blue]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('Asesoría personalizada kawaii ✨',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
            ),
            const SizedBox(height: 16),
            const Text('Tipo de asesoría',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            const SizedBox(height: 6),
            ..._types.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: GestureDetector(
                    onTap: () => setState(() => _type = t),
                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _type == t ? AppColors.pink : const Color(0xFFEEEEEE),
                          width: 1.5,
                        ),
                      ),
                      child: Text(t, style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                )),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: KawaiiTextField(
                  label: 'Fecha preferida',
                  controller:
                      TextEditingController(text: '📅  ${_formattedDate(_date)}'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickTime,
              child: AbsorbPointer(
                child: KawaiiTextField(
                  label: 'Horario',
                  controller: TextEditingController(
                      text: '🕐  ${_time.format(context)}'),
                ),
              ),
            ),
            const SizedBox(height: 12),

            const Text('Modalidad',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              children: ['Presencial', 'Virtual'].map((m) {
                final icon = m == 'Presencial' ? '📍' : '📱';
                return KawaiiPill(
                  label: '$icon $m',
                  selected: _mode == m,
                  color: AppColors.teal,
                  onTap: () => setState(() => _mode = m),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            KawaiiTextField(
                label: 'Mensaje', controller: _messageCtrl, maxLines: 2),
            const SizedBox(height: 18),
            KawaiiButton(label: 'Reservar cita', onPressed: _confirm),
          ],
        ),
      ),
    );
  }
}
