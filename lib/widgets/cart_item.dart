import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../models/unique_color_generator.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String prodId;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;

  CartItem({
    this.id,
    this.prodId,
    this.price,
    this.quantity,
    this.title,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        padding: EdgeInsets.only(right: 15),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 8,
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            buttonPadding: EdgeInsets.all(5),
            title: Text(
              "Confirmation!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 25,
              ),
            ),
            content: Text(
              "Remove $title from Cart?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text(
                  "Yes",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text(
                  "No",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(
          context,
          listen: false,
        ).removeItem(prodId);
      },
      child: Card(
        color: UniqueColorGenerator.getColor(),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 8,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 10,
            left: 0,
            right: 10,
            top: 10,
          ),
          child: ListTile(
            leading: Container(
              height: 60,
              width: 48,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              '$title',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            subtitle: Text(
              '₹${(price * quantity)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            trailing: Text(
              '$quantity x',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
