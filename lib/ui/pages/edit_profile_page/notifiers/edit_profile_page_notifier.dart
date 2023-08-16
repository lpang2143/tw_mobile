import 'package:flutter/material.dart';
import 'package:tw_mobile/services/api_client.dart';

class PhoneModel with ChangeNotifier {
  bool _validNumber = true;
  bool get validNumber => _validNumber;

  void checkValidNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      _validNumber = false;
    } else {
      _validNumber = phoneNumber.contains(RegExp(r'[0-9]'));
    }
    notifyListeners();
  }
}

class NameModel with ChangeNotifier {
  bool _validName = true;
  bool get validName => _validName;

  void checkValidName(String name) {
    if (name.isEmpty) {
      _validName = false;
    } else {
      _validName =
          !name.contains(RegExp(r'[0-9!@#$%^&*]')); // does not contain digits
    }
    notifyListeners();
  }
}

class DateModel with ChangeNotifier {
  bool _validDate = true;
  bool get validDate => _validDate;

  void checkValidDate(String date) {
    _validDate = true;
    if (DateTime.tryParse(date) == null) {
      _validDate = false;
    }
    notifyListeners();
  }
}
