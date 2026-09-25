class Customer {
  final String cedula;
  final String name;
  final String email;
  final String phone;
  final String city;
  final String status; // VIP, Nuevo, Activo
  final DateTime registeredAt;

  const Customer({
    required this.cedula,
    required this.name,
    required this.email,
    this.phone = '',
    required this.city,
    required this.status,
    required this.registeredAt,
  });

  String get initial => name.isNotEmpty ? name[0].toUpperCase() : '?';

  Customer copyWith({
    String? cedula,
    String? name,
    String? email,
    String? phone,
    String? city,
    String? status,
    DateTime? registeredAt,
  }) {
    return Customer(
      cedula: cedula ?? this.cedula,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      status: status ?? this.status,
      registeredAt: registeredAt ?? this.registeredAt,
    );
  }
}
