import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
// import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

// import '../models/exception.dart';

import '../models/authMode.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  bool _isAdmin = false;

  bool get isAuth {
    return token != null;
  }

  bool get isAdmin {
    return _isAdmin == true;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, AuthMode.Signup);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, AuthMode.Login);
  }

  Future<void> _authenticate(
      String email, String password, AuthMode mode) async {
    try {
      FirebaseUser user;
      if (mode == AuthMode.Login) {
        user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } else {
        user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
      }

      final timeout = Duration(days: 1);

      final token =
          await user.getIdToken(refresh: false).timeout(Duration(days: 1));

      _userId = user.uid;
      _token = token;
      _expiryDate = DateTime.now().add(Duration(seconds: timeout.inSeconds));
      autoLogout();
      await _verifyIfAdmin();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String()
      });

      prefs.setString('userData', userData);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> _verifyIfAdmin() async {
    var adminsCollection =
        await Firestore.instance.collection('admins').getDocuments();

    var snapshot =
        adminsCollection.documents.where((doc) => doc.documentID == userId);

    var isAdmin = snapshot.isNotEmpty;
    _isAdmin = isAdmin;
    notifyListeners();

    return isAdmin;
  }

  Future<void> logout() async {
    _userId = null;
    _expiryDate = null;
    _token = null;
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('userData')) {
      prefs.remove('userData');
      // prefs.clear(); //THIS WOUDL REMOVE ALL DATA
    }

    notifyListeners();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    var timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData'));

    final expiresIn = DateTime.parse(extractedUserData['expiryDate']);
    if (expiresIn.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'].toString();
    _userId = extractedUserData['userId'];
    _expiryDate = expiresIn;
    _isAdmin = await _verifyIfAdmin();

    notifyListeners();
    autoLogout();

    return true;
  }
} //end class Auth

//OLD GOOD CODE WITH FIRESTORE REALTIME DATABASE

// class Auth with ChangeNotifier {
//   String _token;
//   DateTime _expiryDate;
//   String _userId;
//   Timer _authTimer;

//   bool get isAuth {
//     return token != null;
//   }

//   String get token {
//     if (_expiryDate != null &&
//         _expiryDate.isAfter(DateTime.now()) &&
//         _token != null) {
//       return _token;
//     }
//     return null;
//   }

//   String get userId {
//     return _userId;
//   }

//   Future<void> signup(String email, String password) async {
//     return _authenticate(email, password, 'signupNewUser');
//   }

//   Future<void> login(String email, String password) async {
//     return _authenticate(email, password, 'verifyPassword');
//   }

//   Future<void> _authenticate(
//       String email, String password, String urlPath) async {
//     final url =
//         "https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlPath?key=AIzaSyAU96Uh_5fWvJUPAFslk8kuDny_J1XKaEU";

//     try {
//       final response = await http.post(
//         url,
//         body: json.encode({
//           "email": email,
//           "password": password,
//           'returnSecureToken': true,
//         }),
//       );
//       final responseBody = json.decode(response.body);

//       if (responseBody['error'] != null) {
//         throw HttpException(responseBody['error']['message']);
//       }

//       _userId = responseBody['localId'];
//       _token = responseBody['idToken'];
//       _expiryDate = DateTime.now()
//           .add(Duration(seconds: int.parse(responseBody['expiresIn'])));
//       autoLogout();

//       notifyListeners();

//       final prefs = await SharedPreferences.getInstance();
//       final userData = json.encode({
//         'token': _token,
//         'userId': _userId,
//         'expiryDate': _expiryDate.toIso8601String()
//       });

//       prefs.setString('userData', userData);
//     } catch (e) {
//       print(e);
//       throw e;
//     }
//   }

//   Future<void> logout() async {
//     _userId = null;
//     _expiryDate = null;
//     _token = null;
//     if (_authTimer != null) {
//       _authTimer.cancel();
//     }

//     final prefs = await SharedPreferences.getInstance();

//     if (prefs.containsKey('userData')) {
//       prefs.remove('userData');
//       // prefs.clear(); //THIS WOUDL REMOVE ALL DATA
//     }

//     notifyListeners();
//   }

//   void autoLogout() {
//     if (_authTimer != null) {
//       _authTimer.cancel();
//     }
//     var timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
//     _authTimer = Timer(Duration(seconds: timeToExpire), logout);
//   }

//   Future<bool> tryAutoLogin() async {
//     final prefs = await SharedPreferences.getInstance();

//     if (!prefs.containsKey('userData')) {
//       return false;
//     }
//     final extractedUserData = json.decode(prefs.getString('userData'));

//     final expiresIn = DateTime.parse(extractedUserData['expiryDate']);
//     if (expiresIn.isBefore(DateTime.now())) {
//       return false;
//     }

//     _token = extractedUserData['token'].toString();
//     _userId = extractedUserData['userId'];
//     _expiryDate = expiresIn;

//     notifyListeners();
//     autoLogout();

//     return true;
//   }
// } //end class Auth
