import 'package:flutter/material.dart';

import '../auth_components.dart';
import '../components.dart';

class AuthForgotPasswordTab extends StatefulWidget {
  const AuthForgotPasswordTab({super.key});

  @override
  State<AuthForgotPasswordTab> createState() => _AuthForgotPasswordTabState();
}

class _AuthForgotPasswordTabState extends State<AuthForgotPasswordTab> {
  final TextEditingController _emailController = TextEditingController();

  void _successPopup(){
    showDialog(
      context: context,
      builder: (context){
        return AuthPopupOTP(route: "/otp",);
      }
    );
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
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Lupa Password", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10.0),
                          Text("Masukkan email kamu ya untuk pemulihan", style: TextStyle(fontSize: 20.0)),
                          SizedBox(height: 30.0),
                          TextInputCustom(
                            text: "Email",
                            icon: Icon(Icons.alternate_email_outlined),
                            controller: _emailController,
                          ),
                          SizedBox(height: 20.0),
                          Divider(),
                          SizedBox(height: 20.0),
                          ElevateButtonCustom(
                            text: "Reset Password",
                            size: 18,
                            color: Colors.white,
                            onPressed: _successPopup
                          ),
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
