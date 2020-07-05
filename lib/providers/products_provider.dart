import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];
  final String authToken;

  ProductsProvider(this.authToken, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((prod) => prod.isFavourite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    final url = "https://lets-start-flutter.firebaseio.com/products.json?auth=$authToken";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodID, prodData) {
        loadedProducts.add(Product(
          description: prodData["description"],
          id: prodID,
          imageUrl: prodData["imageUrl"],
          title: prodData["title"],
          price: prodData["price"],
          isFavourite: prodData["isFavourite"],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    const url = "https://lets-start-flutter.firebaseio.com/products.json";
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "title": product.title,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavourite": product.isFavourite,
        }),
      );
      final newProduct = Product(
        description: product.description,
        id: json.decode(response.body)["name"],
        imageUrl: product.imageUrl,
        title: product.title,
        price: product.price,
        isFavourite: product.isFavourite,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print("Error Occured In Adding!");
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodId = _items.indexWhere((prod) => prod.id == id);
    if (prodId >= 0) {
      final url = "https://lets-start-flutter.firebaseio.com/products/$id.json";
      try {
        await http.patch(url,
            body: json.encode({
              "description": newProduct.description,
              "imageUrl": newProduct.imageUrl,
              "price": newProduct.price,
              "title": newProduct.title,
            }));
      } catch (error) {
        print(error);
      }
      _items[prodId] = newProduct;
      notifyListeners();
    } else {
      print("...");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = "https://lets-start-flutter.firebaseio.com/products/$id.json";
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could'nt Delete Product!");
    }
    existingProduct = null;
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
