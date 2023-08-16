import 'package:flutter/material.dart';
import 'package:tw_mobile/services/api_client.dart';
import 'package:tw_mobile/ui/pages/edit_profile_page/notifiers/edit_profile_page_notifier.dart';

class EditProfileController {
  final apiClient = ApiClient();
  final firstNameNotifier = NameModel();
  final lastNameNotifier = NameModel();
  final phoneNotifier = PhoneModel();
  final dateNotifier = DateModel();
  ValueNotifier<bool> inEditMode = ValueNotifier<bool>(false);

  bool _validUpdate = true;
  bool get validUpdate => _validUpdate;

  void updateProfile(String email, String firstName, String lastName,
      String phoneNumber, String dob) async {
    String profilePic =
        'https://i.natgeofe.com/k/ad9b542e-c4a0-4d0b-9147-da17121b4c98/MOmeow1_square.png';
    var attempt = await apiClient.updateProfile(
        email, firstName, lastName, phoneNumber, dob, profilePic);
    debugPrint('$attempt');
  }

  void checkValidUpdate(String email, String firstName, String lastName,
      String phoneNumber, String dob) {
    _validUpdate = true;
    firstNameNotifier.checkValidName(firstName);
    lastNameNotifier.checkValidName(lastName);
    phoneNotifier.checkValidNumber(phoneNumber);
    dateNotifier.checkValidDate(dob);
    if (!firstNameNotifier.validName ||
        !lastNameNotifier.validName ||
        !phoneNotifier.validNumber ||
        !dateNotifier.validDate) _validUpdate = false;
  }

  void checkFirstName(String name) {
    firstNameNotifier.checkValidName(name);
  }

  void checkLastName(String name) {
    lastNameNotifier.checkValidName(name);
  }

  bool validFirstName() {
    return firstNameNotifier.validName;
  }

  bool validLastName() {
    return lastNameNotifier.validName;
  }

  bool validNumber() {
    return phoneNotifier.validNumber;
  }

  bool validDate() {
    return dateNotifier.validDate;
  }

  void toggleEditing() {
    inEditMode.value = !inEditMode.value;
  }

  void dispose() {
    inEditMode.dispose();
  }
}
