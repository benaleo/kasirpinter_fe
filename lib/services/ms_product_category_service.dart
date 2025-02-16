import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:kasirpinter_fe/components/data_model.dart';

import 'auth_service.dart';

class MsProductCategoryService {
  final String _baseUrl = dotenv.get('BASE_URL');
  final String _mainUrl = 'cms/v1/product_category';
  final String _mainAppUrl = 'api/v1/ms/product-category';

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
        '$_baseUrl/$_mainAppUrl?pages=$page&limit=$limit&sortBy=$sortBy&direction=$direction&keyword=$keyword';
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

  Future<void> createUpdateProductCategory(
      {String? dataId,
      required String name,
      required String type,
      bool? isActive}) async {
    final AuthService authService = AuthService();
    final String? token = await authService.getToken();
    if (token == null) {
      throw Exception("Token not found");
    }

    String createUrl = '$_baseUrl/$_mainUrl';
    String updateUrl = '$_baseUrl/$_mainUrl/$dataId';
    final response = await http.post(
      Uri.parse(dataId == null ? createUrl : updateUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'name': name,
        'type': type,
        'isActive': dataId == null ? true : isActive,
      }),
    );

    print("url is: $createUrl");
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}"); // Add this line

    if (response.statusCode != 201) {
      throw Exception('Failed to create product category');
    }
  }

  Future<ApiResponse> deleteProductCategory(String productId) async {
    final AuthService authService = AuthService();
    final String? token = await authService.getToken();
    if (token == null) {
      throw Exception("Token not found");
    }

    String url = '$_baseUrl/$_mainUrl/$productId/delete';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'accept': '*/*',
      },
    );

    print("url is : $url");
    print("token is : $token");
    final Map<String, dynamic> responseData = json.decode(response.body);
    print("Response data: $responseData");
    print("Response body: ${response.body}");

    if (responseData['success']) {
      print('Successfully deleted product');
      return ApiResponse(
          success: responseData['success'],
          message: responseData['message'],
          data: responseData['data']);
    } else {
      print('Failed to delete product');
      return ApiResponse(success: false, message: 'Failed to delete product');
    }
  }

  Future<Map<String, dynamic>> getDetailProductCategory(
      String productId) async {
    final AuthService authService = AuthService();
    final String? token = await authService.getToken();
    if (token == null) {
      throw Exception("Token not found");
    }

    String url = '$_baseUrl/$_mainUrl/$productId';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to load product details');
    }
  }
}
