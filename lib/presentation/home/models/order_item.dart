import 'package:flutter_pos/data/model/response/product_response_model.dart';

class OrderItem {
  final Product product;
  int quantity;

  OrderItem({
    required this.product,
    required this.quantity,
  });
}
