import 'dart:convert';
import 'dart:io';
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

  Future<void> createProduct({
    required File image,
    required String name,
    required int price,
    required int hppPrice,
    required int stock,
    required bool isUnlimited,
    required bool isUpSale,
    required bool isActive,
    required String categoryId,
  }) async {
    final AuthService authService = AuthService();
    final String? token = await authService.getToken();
    if (token == null) {
      throw Exception("Token not found");
    }

    final uri = Uri.parse('$_baseUrl/$_mainUrl');
    final request = http.MultipartRequest('POST', uri)
      ..fields['name'] = name
      ..fields['price'] = price.toString()
      ..fields['hppPrice'] = hppPrice.toString()
      ..fields['stock'] = stock.toString()
      ..fields['isUnlimited'] = isUnlimited.toString()
      ..fields['isUpSale'] = isUpSale.toString()
      ..fields['isActive'] = isActive.toString()
      ..fields['categoryId'] = categoryId
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['accept'] = '*/*'
      ..headers['Content-Type'] = 'multipart/form-data'
      ..files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();

    print("Response status: ${response.statusCode}");
    print("Request: ${request.fields}");

    if (response.statusCode == 201) {
      print('Successfully created product');
    } else {
      print('Failed to create product');
    }
  }

  // Add other product-related methods here if needed
}
