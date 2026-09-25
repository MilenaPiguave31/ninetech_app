class Product {
  final String name;
  final String category;
  final String icon; // emoji usado como imagen (kawaii style)
  final double price;
  final String stockLabel; // ej: "En stock ✅" o "Últimas 3"
  final String description;
  final int stock;
  final List<String> images; // rutas en assets/products/, la primera es la portada

  const Product({
    required this.name,
    required this.category,
    required this.icon,
    required this.price,
    required this.stockLabel,
    this.description = '',
    this.stock = 0,
    this.images = const [],
  });

  String get priceLabel => '\$${price.toStringAsFixed(2)}';

  /// Imagen principal del producto, o null si sólo tiene el emoji.
  String? get coverImage => images.isNotEmpty ? images.first : null;
}
