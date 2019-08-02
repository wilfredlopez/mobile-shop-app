import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import 'product_item.dart';

class ProductGridView extends StatelessWidget {
  final bool showOnlyFavorites;
  final int pageIndex;

  ProductGridView({this.showOnlyFavorites = false, @required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);

    var loadedProducts = showOnlyFavorites
        ? productData.favoriteItems.sublist(0, 4)
        : productData.items.sublist(0, 4);

    switch (pageIndex) {
      case 0:
        loadedProducts = showOnlyFavorites
            ? productData.favoriteItems.sublist(0, 4)
            : productData.items.sublist(0, 4);
        break;
      case 1:
        loadedProducts = productData.getCategoryItems('Tech');
        break;
      case 2:
        loadedProducts = productData.getCategoryItems('Men');
        break;
      default:
    }

    return GridView.builder(
      padding: const EdgeInsets.only(top: 15.0, left: 8, right: 8),
      itemCount: loadedProducts.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: loadedProducts[i], child: ProductItem()),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
      ),
    );
  }
}
