import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class MsProductCategoryService {
  final String _baseUrl = dotenv.get('BASE_URL');
  final String _mainUrl = 'cms/v1/product_category';

  Future<Map<String, dynamic>> fetchProductCategories(
      {int page = 0,
      int limit = 10,
      String sortBy = 'id',
      String direction = 'asc',
      String keyword = ''}) async {
    final AuthService authService = AuthService();
    final String? token = await authService.getToken();
    if (token == null) {
      throw Exception("Token not found");
    }

    String url =
        '$_baseUrl/$_mainUrl?pages=$page&limit=$limit&sortBy=$sortBy&direction=$direction&keyword=$keyword';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );
    print("url is :" + url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load product categories');
    }
  }

  Future<void> createProductCategory({required String name}) async {
    final AuthService authService = AuthService();
    final String? token = await authService.getToken();
    if (token == null) {
      throw Exception("Token not found");
    }

    String url = '$_baseUrl/$_mainUrl';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'name': name,
        'isActive': true,
      }),
    );

    print("url is: $url");
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}"); // Add this line

    if (response.statusCode != 201) {
      throw Exception('Failed to create product category');
    }
  }
}
