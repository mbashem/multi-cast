import 'package:flutter/material.dart';
import 'package:flutter_app/src/auth/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = true;

  AuthProvider() {
    _isLoggedIn = false;
    AuthService.getJWTToken().then((value) => {
          if (value != null) {login()}
        });
  }

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    AuthService.signOut();
    _isLoggedIn = false;
    notifyListeners();
  }
}
