import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:kasirpinter_fe/services/auth_service.dart';

class MenuService {
  final String _baseUrl = dotenv.get('BASE_URL');
  final String _mainUrl = 'api/v1/pos';

  Future<List<Map<String, dynamic>>> fetchMenuItems({String? categoryName}) async {
    final AuthService authService = AuthService();
    final String? token = await authService.getToken();
    if (token == null) {
      throw Exception("Token not found");
    }

    String url = '$_baseUrl/$_mainUrl/menu?pages=0&limit=1000&sortBy=id&direction=asc';
    if (categoryName != null && categoryName.isNotEmpty) {
      if (categoryName != 'all') {
        url += '&category=$categoryName';
      }
    }

    print("url is :" + url);
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> transactions = responseData['data']['result'];

      return transactions.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to load menu items");
    }
  }

  Future<List<Map<String, dynamic>>> fetchMenuCategories() async {
    final AuthService authService = AuthService();
    final String? token = await authService.getToken();
    if (token == null) {
      throw Exception("Token not found");
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/$_mainUrl/menu/category'),
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> transactions = responseData['data'];

      return transactions.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to load menu items");
    }
  }

}