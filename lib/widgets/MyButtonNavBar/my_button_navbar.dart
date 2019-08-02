import 'package:flutter/material.dart';

class MyButtonNavBar extends StatelessWidget {
  const MyButtonNavBar({
    Key key,
    @required this.pageIndex,
    @required this.onChange,
  }) : super(key: key);

  final Function onChange;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      iconSize: 25,
      elevation: 20,
      currentIndex: pageIndex,
      fixedColor: Colors.black,
      type: BottomNavigationBarType.shifting,
      unselectedItemColor: Colors.black,
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.shop,
              color: Colors.red,
            ),
            title: Text('Shop')),
        BottomNavigationBarItem(
            icon: Icon(Icons.computer), title: Text('Tech')),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.money_off,
              color: Colors.green,
            ),
            title: Text('Specials')),
        BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz), title: Text('More')),
      ],
      onTap: onChange,
    );
  }
}
