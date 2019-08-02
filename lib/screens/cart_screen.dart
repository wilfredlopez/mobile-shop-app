import 'package:flutter/material.dart';
import 'package:letsshop/providers/products_provider.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

import '../providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = './cart';

  void orderNow() {}
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 20,
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  new OrderNowButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, index) => CartItems(
                  id: cart.items.values.toList()[index].id,
                  qty: cart.items.values.toList()[index].qty,
                  productId: cart.items.keys.toList()[index],
                  price: cart.items.values.toList()[index].price,
                  title: cart.items.values.toList()[index].title),
            ),
          )
        ],
      ),
    );
  }
}

class OrderNowButton extends StatefulWidget {
  const OrderNowButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderNowButtonState createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends State<OrderNowButton> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      disabledTextColor: Colors.grey,
      textColor: Theme.of(context).primaryColor,
      child: isLoading
          ? CircularProgressIndicator(
              semanticsLabel: 'Loading',
            )
          : Text(
              'ORDER NOW',
            ),
      onPressed: (widget.cart.totalAmount == 0 || isLoading)
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              Provider.of<Order>(context, listen: false)
                  .addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              )
                  .then((_) {
                widget.cart.items.forEach((key, item) async {
                  await Provider.of<Products>(context).decreaseQty(key);
                });
                setState(() {
                  isLoading = false;
                });
                widget.cart.clearCart();
              });
            },
    );
  }
}
