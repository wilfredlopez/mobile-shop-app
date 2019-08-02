// import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// import 'package:http/http.dart' as http;
// import '../models/exception.dart';
import './product.dart';

enum UpdateAction { Increase, Decrease }

class Products with ChangeNotifier {
  final String authToken;
  final String userId;

  final Firestore _db = Firestore.instance;

  List<Product> _items = [];

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items.where((p) => p.inStock > 0)];
  }

  Future<void> decreaseQty(String id) async {
    return changeQty(id: id, action: UpdateAction.Decrease);
  }

  Future<void> increaseQty(String id) {
    return changeQty(id: id, action: UpdateAction.Increase);
  }

  Future<void> changeQty({String id, UpdateAction action}) async {
    final prodIndex = _items.indexWhere((p) => p.id == id);
    final existingqty = _items[prodIndex].inStock;
    var newQty;

    if (action == UpdateAction.Decrease) {
      newQty = existingqty - 1;
    } else if (action == UpdateAction.Increase) {
      newQty = existingqty + 1;
    }

    _items[prodIndex].inStock = newQty;
    notifyListeners();
    try {
      final dbProduct = await _db.collection('products').getDocuments();
      final prodRef = dbProduct.documents.firstWhere((doc) => doc['id'] == id);
      prodRef.reference..updateData({'inStock': newQty.toString()});
      notifyListeners();
    } catch (e) {
      print(e);
      _items[prodIndex].inStock = existingqty;
      notifyListeners();
      throw e;
    }
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  List<Product> getCategoryItems(String category) {
    List<Product> catItems = [];

    _items.forEach((product) {
      if (product.categories != null) {
        if (product.categories.containsKey(category)) {
          return catItems.add(product);
        }
      }
    });

    return catItems == null ? [] : catItems.toList();
  }

  Future<void> fetchProductData([bool filterByCreator = false]) async {
    try {
      var favoriteSnap = await _db
          .collection('favorites')
          .document('$userId')
          .collection('$userId')
          .getDocuments();
      var favDocs = favoriteSnap.documents
          .where((doc) =>
              doc.data['userId'] == userId && doc.data['isFavorite'] == true)
          .toList();

      List<String> favoriteData = [];
      favDocs.forEach((fav) {
        favoriteData.add(fav.data['productId']);
      });
      var snap = await _db.collection('products').getDocuments();
      final docs = snap.documents.toList();
      final List<Product> loadedProducts = [];

      docs.forEach((doc) {
        return loadedProducts.add(Product(
          id: doc['id'],
          title: doc['title'],
          description: doc['description'],
          imageUrl: doc['imageUrl'],
          price: double.parse(doc['price']),
          isFavorite: favoriteData.contains(doc['id']),
          color: doc['color'],
          size: doc['size'],
          inStock: int.parse(doc['inStock']),
          categories: doc['categories'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      print('error with fetch');
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await _db.collection('products').add({
        "id": product.id,
        "imageUrl": product.imageUrl,
        "title": product.title,
        "description": product.description,
        "price": product.price.toString(),
        "creatorId": userId,
        'color': product.color,
        'size': product.size,
        'inStock': product.inStock.toString(),
        'categories': product.categories
      });

      final newProduct = Product(
          id: product.id,
          imageUrl: product.imageUrl,
          title: product.title,
          description: product.description,
          price: product.price,
          size: product.size,
          color: product.color,
          inStock: product.inStock,
          categories: product.categories);

      _items.add(newProduct);
      // _items.insert(0, newProduct); //to add at the beginging
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> editProduct(String id, Product product) async {
    try {
      final dbProduct = await _db.collection('products').getDocuments();

      final prodRef = dbProduct.documents.firstWhere((doc) => doc['id'] == id);

      prodRef.reference.updateData({
        "imageUrl": product.imageUrl,
        "title": product.title,
        "description": product.description,
        "price": product.price.toString(),
        'isFavorite': product.isFavorite,
        'color': product.color,
        'size': product.size,
        'inStock': product.inStock.toString(),
        'categories': product.categories
      });

      final pIndex = _items.indexWhere((item) => item.id == id);
      if (pIndex >= 0) {
        _items[pIndex] = product;
      }

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> deleteProduct(String id) async {
    final prodIndex = _items.indexWhere((p) => p.id == id);
    final existingProduct = _items[prodIndex];
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
    try {
      final dbProduct = await _db.collection('products').getDocuments();
      final prodRef = dbProduct.documents.firstWhere((doc) => doc['id'] == id);
      prodRef.reference.delete();
      notifyListeners();
    } catch (e) {
      print(e);
      _items.insert(prodIndex, existingProduct);
      notifyListeners();
      throw e;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((p) => p.id == id);
  }
}

//GOOD OLD CODE

// class Products with ChangeNotifier {
//   final String authToken;
//   final String userId;
//   List<Product> _items = [
//     // Product(
//     //   id: 'p1',
//     //   title: 'Red Shirt',
//     //   description: 'A red shirt - it is pretty red!',
//     //   price: 29.99,
//     //   imageUrl:
//     //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//     // ),
//     // Product(
//     //   id: 'p2',
//     //   title: 'Trousers',
//     //   description: 'A nice pair of trousers.',
//     //   price: 59.99,
//     //   imageUrl:
//     //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//     // ),
//     // Product(
//     //   id: 'p3',
//     //   title: 'Yellow Scarf',
//     //   description: 'Warm and cozy - exactly what you need for the winter.',
//     //   price: 19.99,
//     //   imageUrl:
//     //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//     // ),
//     // Product(
//     //   id: 'p4',
//     //   title: 'A Pan',
//     //   description: 'Prepare any meal you want.',
//     //   price: 49.99,
//     //   imageUrl:
//     //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//     // ),
//   ];

//   Products(this.authToken, this.userId, this._items);

//   List<Product> get items {
//     return [..._items];
//   }

//   List<Product> get favoriteItems {
//     return _items.where((product) => product.isFavorite).toList();
//   }

//   Future<void> fetchProductData([bool filterByCreator = false]) async {
//     String filterString;
//     filterByCreator
//         ? filterString = 'orderBy="creatorId"&equalTo="$userId"'
//         : filterString = '';

//     final url =
//         'https://shopmobileapp-6d6f8.firebaseio.com/products.json?auth=$authToken&$filterString';
//     try {
//       final response = await http.get(url);
//       final resBody = json.decode(response.body) as Map<String, dynamic>;

//       final favsUrl =
//           "https://shopmobileapp-6d6f8.firebaseio.com/favorites/$userId.json?auth=$authToken";

//       final favoriteResponse = await http.get(favsUrl);

//       final favoriteData = json.decode(favoriteResponse.body);

//       final List<Product> loadedProducts = [];
//       resBody.forEach((prodId, body) {
//         loadedProducts.add(Product(
//           id: prodId,
//           title: body['title'],
//           description: body['description'],
//           imageUrl: body['imageUrl'],
//           price: body['price'],
//           isFavorite:
//               favoriteData == null ? false : favoriteData[prodId] ?? false,
//         ));

//         _items = loadedProducts;
//         notifyListeners();
//       });
//     } catch (e) {
//       print('error with fetch');
//     }
//   }

//   Future<void> addProduct(Product product) async {
//     final url =
//         "https://shopmobileapp-6d6f8.firebaseio.com/products.json?auth=$authToken";
//     try {
//       final response = await http.post(url,
//           // headers: {'Authentication': 'Bearer asdasdasdsadasdasdasdsd'}, //if necesary
//           body: json.encode({
//             "imageUrl": product.imageUrl,
//             "title": product.title,
//             "description": product.description,
//             "price": product.price,
//             "creatorId": userId,
//           }));

//       final newProduct = Product(
//         id: json.decode(response.body)['name'],
//         imageUrl: product.imageUrl,
//         title: product.title,
//         description: product.description,
//         price: product.price,
//       );

//       _items.add(newProduct);
//       // _items.insert(0, newProduct); //to add at the beginging
//       notifyListeners();
//     } catch (err) {
//       print(err);
//       throw err;
//     }
//   }

//   Future<void> editProduct(String id, Product product) async {
//     try {
//       final productUrl =
//           "https://shopmobileapp-6d6f8.firebaseio.com/products/$id.json?auth=$authToken";
//       await http.patch(productUrl,
//           body: json.encode({
//             "imageUrl": product.imageUrl,
//             "title": product.title,
//             "description": product.description,
//             "price": product.price,
//             'isFavorite': product.isFavorite,
//           }));

//       final pIndex = _items.indexWhere((item) => item.id == id);
//       if (pIndex >= 0) {
//         _items[pIndex] = product;
//       }

//       notifyListeners();
//     } catch (e) {
//       print(e);
//       throw e;
//     }
//   }

//   Future<void> deleteProduct(String id) async {
//     final productUrl =
//         "https://shopmobileapp-6d6f8.firebaseio.com/products/$id.json?auth=$authToken";

//     final prodIndex = _items.indexWhere((p) => p.id == id);
//     final existingProduct = _items[prodIndex];

//     _items.removeWhere((item) => item.id == id);
//     notifyListeners();
//     try {
//       final res = await http.delete(productUrl);

//       if (res.statusCode >= 400) {
//         throw HttpException('Could not delete');
//       }
//       notifyListeners();
//     } catch (e) {
//       print(e);
//       _items.insert(prodIndex, existingProduct);
//       notifyListeners();
//       throw e;
//     }

//     // await http.delete(productUrl).then((res) {
//     //   if (res.statusCode >= 400) {
//     //     throw HttpException('Could not delete');
//     //   }
//     //   notifyListeners();
//     // }).catchError((err) {
//     //   print(err);
//     //   _items.insert(prodIndex, existingProduct);
//     //   notifyListeners();
//     // });
//   }

//   Product findById(String id) {
//     return _items.firstWhere((p) => p.id == id);
//   }
// }
