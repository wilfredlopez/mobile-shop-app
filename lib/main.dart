import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letsshop/providers/categories_provider.dart';
import 'package:letsshop/screens/category_screen.dart';
import 'package:letsshop/screens/category_screen_New.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'providers/products_provider.dart';
import 'screens/auth_screen.dart.dart';
import 'screens/cart_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/product_detail.dart';
import 'screens/product_overview.dart';
import 'screens/splash_screen.dart';
import 'screens/user_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          builder: (ctx, auth, prevProducts) => Products(auth.token,
              auth.userId, prevProducts == null ? [] : prevProducts.items),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: CategoryProvider(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          builder: (ctx, auth, prevOrder) => Order(auth.token, auth.userId,
              prevOrder == null ? [] : prevOrder.orders),
        ),
        // ChangeNotifierProvider.value(
        //   value: Order(),
        // ),
      ],
      child: Consumer<Auth>(
          builder: (ctx, auth, child) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Wilfred',
                theme: ThemeData(
                    pageTransitionsTheme: PageTransitionsTheme(builders: {
                      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                      TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
                    }),
                    fontFamily: 'Lato',
                    primarySwatch: Colors.red,
                    accentColor: Colors.deepOrange,
                    textTheme: Theme.of(context).textTheme.copyWith(
                        title: TextStyle(color: Colors.white),
                        display1: TextStyle(color: Colors.black))),

                // home: ProductOverview(),
                home: auth.isAuth
                    ? ProductOverview()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, authSnapshot) =>
                            authSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? SplashScreen()
                                : AuthScreen(),
                      ),
                routes: {
                  ProductDetail.routeName: (ctx) => ProductDetail(),
                  CartScreen.routeName: (ctx) => CartScreen(),
                  OrdersScreen.routeName: (ctx) => OrdersScreen(),
                  UserProductScreen.routeName: (ctx) => UserProductScreen(),
                  EditProductScreen.routeName: (_) => EditProductScreen(),
                  CategoryScreen.routeName: (_) => CategoryScreen(),
                  CategoryScreenNew.routeName: (_) => CategoryScreenNew(),
                },
              )),
    );
  }
}
