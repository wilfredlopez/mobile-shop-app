import 'package:flutter/material.dart';
import 'package:letsshop/widgets/customAppBar/customAppBar.dart';

import 'package:provider/provider.dart';

import '../widgets/costco_menu//costco_menu.dart';
import '../providers/cart.dart';
import '../providers/products_provider.dart';
import '../widgets/badge.dart';
import '../widgets/product-gridview.dart';
import '../screens/add_drawer.dart';
import '../screens/cart_screen.dart';

enum Categories { Home, Tech, Men }

enum FilterOptions { Favorites, All }

class PDPNew extends StatefulWidget {
  final String categoryName;
  PDPNew({@required this.categoryName});

  @override
  _PDPNewState createState() => _PDPNewState();
}

class _PDPNewState extends State<PDPNew> {
  bool _showOnlyFavorites = false;
  var _isInit = true;
  var isLoading = false;
  var _pageIndex = 0;
  String title = 'New Arrivals';

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

    Provider.of<Products>(context).getCategoryItems(widget.categoryName);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: Text('ShopClass'),
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
                          title,
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
                              pageIndex: _pageIndex,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.shop), title: Text('Shop')),
          BottomNavigationBarItem(
              icon: Icon(Icons.computer), title: Text('Tech')),
          BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz), title: Text('More')),
        ],
        onTap: (value) {
          setState(() {
            _pageIndex = value;
            //TODO
          });
        },
      ),
    );
  }
}
