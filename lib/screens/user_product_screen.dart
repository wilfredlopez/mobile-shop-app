import 'package:flutter/material.dart';

import '../widgets/user_product_item.dart';
import 'add_drawer.dart';
import 'edit_product_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = './user-products';

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context);

    // Future<void> _callFetchProducts(BuildContext context) async {
    //   await Provider.of<Products>(context, listen: false)
    //       .fetchProductData(true);
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AddDrawer(),
      body: StreamBuilder(
        stream: Firestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'Loading',
              ),
            );
          return ListView.builder(
              // itemExtent: 80.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (_, i) {
                return Column(
                  children: <Widget>[
                    UserProductItem(
                      title: snapshot.data.documents[i]['title'],
                      imageUrl: snapshot.data.documents[i]['imageUrl'],
                      id: snapshot.data.documents[i]['id'],
                    ),
                    Divider(),
                  ],
                );
              });
        },
      ),
      // body: FutureBuilder(
      //     future: _callFetchProducts(context),
      //     builder: (ctx, snapShot) {
      //       return snapShot.connectionState == ConnectionState.waiting
      //           ? Center(
      //               child: CircularProgressIndicator(
      //                 semanticsLabel: 'Loading',
      //               ),
      //             )
      //           : RefreshIndicator(
      //               onRefresh: () {
      //                 return _callFetchProducts(context);
      //               },
      //               child: Consumer<Products>(
      //                 builder: (ctx, productData, _) => Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: ListView.builder(
      //                       itemCount: productData.items.length,
      //                       itemBuilder: (_, i) {
      //                         return Column(
      //                           children: <Widget>[
      //                             UserProductItem(
      //                               title: productData.items[i].title,
      //                               imageUrl: productData.items[i].imageUrl,
      //                               id: productData.items[i].id,
      //                             ),
      //                             Divider(),
      //                           ],
      //                         );
      //                       }),
      //                 ),
      //               ),
      //             );
      //     }),
    );
  }
}
