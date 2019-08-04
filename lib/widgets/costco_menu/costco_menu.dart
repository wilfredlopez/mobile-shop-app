import 'package:flutter/material.dart';
import './costco_menu_items.dart';

class CostcoMenu extends StatefulWidget {
  CostcoMenu({Key key}) : super(key: key);

  _CostcoMenuState createState() => _CostcoMenuState();
}

class _CostcoMenuState extends State<CostcoMenu> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      borderOnForeground: true,
      margin: EdgeInsets.all(0),
      child: Container(
          // color: Colors.white70,
          alignment: Alignment.center,
          // height: 30,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton.icon(
                    icon: Icon(Icons.menu),
                    label: Text(
                      "Shop",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CostcoMenuItems()),
                      );
                    },
                  ),
                  Container(
                    color: Colors.black12,
                    padding: EdgeInsets.only(left: 7, right: 7),
                    margin: EdgeInsets.only(top: 0, bottom: 0),
                    // width: 310,
                    width: MediaQuery.of(context).size.width * .6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Search'),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.search,
                            ),
                            onPressed: () {
                              //TODO
                              //add search functionality
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
