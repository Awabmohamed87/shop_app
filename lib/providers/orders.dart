import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> items;
  final DateTime date;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.items,
      required this.date});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String? authToken;
  String? userId;

  Orders({required this.authToken, required this.userId});

  getData(String id, String token, List<OrderItem> orders) {
    userId = id;
    authToken = token;
    _orders = orders;
    notifyListeners();
  }

  List<OrderItem> get orders {
    return _orders;
  }

  addToOrder(OrderItem order) {
    _orders.add(order);
  }

  Future<void> fetchAndSetOrders() async {
    String url =
        'https://shop-7d800-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken';

    try {
      var response = await http.get(Uri.parse(url));
      final Map<String, dynamic> data =
          Map.castFrom(json.decode(response.body));
      if (data.isEmpty) return;

      final List<OrderItem> retrievedOrders = [];
      data.forEach((key, value) {
        retrievedOrders.add(OrderItem(
            id: key,
            amount: value['amount'],
            date: DateTime.parse(value['date']),
            items: (value['products'] as List<dynamic>)
                .map((e) => CartItem(
                    id: e['id'],
                    title: e['title'],
                    quantity: e['quantity'],
                    price: e['price']))
                .toList()));
      });
      _orders = retrievedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  addOrder(List<CartItem> cart, double total) async {
    String url =
        'https://shop-7d800-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': total,
            'date': DateTime.now().toIso8601String(),
            'products': cart
                .map((e) => {
                      'id': e.id,
                      'price': e.price,
                      'quantity': e.quantity,
                      'title': e.title
                    })
                .toList()
          }));

      _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              amount: total,
              items: cart,
              date: DateTime.now()));
      notifyListeners();
    } catch (e) {}
  }
}
