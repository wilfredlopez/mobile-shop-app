import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/order_item.dart';
import 'add_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AddDrawer(),
      body: FutureBuilder(
        future: Provider.of<Order>(context, listen: false).fetchOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              semanticsLabel: 'Loading',
            ));
          } else if (dataSnapshot.error != null) {
            return Center(
              child: Column(
                children: <Widget>[
                  Text(
                    'An error occured, please try again.',
                    style: TextStyle(color: Colors.red, height: 10),
                  ),
                  IconButton(
                    icon: Icon(Icons.restore),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(routeName);
                    },
                  )
                ],
              ),
            );
          } else {
            return Consumer<Order>(
              builder: (ctx, orderProvider, child) {
                return RefreshIndicator(
                  onRefresh: () {
                    return Provider.of<Order>(context, listen: false)
                        .fetchOrders();
                  },
                  child: ListView.builder(
                    itemCount: orderProvider.orders.length,
                    itemBuilder: (ctx, i) => OrderItems(
                      order: orderProvider.orders[i],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
