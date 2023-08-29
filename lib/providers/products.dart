import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _products = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  String? authToken;
  String? userId;

  List<Product> get products {
    return _products;
  }

  List<Product> get favouriteProducts {
    List<Product> fav =
        _products.where((element) => element.isFavourite).toList();
    return fav;
  }

  Product getProduct(id) => _products.firstWhere((element) => element.id == id);

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
      rethrow;
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
        _products.removeAt(index);
        notifyListeners();
      } else {
        throw HttpException(json.decode(response.body)['error']['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  getData(String token, String uid, List<Product> products) {
    authToken = token;
    userId = uid;
    _products = products;
    notifyListeners();
  }
}
