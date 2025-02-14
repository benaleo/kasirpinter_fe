import 'package:flutter/material.dart';
import 'package:kasirpinter_fe/components/auth_components.dart';
import 'package:kasirpinter_fe/services/auth_service.dart';
import 'package:kasirpinter_fe/splash_screen.dart';

import '../components/components.dart';

class LoginTab extends StatefulWidget {
  const LoginTab({super.key});

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  void _handleLogin() async {
    setState(() {
      isLoading = true;
    });

    bool success = await AuthService().login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.of(context).pushReplacementNamed("/splash-screen");
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return InformationDialog("Email atau password salah!");
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double heightDevice = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SideBarAuth(),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    height: MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom == 0 ? heightDevice : heightDevice - 270,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SansBold("Hallo", 36.0),
                          SizedBox(height: 10.0),
                          Sans('Selamat Datang di Sistem Back Office Kasir Pinter', 20.0),
                          SizedBox(height: 30.0),
                          TextInputCustom(
                            controller: _emailController,
                            text: "Email",
                            icon: Icon(Icons.alternate_email_outlined),
                          ),
                          SizedBox(height: 20.0),
                          TextInputCustom(
                            controller: _passwordController,
                            text: "Password",
                            icon: Icon(Icons.lock),
                            isPassword: true,
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Checkbox(value: false, onChanged: (value) {}),
                              Text('Ingat saya'),
                              Spacer(),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed("/forgot-password");
                                },
                                child: Text('Lupa password?'),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.0),
                          ElevatedButtonCustom(
                            onPressed: isLoading ? null : _handleLogin,
                            text: 'Login',
                            size: 18.0,
                            child: isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Poppins(text: "Login",size: 18.0, color: Colors.white,),
                          ),
                          SizedBox(height: 20.0),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Sans("Belum punya akun ?", 16.0),
                          //     MaterialButton(
                          //       onPressed: () {
                          //         Navigator.of(context).pushNamed("/register");
                          //       },
                          //       child: Sans(
                          //         "Daftar sekarang",
                          //         16.0,
                          //         color: Colors.blue,
                          //       ),
                          //     )
                          //   ],
                          // )
                        ],
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
