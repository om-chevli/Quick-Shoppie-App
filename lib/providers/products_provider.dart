import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Denim Jacket',
    //   description: 'Long Sleeves Denim Jackets For Men!',
    //   price: 2000,
    //   imageUrl:
    //       'https://img5.cfcdn.club/69/7b/69d70d66e76538279e325633e94cb37b.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: "Men's T-Shirt",
    //   description: 'Stylesmyth Half Sleeves Cotton T-shirt',
    //   price: 500,
    //   imageUrl:
    //       'https://img5.cfcdn.club/f2/6c/f2bbf75562e0db5a549382732fd1076c.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: "Girl's Top",
    //   description: "Raabta's White Cold Shoulder Top With Black Knotes",
    //   price: 500,
    //   imageUrl:
    //       'https://img5.cfcdn.club/90/34/909caa34990bd4a150c7a5a35dd3eb34.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Cotton Jacket',
    //   description: 'Fashion Trap Women Cotton Jacket for Women and Girls',
    //   price: 1500,
    //   imageUrl:
    //       'https://img5.cfcdn.club/cd/97/cd3471a00d6b54b89a66bcea3c94c197.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((prod) => prod.isFavourite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    const url = "https://lets-start-flutter.firebaseio.com/products.json";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData==null){
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
        }),
      );
      final newProduct = Product(
        description: product.description,
        id: json.decode(response.body)["name"],
        imageUrl: product.imageUrl,
        title: product.title,
        price: product.price,
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
