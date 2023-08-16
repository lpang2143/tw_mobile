import 'package:get_it/get_it.dart';
import 'package:tw_mobile/ui/pages/login_page/login_page_controller.dart';
import 'package:tw_mobile/ui/pages/registration_page/registration_page_controller.dart';

final getItInstance = GetIt.instance;

void getItSetup() {
  getItInstance.registerLazySingleton<RegistrationPageController>(
    () => RegistrationPageController());

  getItInstance.registerLazySingleton<LoginPageController>(
    () => LoginPageController());
}
