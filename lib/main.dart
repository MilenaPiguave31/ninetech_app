import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

// Esta es la aplicación principal.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Nombre de la aplicación.
      title: '9 Tech',

      // Quita la palabra DEBUG.
      debugShowCheckedModeBanner: false,

      // Usa nuestros colores.
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
