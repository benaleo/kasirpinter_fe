import 'dart:io';

import 'package:flutter/material.dart';

class Middleware {
  static Future<void> checkTokenAndRedirect(
      BuildContext context, Function apiCall) async {
    try {
      await apiCall(); // Call the API function
    } on HttpException catch (e) {
      print("Error exception message: " + e.message);
      if (e.message ==
          '{"message": "Forbidden: Not authenticated", "status": 403}') {
        Navigator.of(context).pushReplacementNamed('/');
      } else {
        // Handle other HttpExceptions
        print('HttpException: ${e.message}');
      }
    } catch (e) {
      // Handle other exceptions
      throw e;
    }
  }
}
