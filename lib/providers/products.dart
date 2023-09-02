import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];
  final String authToken;
  final String userId;

  Products(this.authToken, this.userId);

  List<Product> get products {
    return _products;
  }

  List<Product> get favouriteProducts {
    List<Product> fav =
        _products.where((element) => element.isFavourite).toList();
    return fav;
  }

  Product getProduct(String id) =>
      _products.firstWhere((element) => element.id == id);

  Future<void> fetchAndSetProducts({bool filterById = false}) async {
    String filterString =
        filterById ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    String url =
        'https://shop-7d800-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken&$filterString';

    try {
      var response = await http.get(Uri.parse(url));
      final Map<String, dynamic> data =
          Map.castFrom(json.decode(response.body));

      if (data.isEmpty) return;

      url =
          'https://shop-7d800-default-rtdb.europe-west1.firebasedatabase.app/userFavourites/$userId.json?auth=$authToken';
      final favouriteResponse = await http.get(Uri.parse(url));
      final favData = json.decode(favouriteResponse.body);
      final List<Product> retrievedProducts = [];
      data.forEach((key, value) {
        retrievedProducts.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavourite: favData == null ? false : favData[key] ?? false));
      });
      _products = retrievedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addProduct(Product product) async {
    String url =
        'https://shop-7d800-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId
          }));
      final data = json.decode(response.body);
      final newProduct = Product(
          id: data['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _products.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _products.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      String url =
          'https://shop-7d800-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken';

      try {
        await http.patch(Uri.parse(url),
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl,
            }));

        _products[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    String url =
        'https://shop-7d800-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken';
    try {
      final index = _products.indexWhere((element) => element.id == id);

      var response = await http.delete(Uri.parse(url));
      if (response.statusCode < 400) {
        print(response.statusCode);
        _products.removeAt(index);
        notifyListeners();
      } else {
        throw HttpException(json.decode(response.body)['error']['message']);
      }
    } catch (e) {
      rethrow;
    }
  }
}
