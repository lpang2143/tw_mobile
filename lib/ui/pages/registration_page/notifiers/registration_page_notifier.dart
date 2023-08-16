import 'package:flutter/material.dart';
import 'package:tw_mobile/services/password_encryption.dart';

class EmailModel with ChangeNotifier {
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

class PasswordModel with ChangeNotifier {
  int reqLength = 8; // required password length

  bool _matching = true;
  bool _specialChar = true;
  bool _upperCase = true;
  bool _lowerCase = true;
  bool _digits = true;
  bool _requiredLength = true;

  bool get matching => _matching;
  bool get specialChar => _specialChar;
  bool get upperCase => _upperCase;
  bool get lowerCase => _lowerCase;
  bool get digits => _digits;
  bool get requiredLength => _requiredLength;

  void checkPasswordMatch(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      _matching = true;
    } else if (!(password == confirmPassword)) {
      _matching = false;
    } else {
      _matching = true;
    }
    notifyListeners();
  }

  void hasSpecialChar(String password) {
    if (password.isEmpty) {
      _specialChar = true;
    } else {
      _specialChar = password.contains(RegExp(r'[!@#$%^&*]'));
    }
    notifyListeners();
  }

  void hasUpperCase(String password) {
    if (password.isEmpty) {
      _upperCase = true;
    } else {
      _upperCase = password.contains(RegExp(r'[A-Z]'));
    }
    notifyListeners();
  }

  void hasLowerCase(String password) {
    if (password.isEmpty) {
      _lowerCase = true;
    } else {
      _lowerCase = password.contains(RegExp(r'[a-z]'));
    }
    notifyListeners();
  }

  void hasDigits(String password) {
    if (password.isEmpty) {
      _digits = true;
    } else {
      _digits = password.contains(RegExp(r'[0-9]'));
    }
    notifyListeners();
  }

  void requireLength(String password) {
    if (password.isEmpty) {
      _requiredLength = true;
    } else {
      _requiredLength = password.length >= reqLength;
    }
    notifyListeners();
  }

  //needs other password checks, such as no empty password, and possibly length
  //or includes number/special character. Will require two values, a valid bool
  //and string error message.

  void create(String email, String password) {
    final pwd, salt = encryptPassword(password);
    debugPrint('Account Created!');
  }
}
