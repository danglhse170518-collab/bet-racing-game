import 'dart:convert';
import 'package:flutter/services.dart';
import 'interfaces/i_login.dart';

class LoginImpl implements ILogin {
  @override
  Future<bool> login(String username, String password) async {
    try {
      final String response = await rootBundle.loadString('assets/data/user.json');
      final List<dynamic> users = jsonDecode(response);

      return users.any((user) =>
      user['username'] == username.trim() &&
          user['password'] == password.trim());
    } catch (_) {
      return false;
    }
  }
}