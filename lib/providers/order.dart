import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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

  Future<void> addOrder(List<CartItem> cartProd, double total) async {
    const url = "https://lets-start-flutter.firebaseio.com/orders.json";
    final response = await http.post(url,
        body: json.encode({
          "amount": total,
          "dateTime": DateTime.now().toIso8601String(),
          "products": cartProd
              .map((cp) => {
                    "id": cp.id,
                    "title": cp.title,
                    "quantity": cp.quantity,
                    "price": cp.price,
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        amount: total,
        dateTime: DateTime.now(),
        id: json.decode(response.body)["name"],
        products: cartProd,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    const url = "https://lets-start-flutter.firebaseio.com/orders.json";
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    final List<OrderItem> _loadedOrders = [];
    extractedData.forEach((orderId, orderData) {
      _loadedOrders.add(
        OrderItem(
          amount: orderData["amount"],
          id: orderId,
          dateTime: DateTime.parse(orderData["dateTime"]),
          products: (orderData["products"] as List<dynamic>)
              .map(
                (item) => CartItem(
                    id: item["id"],
                    quantity: item["quantity"],
                    title: item["title"],
                    price: item["price"],
                    imageUrl: null),
              )
              .toList(),
        ),
      );
    });
    _orders = _loadedOrders.reversed.toList();
    notifyListeners();
  }
}
