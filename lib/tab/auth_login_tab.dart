import 'package:flutter/material.dart';
import 'package:kasirpinter_fe/components/auth_components.dart';
import 'package:kasirpinter_fe/services/auth_service.dart';

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

  Future<bool> _onBackPressed() async {
    bool shouldClose = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Konfirmasi'),
            content: Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Tidak'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Ya'),
              ),
            ],
          ),
        ) ??
        false;
    return shouldClose;
  }

  @override
  Widget build(BuildContext context) {
    double heightDevice = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false, // Prevent default back navigation
      onPopInvoked: (didPop) async {
        if (didPop) return;
        bool shouldClose = await _onBackPressed();
        if (shouldClose) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              SideBarAuth(),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).viewInsets.bottom == 0
                      ? heightDevice
                      : heightDevice,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 40.0),
                    child: ListView(
                      children: [
                        SizedBox(height: 50.0),
                        PoppinsBold(
                          text: "Hallo",
                          size: 36.0,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.0),
                        Poppins(
                          text:
                              'Selamat Datang di Sistem Back Office Kasir Pinter',
                          size: 20.0,
                          textAlign: TextAlign.center,
                        ),
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
                                Navigator.of(context)
                                    .pushNamed("/forgot-password");
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
                              ? CircularProgressIndicator(
                                  color: Colors.white)
                              : Poppins(
                                  text: "Login",
                                  size: 18.0,
                                  color: Colors.white,
                                ),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Poppins(text: "Belum punya akun ?", size: 14.0),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed("/register");
                              },
                              child: Poppins(
                                text: "Daftar Sekarang",
                                size: 14.0,
                                color: Colors.blue[600],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
