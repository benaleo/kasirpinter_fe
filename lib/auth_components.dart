import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'components.dart';

class SideBarAuth extends StatelessWidget {
  const SideBarAuth({super.key});

  @override
  Widget build(BuildContext context) {
    double heightDevice = MediaQuery.of(context).size.height;
    return Expanded(
      child: Container(
        height: heightDevice,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/left_side_login.png'), // Ganti dengan path gambar Anda
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            )),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/logo_white.svg",
                  width: 300.0,
                ),
                SizedBox(height: 10),
                Sans('Atur dan kembangkan bisnis bersama kami sekarang!', 18, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthPopupOTP extends StatelessWidget {
  final route;
  final buttonText;
  const AuthPopupOTP({super.key, this.route, this.buttonText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      contentPadding: EdgeInsets.zero,
      content: IntrinsicHeight(
        child: Stack(
          children: [
            Positioned(
              right: 20.0,
              top: 20.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Colors.grey[300],
                ),
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/images/success_man.png", height: 200.0, width: 200.0),
                  SizedBox(height: 10.0),
                  SansBold("OTP berhasil dikirim", 20.0),
                  SizedBox(height: 10.0),
                  SizedBox(
                      width: 350.0,
                      child: Sans(
                        "Silakan cek kotak masuk emailmu dan masukkan kode OTP di langkah selanjutnya",
                        16.0,
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      // Tambahkan logika verifikasi OTP di sini
                      Navigator.of(context).pushNamed(route);
                    },
                    child: Text(buttonText != null ? buttonText : "Langkah selanjutnya"),
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