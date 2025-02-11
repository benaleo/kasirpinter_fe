import 'package:flutter/material.dart';
import 'package:kasirpinter_fe/components/auth_components.dart';

import '../components/components.dart';


class AuthOtpTab extends StatefulWidget {
  const AuthOtpTab({super.key});

  @override
  State<AuthOtpTab> createState() => _AuthOtpTabState();
}

class _AuthOtpTabState extends State<AuthOtpTab> {

  void _successPopup(){
    showDialog(
        context: context,
        builder: (context){
          return AuthPopupOTP(route: "/otp", buttonText: "OK",);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SideBarAuth(),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SansBold("Masukan Kode OTP", 36.0),
                      SizedBox(height: 10.0),
                      Sans('Cek emailmu, dan masukkan kode OTP disini', 20.0),
                      SizedBox(height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(6, (index) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                child: Center(
                                  child: Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration:
                                        BoxDecoration(border: Border.all(width: 1, color: Colors.black12), borderRadius: BorderRadius.circular(5.0)),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        counterText: '',
                                      ),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
                                      style: TextStyle(fontSize: 24.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 20.0),
                      DividerBorder(),
                      SizedBox(height: 20.0),
                      ElevatedButtonCustom(
                        text: "Verifikasi kode",
                        size: 18.0,
                        route: '/change-password',
                        color: Colors.white,
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Sans("Jika kamu tidak menerima kode", 18.0),
                          TextButton(
                            onPressed: _successPopup,
                            child: Sans("Kirim ulang", 18.0, color: Colors.blue),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
