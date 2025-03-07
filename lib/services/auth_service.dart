import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:kasirpinter_fe/components/data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String _baseUrl = dotenv.get('BASE_URL');
  final String _mainUrl = 'api/auth';

  Future<bool> login(String email, String password) async {
    print("api url is : $_baseUrl");
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$_mainUrl/login'),
        headers: {"Content-Type": "application/json", "accept": "*/*"},
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      print("Response data: $data");
      if (data['success']) {
        String token = data['data']['token'];
        await _saveToken(token);
        return true;
      }
      return false;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<ApiResponse> register(String email, String password, String name, String phone,
      String companyName, String companyAddress, String companyCity, String companyPhone) async {
    print("api url is : $_baseUrl");
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$_mainUrl/register'),
        headers: {"Content-Type": "application/json", "accept": "*/*"},
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'company': <String, dynamic>{
            'name': companyName,
            'address': companyAddress,
            'city': companyCity,
            'phone': companyPhone
          }
        }),
      );

      final data = jsonDecode(response.body);
      print("Response data: $data");
      if (data['success']) {
        return ApiResponse(
          success: true,
          message: data['message'],
          data: null,
        );
      }
      return ApiResponse(
        success: false,
        message: data['message'],
        data: null,
      );
    } catch (e) {
      print("Error: $e");
      return ApiResponse(
        success: false,
        message: e.toString(),
        data: null,
      );
    }
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userInfo');
    await prefs.remove('tempDataEmail');
    await prefs.remove('tempDataToken');
    await prefs.remove('saved_menu_categories');
  }

  // send otp
  Future<ApiResponse> sendOtp(String email) async {
    try {
      String url = '$_baseUrl/$_mainUrl/forgot-password?email=$email';
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json", "accept": "*/*"},
      );
      print("api url is : $url");
      final data = jsonDecode(response.body);
      print("Response data: $data");
      if (data['success']) {
        return ApiResponse(
          success: data['success'],
          message: data['message'],
          data: null,
        );
      } else {
        return ApiResponse(
          success: false,
          message: data['message'],
          data: null,
        );
      }
    } catch (e) {
      print("Error: $e");
      return ApiResponse(
        success: false,
        message: e.toString(),
        data: null,
      );
    }
  }

  // verify otp
  Future<ApiResponse> verifyOtp(String email, String otp) async {
    try {
      String url = '$_baseUrl/$_mainUrl/validate-otp?email=$email&otp=$otp';
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json", "accept": "*/*"},
      );
      print("api url is : $url");
      final data = jsonDecode(response.body);
      print("Response data: $data");
      if (data['success']) {
        return ApiResponse(
          success: data['success'],
          message: data['message'],
          data: data['data'],
        );
      } else {
        return ApiResponse(
          success: false,
          message: data['message'],
          data: null,
        );
      }
    } catch (e) {
      print("Error: $e");
      return ApiResponse(
        success: false,
        message: e.toString(),
        data: null,
      );
    }
  }

// verify otp
  Future<ApiResponse> setNewPassword(
      String password, String confirmPassword, String id, String token) async {
    try {
      String url = '$_baseUrl/$_mainUrl/reset-password?token=$token&id=$id';
      final response = await http.put(Uri.parse(url),
          headers: {"Content-Type": "application/json", "accept": "*/*"},
          body: jsonEncode(<String, dynamic>{
            'password': password,
            'confirmPassword': confirmPassword
          }));

      print("api url is : $url");
      final data = jsonDecode(response.body);
      print("Response data: $data");
      if (data['success']) {
        return ApiResponse(
          success: data['success'],
          message: data['message'],
          data: null,
        );
      } else {
        return ApiResponse(
          success: false,
          message: data['message'],
          data: null,
        );
      }
    } catch (e) {
      print("Error: $e");
      return ApiResponse(
        success: false,
        message: e.toString(),
        data: null,
      );
    }
  }
}
