import 'package:flutter/material.dart';
import 'package:letsshop/providers/cart.dart';
import 'package:letsshop/screens/cart_screen.dart';
import 'package:letsshop/widgets/PLP.dart';
import 'package:letsshop/widgets/badge.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {
  static String routeName = './categorysreen';
  const CategoryScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryName = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: Text('ShopClass'), actions: <Widget>[
        Consumer<Cart>(
          builder: (ctx, cart, child) => Badge(
            child: child,
            value: cart.itemCount.toString(),
            // value: itemsTotal.toString(),
          ),
          child: IconButton(
            icon: Icon(Icons.shopping_basket),
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        )
      ]),
      body: PLP(categoryName: categoryName),
    );
  }
}
