import 'package:flutter/material.dart';

class CartItem {
  String id;

  String title;
  int qty;
  double price;
  String size;
  String color;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.qty,
    @required this.price,
    this.size,
    this.color,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items != null ? _items.length : 0;
  }

  double get totalAmount {
    var total = 0.0;

    _items.forEach((key, item) {
      total += item.price * item.qty;
    });

    return total;
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }

    if (_items[id].qty > 1) {
      _items.update(id, (existing) {
        return CartItem(
          id: existing.id,
          title: existing.title,
          qty: existing.qty - 1,
          price: existing.price,
        );
      });
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void addItem(CartItem item) {
    if (_items.containsKey(item.id)) {
      //..change qty
      _items.update(item.id, (existingItem) {
        return CartItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          qty: existingItem.qty + 1,
        );
      });
    } else {
      _items.putIfAbsent(item.id, () => item);
    }

    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
