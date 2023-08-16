import 'package:flutter/material.dart';

class EmailTicketNotifier with ChangeNotifier {
  bool _validEmail = false;
  bool get validEmail => _validEmail;

  void checkEmail(String email) {
    if (email.isEmpty) {
      _validEmail = false;
    } else {
      _validEmail = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
    }
    notifyListeners();
  }
}
