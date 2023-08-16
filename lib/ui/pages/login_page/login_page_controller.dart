import 'package:tw_mobile/ui/pages/login_page/notifiers/login_page_notifiers.dart';

class LoginPageController {
  final loginNotifier = LoginPageNotifier();

  void checkEmail(String email) {
    loginNotifier.checkEmail(email);
  }

  bool hasValidEmail(){
    return loginNotifier.validEmail;
  }

  void checkPassword(String password) {
    loginNotifier.checkPassword(password);
  }

  bool hasValidPassword() {
    return loginNotifier.validPassword;
  }
}
