import 'package:flutter/material.dart';

import 'package:letsshop/widgets/customAppBar/customAppBar.dart';

import 'package:provider/provider.dart';

import '../widgets/costco_menu//costco_menu.dart';
import '../providers/cart.dart';
import '../providers/products_provider.dart';
import '../widgets/badge.dart';
import '../widgets/product-gridview.dart';
import 'add_drawer.dart';
import 'cart_screen.dart';
import '../widgets//MyButtonNavBar/my_button_navbar.dart';

enum Categories { Home, Tech, Men }

enum FilterOptions { Favorites, All }

class CategoryScreenNew extends StatefulWidget {
  static String routeName = './categorysreenNew';
  @override
  _CategoryScreenNewState createState() => _CategoryScreenNewState();
}

class _CategoryScreenNewState extends State<CategoryScreenNew> {
  bool _showOnlyFavorites = false;
  var _isInit = true;
  var isLoading = false;
  var pageIndex = 0;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context).fetchProductData().then((_) {
        setState(() {
          isLoading = false;
        });
      });
      _isInit = false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: Text('WilfredShop'),
        actions: <Widget>[
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
          ),
          PopupMenuButton(
            onSelected: (FilterOptions val) {
              setState(() {
                if (val == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
        centerTitle: true,
      ),
      drawer: AddDrawer(),
      body: Container(
        child: Stack(
          // fit: StackFit.loose,
          children: <Widget>[
            Positioned(
              top: 0,
              height: 80,
              right: 0,
              child: CostcoMenu(),
            ),
            SizedBox(
              height: 400,
            ),
            Container(
              margin: EdgeInsets.only(top: 80),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          categoryName,
                          style: Theme.of(context).textTheme.display1,
                        ),
                      ),
                    ]),
                    Container(
                      height: 600,
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                semanticsLabel: 'Loading',
                              ),
                            )
                          : ProductGridView(
                              showOnlyFavorites: _showOnlyFavorites,
                              pageIndex: pageIndex,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: new MyButtonNavBar(
        pageIndex: pageIndex,
        onChange: (value) {
          setState(() {
            pageIndex = value;
            //TOODO
          });
        },
      ),
    );
  }
}
