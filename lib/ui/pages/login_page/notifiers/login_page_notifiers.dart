import 'package:flutter/material.dart';
import 'package:tw_mobile/services/api_client.dart';

class LoginPageNotifier with ChangeNotifier {
  bool _validEmail = true;
  bool get validEmail => _validEmail;
  bool _validPassword = true;
  bool get validPassword => _validPassword;
  int reqLength = 8;

  void checkEmail(String email) {
    if (email.isEmpty) {
      _validEmail = true;
    } else {
      _validEmail = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email);
    }
    notifyListeners();
  }

  void checkPassword(String password) {
    if (password.isEmpty) {
      _validPassword = true;
    } else {
      _validPassword = password.contains(RegExp(r'[!@#$%^&*]')) &&
          password.contains(RegExp(r'[A-Z]')) &&
          password.contains(RegExp(r'[a-z]')) &&
          password.contains(RegExp(r'[0-9]')) &&
          password.length >= reqLength;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    ApiClient apiClient = ApiClient();
    bool success = await apiClient.login(email, password);
    if (success) {
      return true;
    }
    return false;
  }
}
