import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart';
import 'package:tw_mobile/data/classes/ticket.dart';
import 'package:tw_mobile/data/classes/event.dart';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tw_mobile/data/classes/user.dart';
import 'package:tw_mobile/data/status.dart';

class ApiClient {
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1'; // change in prod
  static const String logoutUrl = '$baseUrl/logout/';
  static const String loginUrl = '$baseUrl/login/';
  static const String registerUrl = '$baseUrl/register/';
  static const String userTicketUrl = '$baseUrl/get_tickets/';
  static const String teamEventUrl = '$baseUrl/team/events/';
  static const String eventTicketUrl = '$baseUrl/event/tickets/';
  static const String uploadUrl = '$baseUrl/upload/barcode/';
  static const String sessionKey = 'SESSION_ID';
  static const String userEventTickets = '$baseUrl/events/tickets/user/';

  final SessionManager _sessionManager = SessionManager();
  late final CookieJar _cookieJar;
  late final Dio _dio;

  ApiClient._internal() {
    _dio = Dio();
    _cookieJar = CookieJar();
    _dio.interceptors.add(CookieManager(_cookieJar));

    _loadCookies();
  }

  void _loadCookies() async {
    String? sessionId = await _sessionManager.getSession(sessionKey);
    String? csrfToken = await _sessionManager.getSession('csrftoken');

    if (sessionId != null && csrfToken != null) {
      var cookies = <Cookie>[
        Cookie("sessionid", sessionId),
        Cookie("csrftoken", csrfToken),
      ];

      var uri = Uri.parse(baseUrl);

      _cookieJar.saveFromResponse(uri, cookies);

      final headers = {
        'Cookie': 'sessionid=$sessionId; csrftoken=$csrfToken',
        'X-CSRFToken': csrfToken
      };

      _dio.options.headers.addAll(headers);
    }
  }

  static final ApiClient _singleton = ApiClient._internal();

  factory ApiClient() {
    return _singleton;
  }

  Future<bool> login(String username, String password) async {
    try {
      var response = await _dio.post(
        loginUrl,
        data: {'email': username, 'password': password},
      );
      if (response.statusCode == 200) {
        // Get the cookies from the response headers and store it in secure storage
        var cookies = response.headers.map['set-cookie'];
        debugPrint('$cookies');
        if (cookies != null) {
          String sessionCookie =
              cookies.firstWhere((element) => element.startsWith('sessionid='));
          var sessionId = sessionCookie.split(';')[0].split('=')[1];
          String sessionCsrf =
              cookies.firstWhere((element) => element.startsWith('csrftoken='));
          var csrfToken = sessionCsrf.split(';')[0].split('=')[1];

          // Save tokens in memory
          await _sessionManager.storeSession(sessionKey, sessionId);
          await _sessionManager.storeSession('csrftoken', csrfToken);

          _loadCookies();

          return true;
        }
      }
      return false;
    } catch (e) {
      throw ConnectionException();
    }
  }

  Future<bool> logout() async {
    try {
      var response = await _dio.post(
        logoutUrl,
      );
      if (response.statusCode == 200) {
        _sessionManager.clearSession('csrftoken');
        _sessionManager.clearSession(sessionKey);
        _dio.options.headers.remove('Cookie');
        _dio.options.headers.remove('X-CSRFToken');
        _cookieJar.deleteAll();
        return true;
      }
      return false;
    } catch (e) {
      throw ConnectionException();
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      var response = await _dio.post(
        '$baseUrl/password-reset/',
        data: {'email': email},
      );
      if (response.statusCode == 200) {
        debugPrint('Reset password link sent to email');
        return true;
      } else {
        debugPrint('Failed to send reset password link to email');
        return false;
      }
    } catch (e) {
      throw ConnectionException();
    }
  }

  // Place at top of app code, should just pull session key and use
  Future<void> autoLogin() async {
    String? sessionId = await _sessionManager.getSession(sessionKey);
    String? csrfToken = await _sessionManager.getSession('csrftoken');
    if (sessionId != null && csrfToken != null) {
      _loadCookies();
    } else {
      throw NoSessionFoundException();
    }
  }

  // Simple check if logged in function for use
  Future<bool> isLoggedIn() async {
    String? sessionId = await _sessionManager.getSession(sessionKey);
    return sessionId != null;
  }

  Future<Status> registerUser(String email, String firstName, String lastName,
      String phoneNumber, String password) async {
    final data = {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'password': password,
    };
    debugPrint(data.toString());

    try {
      final response = await _dio.post(registerUrl, data: data);

      // Handle the response as needed
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');
      if (response.statusCode == 201) {
        return Status.success;
      } else {
        return Status.duplicateKey;
      }
    } catch (e) {
      // Handle any errors that occurred during the request
      debugPrint('Error: $e');
      return Status.connectionError;
    }
  }

  Future<List<User>> getUserInfo() async {
    String url = '$baseUrl/user/';
    try {
      var response = await _dio.get(url);
      List<dynamic> responseData = response.data;
      return User.fromJsonList(responseData);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Ticket>> getUserTickets() async {
    String url = userTicketUrl;

    try {
      var response = await _dio.get(url);
      List<dynamic> responseData = response.data;
      return Ticket.fromJsonList(responseData);
    } catch (error) {
      debugPrint('Error fetching user tickets: $error');
      return [];
    }
  }

  Future<List<Event>> getUserEvents() async {
    String url = '$baseUrl/user/events/';

    try {
      List<dynamic> responseData = (await _dio.get(url)).data;

      return Event.fromJsonList(responseData);
    } catch (error) {
      debugPrint("Error fetching user tickets");
      rethrow;
    }
  }

  Future<List<Ticket>> getUserEventTicket(int eventId) async {
    String url = '$userEventTickets$eventId';
    try {
      List<dynamic> responseData = (await _dio.get(url)).data;
      return Ticket.fromJsonList(responseData);
    } catch (e) {
      debugPrint('Error fetching user event tickets: $e');
      rethrow;
    }
  }

  Future<List<Event>> getTrendingEvents() async {
    String url = '$baseUrl/trending-events';

    try {
      Map<String, dynamic> responseData = (await _dio.get(url)).data;

      // 'tickets' key contains list of tickets.
      List<dynamic> eventJsonList = responseData['events'] ?? [];

      return Event.fromJsonList(eventJsonList);
    } catch (error) {
      debugPrint('Error fetching trending tickets: $error');
      return [];
    }
  }

  Future<List<Event>> getTeamEvents(int teamId) async {
    String url = '$teamEventUrl$teamId';

    try {
      Map<String, dynamic> responseData = (await _dio.get(url)).data;

      return Event.fromJsonList([
        ...responseData['home_events'] ?? [],
        ...responseData['away_events'] ?? []
      ]);
    } catch (error) {
      debugPrint('Error fetching event tickets: $error');
      return [];
    }
  }

  // Posts the barcode to the server
  Future<void> uploadBarcode(String barcode, {bool parking = false}) async {
    try {
      var response = await _dio.post(
        uploadUrl,
        data: {
          'barcode': barcode,
          'parking': parking,
        },
      );

      if (response.statusCode == 201) {
        debugPrint('Successfully uploaded barcode.');
      } else {
        debugPrint('Barcode upload failed.');
      }
    } catch (e) {
      debugPrint('Error: $e');
      rethrow;
    }
  }

  Future<Status> updateProfile(String email, String firstName, String lastName,
      String phoneNumber, String dob, String profilePic) async {
    String url = '$baseUrl/user/';
    final data = {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'dob': dob,
      'profile_pic_url': profilePic,
    };
    try {
      var response = await _dio.post(url, data: data);
      if (response.statusCode == 200) {
        return Status.success;
      } else {
        throw Exception('Failed to update user data');
      }
    } catch (e) {
      return Status.connectionError;
    }
  }
  
  Future<Response> transferTickets(
      String jsonTicketData, String recipientEmail) async {
    try {
      var response = await _dio.patch(
        '$baseUrl/transfer_tickets/$recipientEmail',
        data: jsonTicketData,
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to transfer tickets');
      }
    } catch (e) {
      throw ConnectionException();
    }
  }

  Future<List<Ticket>> getEventTickets(int eventId) async {
    String url = '$eventTicketUrl$eventId';

    try {
      var response = await _dio.get(url);
      List<dynamic> responseData = response.data;
      return Ticket.fromJsonList(responseData);
    } catch (error) {
      debugPrint('Error fetching user tickets: $error');
      throw ConnectionException();
    }
  }
}

// Custom exceptions
class ConnectionException implements Exception {
  final String message =
      'There was an issue with the connection. Please try again later.';
}

class NoSessionFoundException implements Exception {
  final String message = 'No previous session found.';
}

class SessionManager {
  final FlutterSecureStorage _storage;

  SessionManager._internal() : _storage = const FlutterSecureStorage();

  static final SessionManager _singleton = SessionManager._internal();

  factory SessionManager() {
    return _singleton;
  }

  Future<void> storeSession(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> getSession(String key) async {
    return _storage.read(key: key);
  }

  Future<void> clearSession(String key) async {
    await _storage.delete(key: key);
  }
}
