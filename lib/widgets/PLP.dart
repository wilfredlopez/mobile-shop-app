import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import 'product_item.dart';

class PLP extends StatelessWidget {
  // final bool showOnlyFavorites;
  final String categoryName;

  PLP({@required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    var loadedProducts = productData.getCategoryItems(categoryName);

    return Column(
      children: <Widget>[
        Text(
          categoryName.toUpperCase(),
          style: Theme.of(context).textTheme.display1,
        ),
        Divider(),
        Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: GridView.builder(
            padding: const EdgeInsets.only(top: 15.0, left: 8, right: 8),
            itemCount: loadedProducts.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                value: loadedProducts[i], child: ProductItem()),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          ),
        ),
      ],
    );
  }
}
