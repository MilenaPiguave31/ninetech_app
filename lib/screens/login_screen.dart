import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/app_data.dart';
import '../widgets/kawaii_widgets.dart';
import 'register_screen.dart';
import 'main_navigation_screen.dart';

// ─────────────────────────────────────────────────────────
// login_screen.dart
// Pantalla 1: Inicio de sesión — 9 Tech
// ─────────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailCtrl.text.trim().isEmpty || _passCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa correo y contraseña')),
      );
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600)); // simula red

    // Guarda el nombre de usuario a partir del correo (demo).
    final namePart = _emailCtrl.text.split('@').first;
    AppData.instance.currentUserName =
        namePart.isNotEmpty ? namePart[0].toUpperCase() + namePart.substring(1) : 'Usuario';
    AppData.instance.isAdmin = _emailCtrl.text.trim().toLowerCase() == 'admin';

    if (!mounted) return;
    setState(() => _loading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.dark, AppColors.purple],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('✨', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 12),
                const Text('9 Tech',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
                const Text('Estética Digital Kawaii',
                    style: TextStyle(
                        fontSize: 12, color: Colors.white60)),
                const SizedBox(height: 28),
                TextField(
                  controller: _emailCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Correo electrónico',
                    hintStyle: const TextStyle(color: Colors.white60),
                    prefixIcon: const Icon(Icons.email_outlined,
                        color: Colors.white60),
                    filled: true,
                    fillColor: Colors.white.withOpacity(.12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passCtrl,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    hintStyle: const TextStyle(color: Colors.white60),
                    prefixIcon:
                        const Icon(Icons.lock_outline, color: Colors.white60),
                    filled: true,
                    fillColor: Colors.white.withOpacity(.12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                KawaiiButton(
                  label: 'Iniciar sesión',
                  isLoading: _loading,
                  onPressed: _login,
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: '¿No tienes cuenta? ',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                      children: [
                        TextSpan(
                          text: 'Regístrate',
                          style: TextStyle(
                              color: AppColors.pinkMid,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tip: usa "admin" como correo para entrar como administrador',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withOpacity(.35), fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
