import 'package:flutter/material.dart';

class ResetPasswordPageController with ChangeNotifier {
  bool _validEmail = true;
  bool get validEmail => _validEmail;

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
}
