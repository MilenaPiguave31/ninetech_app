import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/kawaii_widgets.dart';

// ─────────────────────────────────────────────────────────
// contact_screen.dart
// Pantalla 7: Formulario de contacto
// ─────────────────────────────────────────────────────────
class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  String _reason = 'Pedido';

  void _send() {
    if (_nameCtrl.text.trim().isEmpty || _messageCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa tu nombre y mensaje')),
      );
      return;
    }
    showKawaiiSuccessDialog(
      context,
      emoji: '💌',
      title: '¡Mensaje enviado!',
      message: 'Te responderemos en menos de 24h.',
    ).then((_) {
      if (Navigator.canPop(context)) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contáctanos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Column(
                children: [
                  Text('💌', style: TextStyle(fontSize: 28)),
                  SizedBox(height: 4),
                  Text('Escríbenos',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.dark)),
                  Text('Respondemos en menos de 24h',
                      style: TextStyle(fontSize: 11, color: AppColors.gray)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            KawaiiTextField(label: 'Nombre', controller: _nameCtrl),
            const SizedBox(height: 12),
            KawaiiTextField(
                label: 'Correo electrónico',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),
            KawaiiTextField(label: 'Asunto', controller: _subjectCtrl),
            const SizedBox(height: 12),
            const Text('Motivo de contacto',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              children: ['Pedido', 'Garantía', 'Otro'].map((r) {
                return KawaiiPill(
                  label: r,
                  selected: _reason == r,
                  onTap: () => setState(() => _reason = r),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            KawaiiTextField(
                label: 'Mensaje', controller: _messageCtrl, maxLines: 3),
            const SizedBox(height: 18),
            KawaiiButton(label: 'Enviar mensaje 💌', onPressed: _send),
            const SizedBox(height: 14),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('📞 +593 99 000 0000',
                    style: TextStyle(fontSize: 11, color: AppColors.gray)),
                SizedBox(width: 16),
                Text('📧 grupo@9tech.com',
                    style: TextStyle(fontSize: 11, color: AppColors.gray)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
