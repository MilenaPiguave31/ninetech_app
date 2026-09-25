import 'product.dart';

class OrderItem {
  final Product product;
  final int quantity;
  final String address;
  final String date;
  final String paymentMethod;
  final String notes;

  const OrderItem({
    required this.product,
    required this.quantity,
    required this.address,
    required this.date,
    required this.paymentMethod,
    this.notes = '',
  });

  double get total => product.price * quantity;
}
