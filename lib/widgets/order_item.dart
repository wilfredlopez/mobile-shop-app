import 'package:flutter/material.dart';

import '../providers/orders.dart';
import 'package:intl/intl.dart';

import 'dart:math';

class OrderItems extends StatefulWidget {
  const OrderItems({@required this.order});

  final OrderItem order;

  @override
  _OrderItemsState createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: !_expanded
            ? 160
            : min(widget.order.products.length * 80.0 + 300, 300),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Order#  ${widget.order.id}',
                style: TextStyle(color: Colors.grey.shade800),
              ),
              ListTile(
                title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
                subtitle: Text(
                  DateFormat.yMd().format(widget.order.dateTime),
                ),
                trailing: IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                ),
              ),
              if (_expanded)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  height: !_expanded
                      ? 0
                      : min(widget.order.products.length * 10.0 + 50, 150),
                  child: ListView(
                    children: widget.order.products.map((p) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                p.title,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${p.qty}x \$${p.price}',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                          Divider()
                        ],
                      );
                    }).toList(),
                  ),
                ),
              // Text(
              //   'order#  ${widget.order.id}',
              //   style: TextStyle(color: Colors.grey),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
