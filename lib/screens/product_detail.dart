import 'package:flutter/material.dart';
import 'package:letsshop/providers/cart.dart';
import 'package:letsshop/providers/product.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(context, listen: false).findById(id);
    final cartProvider = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 300,
              child: Hero(
                  tag: product.id,
                  child: Image.network(product.imageUrl, fit: BoxFit.cover)),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  'Price: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '\$${product.price}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            if (product.color != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Color: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    product.color ?? '',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            SizedBox(
              height: 10,
            ),
            if (product.size != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Size: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    product.size ?? '',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 50),
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            new ProductAddButton(cartProvider: cartProvider, product: product)
          ],
        ),
      ),
    );
  }
}

class ProductAddButton extends StatelessWidget {
  const ProductAddButton({
    Key key,
    @required this.cartProvider,
    @required this.product,
  }) : super(key: key);

  final Cart cartProvider;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: 50,
      child: FlatButton(
        padding: EdgeInsets.all(10),
        color: Theme.of(context).primaryColor,
        child: Text(
          'ADD TO CART',
          style: Theme.of(context).textTheme.title,
        ),
        onPressed: () {
          cartProvider.addItem(CartItem(
              id: product.id,
              price: product.price,
              qty: 1,
              title: product.title));

          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: 2),
              content: Text('Item added to Cart'),
              action: SnackBarAction(
                label: 'UNDO',
                onPressed: () {
                  cartProvider.removeSingleItem(product.id);
                },
              )));
        },
      ),
    );
  }
}
