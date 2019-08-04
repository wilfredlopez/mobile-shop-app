import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/menu_category.dart';

class CategoryProvider with ChangeNotifier {
  static List<MenuCategory> _fakeCats = [
    // MenuCategory(name: 'Men', children: [
    //   MenuCategory(name: 'Cloathing', children: ['Pants']),
    //   'Underware'
    // ]),
    // MenuCategory(name: 'Tech', children: []),
    // MenuCategory(name: 'Kids', children: ['Accesories', 'Girls', 'Boys']),
  ];

  List<MenuCategory> get cats {
    return [..._fakeCats].toList();
  }

  Future<void> getCats() async {
    final document =
        await Firestore.instance.collection('MASTER_CATEGORIES').getDocuments();

    final categories = await document.documents.toList();
    List<MenuCategory> newCats = [];

    await categories.forEach((cat) {
      dynamic verifyChildren(dynamic children) {
        var newChildren = [];
        for (int i = 0; i < children.length; i++) {
          if (children[i] is Map) {
            newChildren.add(MenuCategory(
                name: children[i]['name'], children: children[i]['children']));
          } else {
            newChildren.add(children[i]);
          }
        }
        return newChildren;
      }

      void addWithString(Map<String, dynamic> data) {
        newCats.add(MenuCategory(
            name: data['name'], children: verifyChildren(data['children'])));
      }

      addWithString(cat.data);

      //working code but without combined children of type array of strings and array of MenuCategory
      // if (cat.data['children'][0] is Map) {
      //   newCats.add(MenuCategory(
      //       name: cat.data['children'][0]['name'],
      //       children: cat.data['children'][0]['children']));
      // } else {
      //   newCats.add(MenuCategory(
      //       name: cat.data['name'], children: cat.data['children']));
      // }

      _fakeCats = newCats;
    });
    notifyListeners();
    //HERE IM SUPPOSED TO GET THE CATEGORIES FROM THE SERVER IN THE ABOVE FORMAT.
    //EACH ONE IS AN ARRAY OF MenuCategory THAT IS CONFORMED OF A NAME AND A CHILDREN ARRAY.
    //THE CHILDREN ARRAY IS AN ARRAY OF STRINGS OR IS AN ARRAY OF MenuCategory

    // _fakeCats.forEach((cat) {
    //   cats.add(cat);
    // });
  }
}
