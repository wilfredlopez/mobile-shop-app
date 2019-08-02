import 'package:flutter/material.dart';

import 'package:letsshop/screens/category_screen_New.dart';

class CostcoButtonLink extends StatelessWidget {
  final String name;
  final List<dynamic> children;
  CostcoButtonLink({Key key, this.name, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
          // color: Colors.black12,
          // border: Border.all(color: Colors.black),
          // border: Border(bottom: BorderSide(color: Colors.grey)),
          ),
      height: 70,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          FlatButton(
            child: Row(
              children: <Widget>[
                Text(name),
                Expanded(
                  child: Text(''),
                ),
                Icon(
                  Icons.shop,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            onPressed: () {
              // Navigator.of(context).pushReplacementNamed(
              //     CategoryScreen.routeName,
              //     arguments: name);
              Navigator.of(context).pushReplacementNamed(
                  CategoryScreenNew.routeName,
                  arguments: name);
            },
          ),
          Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
