import 'package:tw_mobile/services/api_client.dart';

class HomePageController {
  final ApiClient apiClient = ApiClient();

  Future<bool> logout() async {
    return await apiClient.logout();
  }
}