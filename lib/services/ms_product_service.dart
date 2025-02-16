import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class MsProductService {
  final String _baseUrl = dotenv.get('BASE_URL');
  final String _mainUrl = 'cms/v1/product';

  Future<Map<String, dynamic>> fetchProducts(
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
      throw Exception('Failed to load products');
    }
  }

  // Add other product-related methods here if needed
}
