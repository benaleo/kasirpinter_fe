import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:kasirpinter_fe/services/auth_service.dart';

class InputAttributeService {
  final String _baseUrl = dotenv.get('BASE_URL');
  final String _mainUrl = 'api/v1/input';

  Future<List<Map<String, String>>> getProductCategories() async {
    final AuthService authService = AuthService();
    final String? token = await authService.getToken();
    if (token == null) {
      throw Exception("Token not found");
    }

    String url = '$_baseUrl/$_mainUrl/product-category';
    final response = await http.get(Uri.parse(url), headers: {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
    });

    print("url is :" + url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((category) {
        return {
          'name': category['name'] as String,
          'id': category['id'] as String,
        };
      }).toList();
    } else {
      throw Exception('Failed to load product categories');
    }
  }
}
