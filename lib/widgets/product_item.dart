import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final p = Provider.of<Product>(context, listen: false);
    final cartContainer = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: Container(
          margin: EdgeInsets.only(bottom: 48),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ProductDetail.routeName, arguments: p.id);
            },
            child: Hero(
              tag: p.id,
              child: FadeInImage(
                placeholder: AssetImage('./assets/images/placeholder.png'),
                image: NetworkImage(p.imageUrl),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        footer: Consumer<Product>(
          builder: (ctx, p, _) {
            return GridTileBar(
              leading: IconButton(
                  icon: p.isFavorite
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_border),
                  onPressed: () {
                    final authData = Provider.of<Auth>(context, listen: false);
                    p.toggleFavoriteStatus(authData.token, authData.userId);
                  },
                  color: Theme.of(context).accentColor),
              trailing: IconButton(
                icon: Icon(Icons.add),
                color: Theme.of(context).primaryTextTheme.title.color,
                onPressed: () {
                  cartContainer.addItem(CartItem(
                      id: p.id, price: p.price, qty: 1, title: p.title));

                  Scaffold.of(context).removeCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text('Item added to Cart'),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cartContainer.removeSingleItem(p.id);
                        },
                      ),
                    ),
                  );
                },
              ),
              backgroundColor: Colors.black87,
              title: Text(
                p.title,
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }
}
