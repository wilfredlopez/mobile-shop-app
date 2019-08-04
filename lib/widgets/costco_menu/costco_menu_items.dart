import 'package:flutter/material.dart';
import 'package:letsshop/models/menu_category.dart';
import 'package:letsshop/providers/categories_provider.dart';

import 'package:letsshop/widgets/costco_menu/costco_menu_button.dart';
import 'package:provider/provider.dart';
import 'costco_button_link.dart';

class CostcoMenuItems extends StatefulWidget {
  CostcoMenuItems({Key key}) : super(key: key);

  _CostcoMenuItemsState createState() => _CostcoMenuItemsState();
}

class _CostcoMenuItemsState extends State<CostcoMenuItems> {
  //idea each category has their sub categories so we can map them.
  List<MenuCategory> cats = [];

  @override
  void initState() {
    Provider.of<CategoryProvider>(context, listen: false).getCats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cats = Provider.of<CategoryProvider>(context).cats;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop all'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: cats.length,
          itemBuilder: (context, index) {
            if (cats[index].children.length > 0) {
              return CostcoMenuButton(
                name: cats[index].name,
                children: cats[index].children,
              );
            } else {
              return CostcoButtonLink(
                name: cats[index].name,
                children: cats[index].children,
              );
            }
          },
        ),
      ),
    );
  }
}
