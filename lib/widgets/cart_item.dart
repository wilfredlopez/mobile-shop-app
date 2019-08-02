import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItems extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int qty;
  final String title;

  CartItems({this.id, this.title, this.qty, this.price, this.productId});

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      confirmDismiss: (dismissDirection) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to remove the item?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      return Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text('Yes'),
                    onPressed: () {
                      return Navigator.of(context).pop(true);
                    },
                  )
                ],
              );
            });
      },
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cartData.removeItem(id);
      },
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor.withAlpha(189),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: ListTile(
            title: Text(title),
            subtitle: Text(
              'Total \$${(price * qty).toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text('$qty x'),
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: FittedBox(
                  child: Text('\$${price.toString()}'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
