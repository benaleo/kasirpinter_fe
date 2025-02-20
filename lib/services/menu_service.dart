import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kasirpinter_fe/services/auth_service.dart';

class MenuService {
  final String _baseUrl = dotenv.get('BASE_URL');
  final String _mainUrl = 'api/v1/pos';

  // Key to store menu categories in SharedPreferences
  static const String _menuCategoriesKey = 'saved_menu_categories';

  Future<List<Map<String, dynamic>>> fetchMenuItems(
      {String? categoryName}) async {
    final AuthService authService = AuthService();
    final String? token = await authService.getToken();
    if (token == null) {
      throw Exception("Token not found");
    }

    String url =
        '$_baseUrl/$_mainUrl/menu?pages=0&limit=1000&sortBy=id&direction=asc';
    if (categoryName != null && categoryName.isNotEmpty) {
      if (categoryName != 'All') {
        url += '&category=$categoryName';
      }
    }
    print("url is :" + url);
    print("token is : $token");
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> menuItems = responseData['data']['result'];
      return menuItems.cast<Map<String, dynamic>>();
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
    try {
      final String _baseUrl = dotenv.get('BASE_URL');
      final String _mainUrl = 'api/v1/user';

      String url = '$_baseUrl/$_mainUrl/menu/category';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      print("url is :" + url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> categories = responseData['data'];

        // Save categories to SharedPreferences
        await _saveMenuCategories(categories);

        return categories.cast<Map<String, dynamic>>();
      } else {
        throw Exception("Failed to load menu categories");
      }
    } catch (e) {
      print("Error fetching menu categories: $e");
      throw Exception("Failed to load menu categories");
    }
  }

  // Save menu categories to SharedPreferences
  Future<void> _saveMenuCategories(List<dynamic> categories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_menuCategoriesKey, jsonEncode(categories));
  }

  // Retrieve saved menu categories from SharedPreferences
  Future<List<Map<String, dynamic>>> getSavedMenuCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? categoriesJson = prefs.getString(_menuCategoriesKey);
    if (categoriesJson != null) {
      final List<dynamic> categories = jsonDecode(categoriesJson);
      return categories.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // Clear saved menu categories
  Future<void> clearSavedMenuCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_menuCategoriesKey);
  }
}
