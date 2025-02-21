import 'package:flutter/material.dart';
import 'package:kasirpinter_fe/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/auth_components.dart';
import '../components/components.dart';

class AuthChangePasswordTab extends StatefulWidget {
  AuthChangePasswordTab({Key? key}) : super(key: key);

  @override
  _AuthChangePasswordTabState createState() => _AuthChangePasswordTabState();
}

class _AuthChangePasswordTabState extends State<AuthChangePasswordTab> {
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordValid = false;

  final _formKey = GlobalKey<FormState>();

  void _validatePasswords() {
    print('Password: ${_passwordController.text}');
    print('Confirm Password: ${_passwordConfirmController.text}');
    setState(() {
      // Ensure the passwords match and are not empty
      _isPasswordValid =
          (_passwordController.text == _passwordConfirmController.text) &&
              _passwordController.text.isNotEmpty &&
              _passwordConfirmController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      print('Password field changed');
      _validatePasswords();
    });
    _passwordConfirmController.addListener(() {
      print('Confirm Password field changed');
      _validatePasswords();
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FocusNode _passwordFocusNode = FocusNode();
    final FocusNode _confirmPasswordFocusNode = FocusNode();

    void _successPopup() {
      showDialog(
          context: context,
          builder: (context) {
            return SuccessAuthPopup(
              route: "/",
              buttonText: "OK",
              title: "Yeay, password berhasil diperbarui",
              body:
                  "Password kamu sudah diperbarui, ingat terus ya password nya!",
            );
          });
    }

    void _failedPopup(String message) {
      showDialog(
          context: context,
          builder: (context) {
            return InformationDialog(message);
          });
    }

    Future<void> _verifyPassword() async {
      try {
        setState(() {
          _isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = prefs.getString('tempDataToken') ?? '';
        final authService = AuthService();
        final response = await authService.setNewPassword(
            _passwordController.text,
            _passwordConfirmController.text,
            "reset",
            token);
        if (response.success) {
          _successPopup();

          prefs.remove('tempDataEmail');
          prefs.remove('tempDataToken');
        } else {
          _failedPopup(response.message);
        }
      } catch (e) {
        _failedPopup("Failed set password");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

    double heightDevice = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SideBarAuth(),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 40.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SansBold("Ganti password baru", 36.0),
                            SizedBox(height: 10.0),
                            Sans('Masukan password baru anda', 20.0),
                            SizedBox(height: 30.0),
                            TextInputCustom(
                              controller: _passwordController,
                              text: "Password Baru",
                              icon: Icon(Icons.lock),
                              isPassword: true,
                              focusNode: _passwordFocusNode,
                              onSubmitted: () {
                                FocusScope.of(context)
                                    .requestFocus(_confirmPasswordFocusNode);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Password harus diisi";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextInputCustom(
                              controller: _passwordConfirmController,
                              text: "Ulangi Password Baru",
                              icon: Icon(Icons.lock),
                              isPassword: true,
                              focusNode: _confirmPasswordFocusNode,
                              onSubmitted: () {
                                FocusScope.of(context).unfocus();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Konfirmasi Password harus diisi";
                                } else if (value != _passwordController.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.0),
                            DividerBorder(),
                            SizedBox(height: 20.0),
                            ElevatedButtonCustom(
                              onPressed: () {
                                if (_formKey.currentState!.validate() &&
                                    !_isLoading) {
                                  _verifyPassword();
                                } else {
                                  print(
                                      "Passwords do not match or are invalid");
                                }
                              },
                              text: "Simpan",
                              size: 18.0,
                              bgColor: _isLoading ? Colors.grey[200] : null,
                              boxHeight: 40.0,
                              child: _isLoading
                                  ? CircularProgressIndicator()
                                  : Poppins(
                                      text: "Simpan",
                                      size: 18.0,
                                      color: Colors.white,
                                    ),
                              color: Colors.white,
                            ),
                            SizedBox(height: 20.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
