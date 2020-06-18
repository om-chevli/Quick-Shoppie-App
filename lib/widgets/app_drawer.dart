import 'package:flutter/material.dart';

import './custom_bar.dart';
import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          CustomBar(
            appTitle: "Let's Shop!",
            implyLeading: false,
          ),
          ListTile(
            leading: Icon(
              Icons.shop,
              color: Colors.deepOrange,
            ),
            title: Text(
              "Shoppie",
              style: TextStyle(
                fontFamily: "Pacifico",
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.payment,
              color: Colors.green,
            ),
            title: Text(
              "Your Orders",
              style: TextStyle(
                fontFamily: "Pacifico",
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.edit,
              color: Colors.purple,
            ),
            title: Text(
              "Manage Products",
              style: TextStyle(
                fontFamily: "Pacifico",
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
