import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_details_screen.dart';
import '../models/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  // final String imageUrl;
  // final String title;
  // final String id;

  // ProductItem({
  //   this.id,
  //   this.imageUrl,
  //   this.title,
  // });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final scaffold = Scaffold.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 10,
            color: Colors.black54,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailsScreen.routeName,
                arguments: product.id,
              );
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Theme.of(context).accentColor,
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border,
                ),
                color: Colors.red,
                onPressed: () {
                  product.toggleFavouriteStatus();
                },
              ),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: TextStyle(
                color: Colors.black,
                //fontWeight: FontWeight.bold,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                cart.addItems(
                  product.id,
                  product.title,
                  product.price,
                  product.imageUrl,
                );
                Scaffold.of(context).removeCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Added to Cart!"),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
              },
              color: Color.fromRGBO(42, 51, 67, 1),
            ),
          ),
        ),
      ),
    );
  }
}
