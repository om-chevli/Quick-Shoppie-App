import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/order.dart' show Orders;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: CustomBar(appTitle: "Your Orders"),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
            } else if (dataSnapShot.error != null) {
              //Error Handling Here
              return Center(
                child: Text("An Error Occured"),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) {
                  if (orderData.orders.isEmpty) {
                    return Center(
                      child: Text(
                        "No Orders yet!",
                        style: TextStyle(
                          fontFamily: "Lato",
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                    );
                  }
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Receipts",
                        style: TextStyle(
                          fontFamily: "Lato",
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
