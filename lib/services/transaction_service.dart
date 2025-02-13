import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:kasirpinter_fe/services/auth_service.dart';

class TransactionService {
  final String _baseUrl = dotenv.get('BASE_URL');
  final String _mainUrl = 'api/v1/pos';

  Future<Map<String, dynamic>> createTransaction(
      String customerName, int amountPayment, String typePayment, String status,
      {List<Map<String, dynamic>> items = const []}) async {
    final AuthService authService = AuthService();
    final String? token = await authService.getToken();
    if (token == null) {
      throw Exception("Token not found");
    }

    print("Request body: ${jsonEncode(<String, dynamic>{
          'customerName': customerName,
          'amountPayment': amountPayment,
          'typePayment': typePayment,
          'status': status,
          'items': items
        })}");
    print("api url is : $_baseUrl");
    try {
      String apiUrl = '$_baseUrl/$_mainUrl/transaction';
      print("apiUrl: $apiUrl");
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "accept": "*/*",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'customerName': customerName,
          'amountPayment': amountPayment,
          'typePayment': typePayment,
          'status': status,
          'items': items
        }),
      );
      print("response: $response");

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success']) {
        print("response data: ${responseData['data']}");
        return responseData;
      } else {
        print("Error response body: ${response.body}"); // Log the response body
        throw Exception("Failed to create transaction: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Failed to create transaction");
    }
  }
}
