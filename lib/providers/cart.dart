import 'package:flutter/foundation.dart';

class CartItem with ChangeNotifier {
  final String title;
  final double price;
  final String id;
  final int quantity;
  final String imageUrl;

  CartItem({
    @required this.id,
    @required this.quantity,
    @required this.title,
    @required this.price,
    @required this.imageUrl,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    //return a copy of Map
    return {..._items};
  }

  int get quantCount {
    int quant = 0;
    _items.forEach((key, cartItem) {
      quant += cartItem.quantity;
    });
    return quant;
  }

  int get itemCount {
    return _items.length;
  }

  double get cartTotal {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItems(String productId, String title, double price, String url) {
    if (_items.containsKey(productId)) {
      //change quatity
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
          title: existingItem.title,
          imageUrl: existingItem.imageUrl,
        ),
      );
    } else {
      //addProduct
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          price: price,
          quantity: 1,
          title: title,
          imageUrl: url,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              quantity: existingCartItem.quantity - 1,
              title: existingCartItem.title,
              price: existingCartItem.price,
              imageUrl: existingCartItem.imageUrl));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
