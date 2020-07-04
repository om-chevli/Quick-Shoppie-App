import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './orders_screen.dart';
import '../widgets/custom_bar.dart';
import '../widgets/cart_item.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart' show Cart;
import '../providers/order.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: CustomBar(
        appTitle: "Your Cart",
      ),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 8,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => CartItem(
                id: cart.items.values.toList()[i].id,
                price: cart.items.values.toList()[i].price,
                prodId: cart.items.keys.toList()[i],
                quantity: cart.items.values.toList()[i].quantity,
                title: cart.items.values.toList()[i].title,
                imageUrl: cart.items.values.toList()[i].imageUrl,
              ),
              itemCount: cart.itemCount,
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).accentColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).accentColor,
                  offset: Offset(3, 3),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Cart Total",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 60),
                Chip(
                  label: Text(
                    '₹ ${cart.cartTotal}',
                    style: TextStyle(
                      //fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  backgroundColor: Theme.of(context).canvasColor,
                ),
              ],
            ),
          ),
          CheckoutButton(cart: cart),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}

class CheckoutButton extends StatefulWidget {
  const CheckoutButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _CheckoutButtonState createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends State<CheckoutButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              "Checkout Now!",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: !_isLoading ? null : Colors.white,
              ),
            ),
      color: Color.fromRGBO(244, 0, 0, 1),
      onPressed: (widget.cart.cartTotal <= 0)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.cartTotal,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
              Navigator.pushNamed(context, OrdersScreen.routeName);
            },
    );
  }
}
