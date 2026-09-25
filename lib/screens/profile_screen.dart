import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/app_data.dart';
import 'reservation_screen.dart';
import 'contact_screen.dart';
import 'about_screen.dart';
import 'login_screen.dart';
import 'admin/admin_dashboard_screen.dart';

// ─────────────────────────────────────────────────────────
// profile_screen.dart
// Pestaña "Perfil": datos del cliente y accesos a
// Reservas, Contacto, Quiénes somos, Admin y Cerrar sesión.
// ─────────────────────────────────────────────────────────
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppData.instance,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Perfil')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: AppColors.pink,
                      child: Text(
                        AppData.instance.currentUserName.isNotEmpty
                            ? AppData.instance.currentUserName[0]
                            : '?',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(AppData.instance.currentUserName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800)),
                    if (AppData.instance.isAdmin)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text('🔑 Administrador',
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.purple,
                                fontWeight: FontWeight.w700)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _ProfileTile(
                icon: Icons.calendar_month_outlined,
                color: AppColors.teal,
                label: 'Reservar servicio',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ReservationScreen())),
              ),
              _ProfileTile(
                icon: Icons.mail_outline,
                color: AppColors.purple,
                label: 'Contáctanos',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ContactScreen())),
              ),
              _ProfileTile(
                icon: Icons.groups_outlined,
                color: AppColors.blue,
                label: 'Quiénes somos',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AboutScreen())),
              ),
              if (AppData.instance.isAdmin)
                _ProfileTile(
                  icon: Icons.admin_panel_settings_outlined,
                  color: AppColors.amber,
                  label: 'Panel de administración',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AdminDashboardScreen())),
                ),
              const SizedBox(height: 12),
              _ProfileTile(
                icon: Icons.logout,
                color: Colors.redAccent,
                label: 'Cerrar sesión',
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 6),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(.15),
          child: Icon(icon, color: color),
        ),
        title: Text(label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.gray),
        onTap: onTap,
      ),
    );
  }
}
