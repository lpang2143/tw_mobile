import 'package:tw_mobile/ui/pages/registration_page/notifiers/registration_page_notifier.dart';

class RegistrationPageController {
  final emailNotifier = EmailModel();
  final passwordNotifier = PasswordModel();

  void checkEmail(String email) {
    emailNotifier.checkEmail(email);
  }

  bool getValidEmail() {
    return emailNotifier.validEmail;
  }

  void checkPasswordMatch(String password, String confirmPassword) {
    passwordNotifier.checkPasswordMatch(password, confirmPassword);
  }

  void checkPassword(String password) {
    passwordNotifier.hasSpecialChar(password);
    passwordNotifier.hasLowerCase(password);
    passwordNotifier.hasUpperCase(password);
    passwordNotifier.hasDigits(password);
    passwordNotifier.requireLength(password);
  }

  bool hasMatching() {
    return passwordNotifier.matching;
  }

  bool hasSpecialChar() {
    return passwordNotifier.specialChar;
  }

  bool hasUpperCase() {
    return passwordNotifier.upperCase;
  }

  bool hasLowerCase() {
    return passwordNotifier.lowerCase;
  }

  bool hasDigits() {
    return passwordNotifier.digits;
  }

  bool hasRequiredLength() {
    return passwordNotifier.requiredLength;
  }

  int getRequiredLength() {
    return passwordNotifier.reqLength;
  }

  
}
