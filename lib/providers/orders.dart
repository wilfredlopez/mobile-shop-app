// import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
//Custom
// import '../models/exception.dart';
import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class Order with ChangeNotifier {
  final authToken;
  String userId;

  final Firestore _db = Firestore.instance;

  List<OrderItem> _orders = [];

  Order(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders].reversed.toList();
  }

  Future<void> fetchOrders() async {
    try {
      var orderCollection = _db.collection('orders').document('byUserId');
      final document =
          await orderCollection.collection('$userId').getDocuments();

      var fetchedOrder = document.documents.toList();
      final List<OrderItem> ordersLoaded = [];

      fetchedOrder.forEach((body) {
        ordersLoaded.add(OrderItem(
            id: body['id'],
            amount: double.parse(body['amount']),
            dateTime: DateTime.parse(body['dateTime']),
            products: (body['products'] as List<dynamic>)
                .map((cp) => CartItem(
                      id: cp['id'],
                      title: cp['title'],
                      size: cp['size'],
                      color: cp['color'],
                      qty: int.parse(cp['qty']),
                      price: double.parse(cp['price']),
                    ))
                .toList()));

        _orders = ordersLoaded;
        notifyListeners();
      });
    } catch (e) {
      print('error');
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();
    final orderId = DateTime.now().toIso8601String();

    try {
      var orderCollection = _db.collection('orders').document('byUserId');
      await orderCollection.collection('$userId').document('$orderId').setData({
        "id": orderId,
        "amount": total.toString(),
        "dateTime": timestamp.toIso8601String(),
        "products": cartProducts
            .map((cp) => {
                  "id": cp.id,
                  "title": cp.title,
                  "qty": cp.qty.toString(),
                  "price": cp.price.toString()
                })
            .toList()
      });

      _orders.insert(
          0,
          OrderItem(
            id: orderId,
            amount: total,
            dateTime: timestamp,
            products: cartProducts,
          ));
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
