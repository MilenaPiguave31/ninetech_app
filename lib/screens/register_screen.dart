import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/kawaii_widgets.dart';
import 'main_navigation_screen.dart';

// Registro de clientes — 9 Tech

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _ceduCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  void _createAccount() {
    if (_nameCtrl.text.trim().isEmpty || _emailCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa al menos nombre y correo')),
      );
      return;
    }

    showKawaiiSuccessDialog(
      context,
      emoji: '✨',
      title: '¡Cuenta creada!',
      message: 'Bienvenida a 9 Tech, ${_nameCtrl.text.trim()}',
    ).then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Crear cuenta'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 4),
            const Center(
              child: Column(
                children: [
                  Text('✨', style: TextStyle(fontSize: 28)),
                  SizedBox(height: 4),
                  Text('Únete a 9 Tech',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.dark)),
                  Text('Crea tu cuenta kawaii',
                      style: TextStyle(fontSize: 11, color: AppColors.gray)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            KawaiiTextField(
                label: 'Nombre completo',
                controller: _nameCtrl,
                hint: 'María González'),
            const SizedBox(height: 18),
            KawaiiTextField(
                label: 'Cedula / RUC',
                controller: _ceduCtrl,
                hint: '095445521'),
            const SizedBox(height: 12),
            KawaiiTextField(
                label: 'Correo electrónico',
                controller: _emailCtrl,
                hint: 'maria@email.com',
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),
            KawaiiTextField(
                label: 'Teléfono',
                controller: _phoneCtrl,
                hint: '+593 99 000 0000',
                keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            KawaiiTextField(
                label: 'Ciudad', controller: _cityCtrl, hint: 'Guayaquil'),
            const SizedBox(height: 12),
            KawaiiTextField(
                label: 'Contraseña',
                controller: _passCtrl,
                hint: '••••••••',
                obscure: true), //texto oculto para contraseña
            const SizedBox(height: 20),
            KawaiiButton(label: 'Crear cuenta', onPressed: _createAccount),
            const SizedBox(height: 10),
            const Text(
              'Al registrarte aceptas los Términos de servicio',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: AppColors.gray),
            ),
          ],
        ),
      ),
    );
  }
}
