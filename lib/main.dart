import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './providers/products_provider.dart';
import './providers/cart.dart';
import './providers/order.dart';
import './providers/auth.dart';
import './screens/orders_screen.dart';
import './screens/product_details_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_products_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          update: (ctx, auth, previousProductsProvider) => ProductsProvider(
            auth.token,
            previousProductsProvider != null
                ? previousProductsProvider.items
                : [],
            auth.userId,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders != null ? previousOrders.orders : [],
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: "My Shop",
          theme: ThemeData(
            primaryColor: Color.fromRGBO(22, 25, 37, 1),
            accentColor: Color.fromRGBO(219, 147, 176, 0.7),
            canvasColor: Color.fromRGBO(197, 205, 225, 1),
            fontFamily: "Lato",
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, dataSnapshot) =>
                      dataSnapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductsScreen.routeName: (ctx) => EditProductsScreen(),
          },
        ),
      ),
    );
  }
}
