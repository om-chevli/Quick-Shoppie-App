import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/order.dart' show Orders;

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  @override
  void initState() {
      _isLoading = true;
    Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: CustomBar(appTitle: "Your Orders"),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : orderData.orders.isEmpty
              ? Center(
                  child: Text(
                    "No Orders yet!",
                    style: TextStyle(
                      fontFamily: "Lato",
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                )
              : Column(
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
                    // SizedBox(
                    //   height: 5,
                    // ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                      ),
                    ),
                  ],
                ),
      drawer: AppDrawer(),
    );
  }
}
