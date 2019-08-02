import 'package:flutter/material.dart';
import 'package:letsshop/models/menu_category.dart';
import './costco_button_link.dart';

class CostcoMenuButton extends StatelessWidget {
  final String name;
  final List<dynamic> children;
  CostcoMenuButton({Key key, this.name, this.children}) : super(key: key);

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
                Icon(Icons.navigate_next),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Category(
                          name: name,
                          children: children,
                        )),
              );
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

class Category extends StatelessWidget {
  final String name;
  final List<dynamic> children;
  Category({Key key, @required this.name, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name.toUpperCase()),
        actions: <Widget>[
          FlatButton(
            child: Icon(
              Icons.cancel,
              color: Colors.white,
            ),
            onPressed: () {
              //TODO => function to take me to the category page
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: children.length,
        itemBuilder: (context, index) {
          return children[index].runtimeType == String
              ? CostcoButtonLink(
                  name: children[index],
                  children: [],
                )
              : CostcoMenuButton(
                  children: children[index].children,
                  name: children[index].name,
                );
        },
      ),
    );
  }
}
