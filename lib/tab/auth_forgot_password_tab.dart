import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/auth_components.dart';
import '../components/components.dart';
import '../services/auth_service.dart'; // Import AuthService

class AuthForgotPasswordTab extends StatefulWidget {
  const AuthForgotPasswordTab({super.key});

  @override
  State<AuthForgotPasswordTab> createState() => _AuthForgotPasswordTabState();
}

class _AuthForgotPasswordTabState extends State<AuthForgotPasswordTab> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendOtp() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Store email in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('tempDataEmail', _emailController.text);

      // Create an instance of AuthService
      final authService = AuthService();

      // Call the sendOtp API function on the instance
      final response = await authService.sendOtp(_emailController.text);
      if (response.success) {
        // Navigate to the OTP route if successful
        _successPopup();
      } else {
        // Handle error (show message to user)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.message)));
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _successPopup() {
    showDialog(
        context: context,
        builder: (context) {
          return SuccessAuthPopup(
            route: "/otp",
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              children: [
                SideBarAuth(),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Lupa Password",
                              style: TextStyle(
                                  fontSize: 36, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10.0),
                          Text("Masukkan email kamu ya untuk pemulihan",
                              style: TextStyle(fontSize: 20.0)),
                          SizedBox(height: 30.0),
                          TextInputCustom(
                            text: "Email",
                            icon: Icon(Icons.alternate_email_outlined),
                            controller: _emailController,
                          ),
                          SizedBox(height: 20.0),
                          Divider(),
                          SizedBox(height: 20.0),
                          ElevatedButtonCustom(
                              text: "Reset Password",
                              size: 18,
                              child: !_isLoading
                                  ? Poppins(
                                      text: "Reset Password",
                                      size: 18,
                                      color: Colors.white)
                                  : CircularProgressIndicator(),
                              color: Colors.white,
                              bgColor: _isLoading ? Colors.grey : null,
                              onPressed: _isLoading ? null : _sendOtp),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
