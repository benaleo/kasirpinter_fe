import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:kasirpinter_fe/components/data_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class ProfileService {
  Future<void> userAvatar({ByteData? image, bool? isRemove = false}) async {
    final AuthService authService = AuthService();
    final String? token = await authService.getToken();
    if (token == null) {
      throw Exception("Token not found");
    }

    try {
      final String _baseUrl = dotenv.get('BASE_URL');
      final String _mainUrl = 'api/v1/user/avatar?isRemove=$isRemove';

      String url = '$_baseUrl/$_mainUrl';

      var request = http.MultipartRequest('PUT', Uri.parse(url));
      request.headers['accept'] = '*/*';
      request.headers['Authorization'] = 'Bearer $token';
      if (image != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'avatar',
            image.buffer.asUint8List(),
            filename: 'avatar.png',
          ),
        );
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print("url is: $url");
      print("Token is: $token");
      // print("Response status: ${response.statusCode}");
      // print("Response body: $responseBody");

      final data = json.decode(responseBody);
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

  Future<ApiResponse> userProfile(
      {String? name, String? email, String? phone, String? address}) async {
    final AuthService authService = AuthService();
    final String? token = await authService.getToken();
    if (token == null) {
      return ApiResponse(
        success: false,
        message: "Token not found",
        data: null,
      );
    }

    try {
      final String _baseUrl = dotenv.get('BASE_URL');
      final String _mainUrl = 'api/v1/user/profile';

      String url = '$_baseUrl/$_mainUrl';
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'email': email,
          'phone': phone,
          'address': address,
        }),
      );

      print("url is: $url");
      print("Token is: $token");
      // print("Response status: ${response.statusCode}");
      // print("Response body: ${response.body}");

      final data = json.decode(response.body);
      // Convert data['success'] to bool with null safety
      final bool isSuccess =
          data['success'] == null ? false : data['success'] as bool;

      if (isSuccess) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userInfo', json.encode(data['data']));
        print("Stored userInfo: ${json.encode(data['data'])}");

        return ApiResponse(
          success: true,
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

  Future<ApiResponse> userPassword(
      {String? oldPassword,
      String? newPassword,
      String? confirmPassword}) async {
    final AuthService authService = AuthService();
    final String? token = await authService.getToken();
    if (token == null) {
      throw Exception("Token not found");
    }

    try {
      final String _baseUrl = dotenv.get('BASE_URL');
      final String _mainUrl = 'api/v1/user/password';

      String url = '$_baseUrl/$_mainUrl';
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(<String, dynamic>{
          'oldPassword': oldPassword,
          'password': newPassword,
          'confirmPassword': confirmPassword,
        }),
      );

      print("url is: $url");
      print("Token is: $token");
      print(
          "curl -X PUT $url -H \"accept: */*\" -H \"Authorization: Bearer $token\" -H \"Content-Type: application/json\" -d '${jsonEncode(<String, dynamic>{
            'oldPassword': oldPassword,
            'password': newPassword,
            'confirmPassword': confirmPassword
          })}'");
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      final data = json.decode(response.body);
      // Convert data['success'] to bool with null safety
      final bool isSuccess =
          data['success'] == null ? false : data['success'] as bool;

      if (isSuccess) {
        return ApiResponse(
          success: true,
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
    } on Exception catch (e) {
      print("Error fetching user info: $e");
      rethrow;
    }
  }
}
