import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

enum Mode { EDIT_MODE, CREATE_MODE }

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  var _isInit = false;
  final _priceFocusNode = FocusNode();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _sizeFocusNode = FocusNode();
  final imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Mode mode = Mode.CREATE_MODE;

  // var _editedProduct;

  var _editedProduct = Product(
    id: DateTime.now().toIso8601String(),
    price: 0.0,
    title: '',
    description: '',
    imageUrl: '',
    isFavorite: false,
    color: '',
    size: '',
    inStock: 0,
    categories: null,
  );

  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
    'color': '',
    'size': '',
    'inStock': '0',
    'categories': null,
  };
  var _isLoading = false;

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _imageUrlFocusNode.dispose();

    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (imageUrlController.text.isEmpty) {
        setState(() {});
        return;
      }
      if (validateImageUrl(imageUrlController.text) != null) {
        print(validateImageUrl(imageUrlController.text));
        return;
      }

      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    //,,,
    _form.currentState.validate();
    _form.currentState.save();
    _isLoading = true;

    if (imageUrlController.text.isEmpty ||
        validateImageUrl(imageUrlController.text) != null) {
      _isLoading = false;
      throw new Error();
    }

    if (mode == Mode.EDIT_MODE) {
      try {
        await Provider.of<Products>(context, listen: false)
            .editProduct(_editedProduct.id, _editedProduct)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        });
      } catch (e) {
        await wilfredErrorDialog(context);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await wilfredErrorDialog(context);
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  Future wilfredErrorDialog(BuildContext ctx) {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            semanticLabel: 'Error saving product',
            title: Text('Error saving product'),
            content: Text('Something went wrong'),
            actions: <Widget>[
              FlatButton(
                child: Text('ok'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;

      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);

        mode = Mode.EDIT_MODE;

        _initValues = {
          'id': _editedProduct.id,
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': _editedProduct.imageUrl,
          'color': _editedProduct.color,
          'size': _editedProduct.size,
          'inStock': _editedProduct.inStock.toString(),
          'categories': _editedProduct.categories.toString()
        };
        imageUrlController.text = _editedProduct.imageUrl;
      }

      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveForm,
            )
          ],
        ),
        body: _isLoading
            ? SingleChildScrollView(
                child: CircularProgressIndicator(
                  semanticsLabel: 'Loading',
                ),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Form(
                    key: _form,
                    child: ListView(
                      children: <Widget>[
                        buildTextFormField(
                          enabled: mode == Mode.CREATE_MODE,
                          context: context,
                          initValue: _initValues['id'],
                          errorText: 'Please provide an id',
                          labelText: 'Product ID',
                          nextFocusNode: _titleFocusNode,
                          onSaved: (value) => {
                            _editedProduct = Product(
                              title: _editedProduct.title,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.id,
                              description: _editedProduct.description,
                              id: value,
                              isFavorite: _editedProduct.isFavorite,
                              color: _editedProduct.color,
                              size: _editedProduct.size,
                              inStock: _editedProduct.inStock,
                              categories: _editedProduct.categories,
                            )
                          },
                        ),
                        buildTextFormField(
                          context: context,
                          focusNode: _titleFocusNode,
                          errorText: 'Please provide a value',
                          initValue: _initValues['title'],
                          labelText: 'Title',
                          nextFocusNode: _priceFocusNode,
                          onSaved: (value) => {
                            _editedProduct = Product(
                              title: value,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.id,
                              description: _editedProduct.description,
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              color: _editedProduct.color,
                              size: _editedProduct.size,
                              inStock: _editedProduct.inStock,
                              categories: _editedProduct.categories,
                            )
                          },
                        ),
                        buildTextFormField(
                          context: context,
                          focusNode: _priceFocusNode,
                          errorText: 'Please provide a price.',
                          initValue: _initValues['price'],
                          labelText: 'Price',
                          nextFocusNode: _descriptionFocusNode,
                          onSaved: (value) => {
                            _editedProduct = Product(
                                price: double.parse(value),
                                title: _editedProduct.title,
                                imageUrl: _editedProduct.id,
                                description: _editedProduct.description,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                color: _editedProduct.color,
                                size: _editedProduct.size,
                                inStock: _editedProduct.inStock,
                                categories: _editedProduct.categories)
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues['description'],
                          maxLines: 3,
                          decoration: InputDecoration(labelText: 'Description'),
                          // textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide a description.';
                            } else if (value.length < 8) {
                              return 'Should be 8 characters or more.';
                            }
                            return null;
                          },
                          onSaved: (value) => {
                            _editedProduct = Product(
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                imageUrl: _editedProduct.id,
                                description: value,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                color: _editedProduct.color,
                                size: _editedProduct.size,
                                inStock: _editedProduct.inStock,
                                categories: _editedProduct.categories)
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(top: 8, right: 10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                              ),
                              child: imageUrlController.text.isEmpty
                                  ? Text('Enter Url')
                                  : FittedBox(
                                      child: Image.network(
                                        imageUrlController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Image Url'),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.url,
                                controller: imageUrlController,
                                focusNode: _imageUrlFocusNode,
                                validator: (value) {
                                  return validateImageUrl(value);
                                },
                                onFieldSubmitted: (val) => _saveForm(),
                                onSaved: (value) => {
                                  _editedProduct = Product(
                                      title: _editedProduct.title,
                                      price: _editedProduct.price,
                                      imageUrl: value,
                                      description: _editedProduct.description,
                                      id: _editedProduct.id,
                                      isFavorite: _editedProduct.isFavorite,
                                      color: _editedProduct.color,
                                      size: _editedProduct.size,
                                      inStock: _editedProduct.inStock,
                                      categories: _editedProduct.categories)
                                },
                              ),
                            ),
                          ],
                        ),
                        buildTextFormField(
                          context: context,
                          errorText: 'Please provide a color',
                          initValue: _initValues['color'],
                          labelText: 'Color',
                          nextFocusNode: _sizeFocusNode,
                          onSaved: (value) => {
                            _editedProduct = Product(
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                imageUrl: _editedProduct.imageUrl,
                                description: _editedProduct.description,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                color: value,
                                size: _editedProduct.size,
                                inStock: _editedProduct.inStock,
                                categories: _editedProduct.categories)
                          },
                        ),
                        buildTextFormField(
                          context: context,
                          errorText: 'Please provide a size',
                          initValue: _initValues['size'],
                          labelText: 'Size',
                          focusNode: _sizeFocusNode,
                          nextFocusNode: _sizeFocusNode,
                          onSaved: (value) => {
                            _editedProduct = Product(
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                imageUrl: _editedProduct.imageUrl,
                                description: _editedProduct.description,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                                color: _editedProduct.color,
                                size: value,
                                inStock: _editedProduct.inStock,
                                categories: _editedProduct.categories)
                          },
                        ),
                        buildTextFormField(
                          context: context,
                          errorText: 'Please provide the qty available',
                          initValue: _initValues['inStock'],
                          labelText: 'Available Quantity',
                          // focusNode: _sizeFocusNode,
                          nextFocusNode: _sizeFocusNode,
                          onSaved: (value) => {
                            _editedProduct = Product(
                              title: _editedProduct.title,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              description: _editedProduct.description,
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              color: _editedProduct.color,
                              size: _editedProduct.size,
                              inStock: int.parse(value),
                              categories: _editedProduct.categories,
                            )
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }

  TextFormField buildTextFormField({
    @required BuildContext context,
    @required String initValue,
    @required String labelText,
    @required String errorText,
    @required FocusNode nextFocusNode,
    FocusNode focusNode,
    @required Function onSaved,
    enabled = true,
  }) {
    return TextFormField(
      initialValue: initValue,
      enabled: enabled,
      focusNode: focusNode,
      decoration: InputDecoration(labelText: labelText),
      validator: (value) {
        if (value.isEmpty) {
          return errorText;
        } else {
          return null;
        }
      },
      textInputAction: TextInputAction.next,
      onSaved: onSaved,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(nextFocusNode);
      },
    );
  }

  String validateImageUrl(value) {
    if (!value.startsWith('http') && !value.startsWith('https')) {
      print('invalid img');
      return 'Invalid Image URL <http / https>';
    }

    if (!value.endsWith('.png') &&
        !value.endsWith('.jpg') &&
        !value.endsWith('.jpeg')) {
      print('invalid img');
      return 'Invalid Image URL <jpg, jpeg, png>';
    }
    return null;
  }
}
