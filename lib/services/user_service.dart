import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:kasirpinter_fe/components/data_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class UserService {
  Future<void> fetchUserInfo() async {
    final AuthService authService = AuthService();
    final String? token = await authService.getToken();
    if (token == null) {
      throw Exception("Token not found");
    }

    try {
      final String _baseUrl = dotenv.get('BASE_URL');
      final String _mainUrl = 'api/v1/user';

      String url = '$_baseUrl/$_mainUrl/info';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      print("url is: $url");
      print("Token is: $token");
      // print("Response status: ${response.statusCode}");
      // print("Response body: ${response.body}");

      final data = json.decode(response.body);
      if (data['success']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userInfo', json.encode(data['data']));
        print("Stored userInfo: ${json.encode(data['data'])}");
      } else {
        throw Exception("Failed to fetch user info: ${data['message']}");
      }
    } catch (e) {
      print("Error fetching user info: $e");
      throw Exception("Failed to load user info");
    }
  }

  Future<void> userPresence(String type) async {
    final AuthService authService = AuthService();
    final String? token = await authService.getToken();
    if (token == null) {
      throw Exception("Token not found");
    }

    try {
      final String _baseUrl = dotenv.get('BASE_URL');
      final String _mainUrl = 'api/v1/user/presence?type=$type';

      String url = '$_baseUrl/$_mainUrl';
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      print("url is: $url");
      print("Token is: $token");
      // print("Response status: ${response.statusCode}");
      // print("Response body: ${response.body}");

      final data = json.decode(response.body);
      if (data['success']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userInfo', json.encode(data['data']));
        print("Stored userInfo: ${json.encode(data['data'])}");
      } else {
        throw Exception("Failed to fetch user info: ${data['message']}");
      }
    } catch (e) {
      print("Error fetching user info: $e");
      throw Exception("Failed to load user info");
    }
  }

  Future<ApiResponse> userCompanyModal(int value) async {
    final AuthService authService = AuthService();
    final String? token = await authService.getToken();
    if (token == null) {
      throw Exception("Token not found");
    }

    try {
      final String _baseUrl = dotenv.get('BASE_URL');
      final String _mainUrl = 'api/v1/user/company/modal?value=$value';

      String url = '$_baseUrl/$_mainUrl';
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      print("url is: $url");
      print("Token is: $token");
      // print("Response status: ${response.statusCode}");
      // print("Response body: ${response.body}");

      final data = json.decode(response.body);
      if (data['success']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userInfo', json.encode(data['data']));
        print("Stored userInfo: ${json.encode(data['data'])}");
        return ApiResponse(
          success: data['success'],
          message: data['message'],
          data: data['data'] ?? "",
        );
      } else {
        return ApiResponse(
          success: false,
          message: data['message'],
          data: null,
        );
      }
    } catch (e) {
      print("Error fetching user info: $e");
      return ApiResponse(
        success: false,
        message: e.toString(),
        data: null,
      );
    }
  }
}
