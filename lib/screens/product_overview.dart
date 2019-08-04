import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:letsshop/widgets/MyButtonNavBar/my_button_navbar.dart';
import 'package:letsshop/widgets/carousel.dart';
import 'package:letsshop/widgets/customAppBar/customAppBar.dart';

import 'package:provider/provider.dart';

import '../widgets/costco_menu//costco_menu.dart';
import '../providers/cart.dart';
import '../providers/products_provider.dart';
import '../widgets/badge.dart';
import '../widgets/product-gridview.dart';
import 'add_drawer.dart';
import 'cart_screen.dart';

enum Categories { Home, Tech, Men }

enum FilterOptions { Favorites, All }

class ProductOverview extends StatefulWidget {
  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  bool _showOnlyFavorites = false;
  var _isInit = true;
  var isLoading = false;
  var _pageIndex = 0;
  var currentCat = Categories.Home;
  String title = 'New Arrivals';

  List<String> listOfImageUrls = [
    'https://assets.pcmag.com/media/images/491603-display.jpg',
    'https://www.solodev.com/core/fileparse.php/131/urlt/testimonial-slider_951x561.jpg',
    'https://www.c21stores.com/dw/image/v2/BCJS_PRD/on/demandware.static/-/Sites-MASTERCATALOG_C21_US/default/dw5d771251/images/hi-res/1614/1614-9810.001.zoom.2.jpg?sw=1200',
    'https://www.c21stores.com/dw/image/v2/BCJS_PRD/on/demandware.static/-/Sites-MASTERCATALOG_C21_US/default/dw0217c067/images/hi-res/8501/8501-1046.940.zoom.2.jpg?sw=1200'
  ];

  void setCategory() {
    switch (_pageIndex) {
      case 0:
        currentCat = Categories.Home;
        title = 'New Arribals';
        break;
      case 1:
        currentCat = Categories.Tech;
        title = 'Tech';
        break;
      case 2:
        currentCat = Categories.Men;
        title = 'Men';
        break;
      default:
    }
  }

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: Text('Wilfred'),
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
      body: SingleChildScrollView(
        child: Container(
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
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      if (currentCat == Categories.Home)
                        Carousel(listOfImageUrls),
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
      ),
      bottomNavigationBar: MyButtonNavBar(
        pageIndex: _pageIndex,
        onChange: (value) {
          setState(() {
            _pageIndex = value;
            setCategory();
          });
        },
      ),
    );
  }
}
