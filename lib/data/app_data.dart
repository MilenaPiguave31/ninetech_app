import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/customer.dart';
import '../models/order.dart';


class AppData extends ChangeNotifier {
  AppData._internal();
  static final AppData instance = AppData._internal();

  // ── Sesión
  String currentUserName = 'María';
  bool isAdmin = false;

  // ── Productos
  final List<Product> products = [
    const Product(
      name: 'Auricular Kawaii Pro',
      category: 'Gadgets',
      icon: '🎧',
      price: 24.99,
      stockLabel: 'En stock ✅',
      stock: 40,
      description: 'Auriculares inalámbricos con diseño kawaii y sonido HD.',
      images: [
        'assets/products/auricular_kawaii.png',
        'assets/products/auricular_dragonball.png',
      ],
    ),
    const Product(
      name: 'Teclado Pastel RGB',
      category: 'Gadgets',
      icon: '⌨️',
      price: 39.99,
      stockLabel: 'En stock ✅',
      stock: 25,
      description: 'Teclado mecánico con retroiluminación RGB y colores pastel.',
      images: [
        'assets/products/teclado_sanrio_rgb.png',
        'assets/products/teclado_gatitos.png',
        'assets/products/teclado_mouse_pastel.png',
      ],
    ),
    const Product(
      name: 'Mouse Kawaii Edition',
      category: 'Periféricos',
      icon: '🖱️',
      price: 18.50,
      stockLabel: 'En stock ✅',
      stock: 60,
      description: 'Mouse inalámbrico ergonómico edición kawaii.',
      images: [
        'assets/products/teclado_mouse_pastel.png',
      ],
    ),
    const Product(
      name: 'Agenda Pastel 2026',
      category: 'Papelería',
      icon: '📓',
      price: 12.99,
      stockLabel: 'Últimas 3',
      stock: 3,
      description: 'Agenda anual con diseño pastel y stickers incluidos.',
      images: [
        'assets/products/agenda_notas_oso.png',
        'assets/products/agenda_lapices_10colores.png',
        'assets/products/agenda_lapices_demonslayer.png',
        'assets/products/agenda_organizador.png',
      ],
    ),
    const Product(
      name: 'Mochila Tech Kawaii',
      category: 'Accesorios',
      icon: '🎒',
      price: 35.00,
      stockLabel: 'En stock ✅',
      stock: 18,
      description: 'Mochila resistente al agua con compartimento acolchado.',
      images: [
        'assets/products/mochila_naruto.png',
        'assets/products/mochila_demonslayer.png',
        'assets/products/mochila_totoro.png',
      ],
    ),
  ];

  void addProduct(Product product) {
    products.add(product);
    notifyListeners();
  }

  // ── Clientes
  final List<Customer> customers = [
    Customer(
        cedula: '0912345678',
        name: 'María González',
        email: 'maria@email.com',
        phone: '0991234567',
        city: 'Guayaquil',
        status: 'VIP',
        registeredAt: DateTime(2026, 1, 12)),
    Customer(
        cedula: '1723456789',
        name: 'Luis Mendoza',
        email: 'luis@email.com',
        phone: '0987654321',
        city: 'Quito',
        status: 'Nuevo',
        registeredAt: DateTime(2026, 6, 3)),
    Customer(
        cedula: '0102345678',
        name: 'Ana Torres',
        email: 'ana@email.com',
        phone: '0976543210',
        city: 'Cuenca',
        status: 'Activo',
        registeredAt: DateTime(2026, 3, 21)),
    Customer(
        cedula: '1104567890',
        name: 'Carlos Ruiz',
        email: 'carlos@email.com',
        phone: '0965432109',
        city: 'Loja',
        status: 'Activo',
        registeredAt: DateTime(2026, 8, 5)),
  ];

  /// Consulta específica: busca un cliente por su número de cédula exacto.
  /// Retorna null si no existe ningún cliente con esa cédula.
  Customer? findCustomerByCedula(String cedula) {
    final query = cedula.trim();
    if (query.isEmpty) return null;
    for (final c in customers) {
      if (c.cedula == query) return c;
    }
    return null;
  }

  /// Verifica si ya existe un cliente registrado con esa cédula.
  bool customerExists(String cedula) =>
      customers.any((c) => c.cedula == cedula.trim());

  /// Crea un nuevo cliente.
  void addCustomer(Customer customer) {
    customers.add(customer);
    notifyListeners();
  }

  /// Actualiza los datos de un cliente existente, ubicándolo por su cédula
  /// original (por si la cédula también fue editada).
  bool updateCustomer(String originalCedula, Customer updated) {
    final index = customers.indexWhere((c) => c.cedula == originalCedula);
    if (index == -1) return false;
    customers[index] = updated;
    notifyListeners();
    return true;
  }

  /// Elimina un cliente por su cédula.
  bool deleteCustomer(String cedula) {
    final removed = customers.length;
    customers.removeWhere((c) => c.cedula == cedula);
    final changed = customers.length != removed;
    if (changed) notifyListeners();
    return changed;
  }
List<Customer> queryCustomers({DateTime? from, DateTime? to}) {
    return customers.where((c) {
      if (from != null && c.registeredAt.isBefore(from)) return false;
      if (to != null && c.registeredAt.isAfter(to)) return false;
      return true;
    }).toList()
      ..sort((a, b) => b.registeredAt.compareTo(a.registeredAt));
  }

  // ── Pedidos
  final List<OrderItem> orders = [];

  void addOrder(OrderItem order) {
    orders.insert(0, order);
    notifyListeners();
  }

  // ── Reservas
  final List<String> reservations = [];

  void addReservation(String description) {
    reservations.insert(0, description);
    notifyListeners();
  }
}
