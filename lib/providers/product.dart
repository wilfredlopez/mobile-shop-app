// import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String size;
  final String color;
  int inStock;
  final Map categories;
  bool isFavorite;

  Product({
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    @required this.id,
    this.isFavorite = false,
    @required this.size,
    @required this.color,
    @required this.inStock,
    @required this.categories,
  });

  bool get isAvailable {
    return inStock > 0;
  }

  void _setFavValue(newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  void toggleFavoriteStatus(String authToken, String userId) async {
    //old value just in case the request fail
    final oldStatus = isFavorite;
    _setFavValue(!isFavorite);
    try {
      await Firestore.instance
          .collection('favorites')
          .document('$userId')
          .collection('$userId')
          .document('$id')
          .setData({
        'productId': '$id',
        'isFavorite': isFavorite,
        'userId': '$userId',
      });
    } catch (e) {
      print('Error');
      print(e);
      _setFavValue(oldStatus);
    }
  }
}
