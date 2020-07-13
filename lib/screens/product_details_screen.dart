import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_bar.dart';
import '../widgets/badge.dart';
import '../providers/products_provider.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      // appBar: CustomBar(
      //   appTitle: loadedProduct.title,
      //   implyLeading: true,
      //   act: <Widget>[
      //     Consumer<Cart>(
      //       builder: (_, cart, ch) => Badge(
      //         child: ch,
      //         value: cart.quantCount.toString(),
      //       ),
      //       child: IconButton(
      //         icon: Icon(Icons.shopping_cart),
      //         onPressed: () {
      //           Navigator.pushNamed(context, CartScreen.routeName);
      //         },
      //       ),
      //     ),
      //   ],
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 450,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                loadedProduct.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Anton",
                  color: Colors.deepOrange,
                ),
              ),
              background: Container(
                child: Hero(
                  tag: productId,
                  child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.cover,
                    height: double.maxFinite,
                  ),
                ),
                height: 450,
                width: double.infinity,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),
                Text(
                  "Rs. ${loadedProduct.price.toString()}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(
                    loadedProduct.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: 800,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
