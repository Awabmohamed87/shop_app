import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate == null) return null;
    if (_token != null && _expiryDate!.isAfter(DateTime.now())) return _token!;
    return null;
  }

  String get userId {
    return _userId!;
  }

  _authinticate(String email, String password, String urlSegment) async {
    print(email);
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCm3DAxkTgt64OtMhRnGAtBftipAEDcpEI';
    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(res.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _tryAutoLogOut();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      String userData = json.encode({
        'token': _token!,
        '_userId': _userId!,
        'expiryDate': _expiryDate!.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  signup(String email, String password) {
    return _authinticate(email, password, 'signUp');
  }

  login(String email, String password) {
    return _authinticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userData') == null) return false;
    final Map<String, Object> userData =
        Map.castFrom(json.decode(prefs.getString('userData')!));
    if (userData.containsKey('token')) {
      _token = userData['token'].toString();
      _userId = userData['_userId'].toString();
      _expiryDate = DateTime.parse(userData['expiryDate'].toString());
      if (_expiryDate!.isBefore(DateTime.now())) return false;

      notifyListeners();

      _tryAutoLogOut();

      return true;
    }
    return false;
  }

  logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) _authTimer!.cancel();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  _tryAutoLogOut() {
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    _authTimer = Timer(
        Duration(seconds: _expiryDate!.difference(DateTime.now()).inSeconds),
        logout);
  }
}
