import 'package:flutter/foundation.dart';

import '../models/menu_category.dart';

class CategoryProvider with ChangeNotifier {
  static List<MenuCategory> _fakeCats = [
    MenuCategory(name: 'Men', children: [
      MenuCategory(name: 'Cloathing', children: ['Pants']),
      'Underware'
    ]),
    MenuCategory(name: 'Tech', children: []),
    MenuCategory(name: 'Kids', children: ['Accesories', 'Girls', 'Boys']),
  ];

  List<MenuCategory> get cats {
    return [..._fakeCats].toList();
  }

  getCats() {
    //HERE IM SUPPOSED TO GET THE CATEGORIES FROM THE SERVER IN THE ABOVE FORMAT.
    //EACH ONE IS AN ARRAY OF MenuCategory THAT IS CONFORMED OF A NAME AND A CHILDREN ARRAY.
    //THE CHILDREN ARRAY IS AN ARRAY OF STRINGS OR IS AN ARRAY OF MenuCategory

    // _fakeCats.forEach((cat) {
    //   cats.add(cat);
    // });
  }
}
