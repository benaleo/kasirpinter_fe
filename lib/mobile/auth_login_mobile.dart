import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kasirpinter_fe/components/auth_components.dart';
import 'package:kasirpinter_fe/services/auth_service.dart';
import 'package:kasirpinter_fe/splash_screen.dart';

import '../components/components.dart';

class LoginMobile extends StatefulWidget {
  const LoginMobile({super.key});

  @override
  State<LoginMobile> createState() => _LoginMobileState();
}

class _LoginMobileState extends State<LoginMobile> {
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
    double widthDevice = MediaQuery.of(context).size.width;
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
          child: ListView(
            children: [
              Stack(
                children: [
                  Container(
                    height: heightDevice - 60.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/left_side_login.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 120.0),
                          PoppinsBold(
                            text: "Hallo",
                            size: 36.0,
                            color: Colors.white,
                          ),
                          SizedBox(height: 10.0),
                          Poppins(
                            text:
                            'Selamat Datang di Sistem Back Office Kasir Pinter',
                            size: 16.0,
                            color: Colors.white,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 30.0),
                          TextInputCustom(
                            controller: _emailController,
                            text: "Email",
                            textColor: Colors.white,
                            icon: Icon(
                              Icons.alternate_email_outlined,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          TextInputCustom(
                            controller: _passwordController,
                            text: "Password",
                            textColor: Colors.white,
                            icon: Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            isPassword: true,
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Checkbox(value: false, onChanged: (value) {}),
                              Poppins(
                                  text: 'Ingat saya',
                                  size: 12.0,
                                  color: Colors.white),
                              Spacer(),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed("/forgot-password");
                                },
                                child: Poppins(
                                  text: 'Lupa password?',
                                  size: 12.0,
                                  color: Colors.grey[100],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.0),
                          ElevatedButtonCustom(
                            onPressed: isLoading ? null : _handleLogin,
                            text: 'Masuk',
                            size: 18.0,
                            child: isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Poppins(
                              text: "Masuk",
                              size: 18.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Poppins(text: "Belum punya akun ?", size: 14.0, color: Colors.white,),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed("/register");
                              },
                              child: Poppins(
                                text: "Daftar Sekarang",
                                size: 14.0,
                                color: Colors.white,
                                textDecoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 70,
                    left: (MediaQuery.of(context).size.width - 150) / 2,
                    child: SvgPicture.asset(
                      "assets/images/logo_white.svg",
                      width: 150.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
