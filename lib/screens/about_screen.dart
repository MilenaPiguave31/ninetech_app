import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────
// about_screen.dart
// Pantalla 8: Quiénes somos
// ─────────────────────────────────────────────────────────
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _team = [
    {'name': 'Milena Piguave', 'role': 'Fundadora & Diseño', 'color': AppColors.pink},
    {'name': 'Ronaldo Chuquimarca', 'role': 'Tecnología & Dev', 'color': AppColors.purple},
    {'name': 'Gabriel López', 'role': 'Operaciones', 'color': AppColors.blue},
    {'name': 'Fabricio Vera', 'role': 'Marketing kawaii', 'color': AppColors.teal},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiénes somos')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [AppColors.dark, AppColors.purple]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('9 Tech ✨',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900)),
                Text('Estética Digital Kawaii · Guayaquil',
                    style: TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 6)
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nuestra historia',
                    style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 13)),
                SizedBox(height: 6),
                Text(
                  'Somos un emprendimiento ecuatoriano que une la tecnología con '
                  'la estética kawaii. Más de 10,000 clientes confían en nosotros. '
                  '⭐ 4.9 estrellas · +500 productos únicos.',
                  style: TextStyle(fontSize: 12, color: AppColors.gray, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Nuestro equipo',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          const SizedBox(height: 10),
          ..._team.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: m['color'] as Color,
                      child: Text((m['name'] as String)[0],
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m['name'] as String,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 13)),
                        Text(m['role'] as String,
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.gray)),
                      ],
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.pinkLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Misión',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: AppColors.pink)),
                SizedBox(height: 4),
                Text('Llevar tecnología linda a cada escritorio ecuatoriano.',
                    style: TextStyle(fontSize: 12, color: AppColors.dark)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
