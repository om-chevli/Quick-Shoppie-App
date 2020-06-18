import 'package:flutter/foundation.dart';

import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    this.amount,
    this.dateTime,
    this.id,
    this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProd, double total) {
    _orders.insert(
      0,
      OrderItem(
        amount: total,
        dateTime: DateTime.now(),
        id: DateTime.now().toString(),
        products: cartProd,
      ),
    );
    notifyListeners();
  }
}
