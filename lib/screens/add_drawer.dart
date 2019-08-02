import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import 'orders_screen.dart';
import 'user_product_screen.dart';

class AddDrawer extends StatelessWidget {
  const AddDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Account'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('SHOP'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('MY ORDERS'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          Consumer<Auth>(
            builder: (ctx, auth, child) {
              if (!auth.isAdmin) {
                return Container();
              }
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('EDIT/ADD PRODUCTS'),
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(UserProductScreen.routeName);
                    },
                  ),
                  child
                ],
              );
            },
            child: Divider(),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('LOGOUT'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
