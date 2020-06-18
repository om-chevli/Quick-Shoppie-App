import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_bar.dart';
import '../models/product.dart';
import '../providers/products_provider.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    description: '',
    id: null,
    imageUrl: '',
    title: '',
    price: 0,
  );

  var _initValues = {
    "title": "",
    "description": "",
    "price": "",
    "imageUrl": "",
  };
  var _isInIt = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInIt) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "price": _editedProduct.price.toString(),
          //"imageUrl": _editedProduct.imageUrl,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInIt = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith("http") &&
              !_imageUrlController.text.startsWith("https")) ||
          (!_imageUrlController.text.endsWith(".png") &&
              !_imageUrlController.text.endsWith(".jpg") &&
              !_imageUrlController.text.endsWith(".jpeg"))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An Error Occured!!!"),
            content: Text("Something Went Wrong."),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text("Okay"),
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBar(
        appTitle: "Edit Product",
        act: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
                semanticsLabel: "Just A Second!",
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: "Title"),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          description: _editedProduct.description,
                          id: _editedProduct.id,
                          isFavourite: _editedProduct.isFavourite,
                          imageUrl: _editedProduct.imageUrl,
                          title: value,
                          price: _editedProduct.price,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Product Title cannot be left Empty!";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: "Price"),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocus);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          description: _editedProduct.description,
                          id: _editedProduct.id,
                          isFavourite: _editedProduct.isFavourite,
                          imageUrl: _editedProduct.imageUrl,
                          title: _editedProduct.title,
                          price: double.parse(value),
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Price cannot be left Empty!";
                        }
                        if (double.tryParse(value) == null) {
                          return "Enter Numbers only!";
                        }
                        if (double.tryParse(value) <= 0) {
                          return "Price should be greater then 0!";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: "Description"),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _descriptionFocus,
                      onSaved: (value) {
                        _editedProduct = Product(
                          description: value,
                          id: _editedProduct.id,
                          isFavourite: _editedProduct.isFavourite,
                          imageUrl: _editedProduct.imageUrl,
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Description cannot be left Empty!";
                        }
                        if (value.length <= 20) {
                          return "Description should be greater then 20 characters!";
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Center(
                                  child: Text(
                                  "Enter a URL.",
                                  textAlign: TextAlign.center,
                                ))
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                              //initialValue: _initValues['imageUrl'],
                              decoration:
                                  InputDecoration(labelText: "Image URL"),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              focusNode: _imageUrlFocusNode,
                              controller: _imageUrlController,
                              onSaved: (value) {
                                _editedProduct = Product(
                                  description: _editedProduct.description,
                                  id: _editedProduct.id,
                                  isFavourite: _editedProduct.isFavourite,
                                  imageUrl: value,
                                  title: _editedProduct.title,
                                  price: _editedProduct.price,
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Image cannot be left Empty!";
                                }
                                if (!value.startsWith("http") &&
                                    !value.startsWith("https")) {
                                  return "This isn't a URL!";
                                }
                                if (!value.endsWith(".png") &&
                                    !value.endsWith(".jpg") &&
                                    !value.endsWith(".jpeg")) {
                                  return "Image URL is invalid";
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) {
                                _saveForm();
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
