import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_products_screen.dart';
import '../models/unique_color_generator.dart';
import '../providers/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(
    this.id,
    this.title,
    this.imageUrl,
  );
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: UniqueColorGenerator.getColor().withAlpha(255),
          width: 5,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductsScreen.routeName, arguments: id);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete_outline),
                color: Theme.of(context).errorColor,
                onPressed: () async {
                  try {
                    await Provider.of<ProductsProvider>(context)
                        .deleteProduct(id);
                  } catch (error) {
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text(
                          "Deleting Failed!!!", 
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
