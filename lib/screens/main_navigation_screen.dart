import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'catalog_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

// comparte entre Inicio, Productos, Pedidos y Perfil.
// ─────────────────────────────────────────────────────────
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _index = widget.initialIndex;

  // Permite que otras pantallas (ej. Home) cambien de pestaña
  // llamando a MainNavigationScreen.of(context)?.goToTab(1)
  static _MainNavigationScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainNavigationScreenState>();

  void goToTab(int i) => setState(() => _index = i);

  final _screens = const [
    HomeScreen(),
    CatalogScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.pink,
        unselectedItemColor: AppColors.gray,
        backgroundColor: Colors.white,
        elevation: 8,
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), label: 'Productos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined), label: 'Pedidos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }
}

/// Extensión de conveniencia para cambiar de pestaña desde
/// cualquier pantalla hija: NavTab.go(context, 1);
class NavTab {
  static void go(BuildContext context, int index) {
    _MainNavigationScreenState? state =
        context.findAncestorStateOfType<_MainNavigationScreenState>();
    state?.goToTab(index);
  }
}
