import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavourite = false});
  void _setFavValue(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  toggleFavouriteStatus(String token, String userId) async {
    bool oldStatus = isFavourite;
    isFavourite = !isFavourite;
    print(isFavourite);
    notifyListeners();
    final url =
        'https://shop-7d800-default-rtdb.europe-west1.firebasedatabase.app/userFavourites/$userId/$id.json?auth=$token';
    try {
      var response =
          await http.put(Uri.parse(url), body: json.encode(isFavourite));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
