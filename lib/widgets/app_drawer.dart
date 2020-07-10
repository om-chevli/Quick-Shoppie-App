import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './custom_bar.dart';
import '../providers/auth.dart';
import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
          Divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.grey,
            ),
            title: Text(
              "Logout",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop(); //in order to close the drawer when you press logout
              Navigator.of(context).pushReplacementNamed('/'); //in order to bring it to the home page where the whole logic is present
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
