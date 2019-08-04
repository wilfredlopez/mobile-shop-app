import 'package:flutter/material.dart';

class MenuCategory {
  String name;
  List<dynamic> children;
  MenuCategory({@required this.name, this.children});
}

//EACH MenuCategory IS CONFORMED OF A NAME AND A CHILDREN ARRAY.
//THE CHILDREN ARRAY IS AN ARRAY OF STRINGS OR IS AN ARRAY OF MenuCategory
