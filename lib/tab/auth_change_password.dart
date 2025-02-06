import 'package:flutter/material.dart';

import '../auth_components.dart';
import '../components.dart';

class AuthChangePasswordTab extends StatelessWidget {
  const AuthChangePasswordTab({super.key});

  @override
  Widget build(BuildContext context) {
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
                    height: MediaQuery.of(context).viewInsets.bottom == 0 ? heightDevice : heightDevice - 270,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SansBold("Ganti password baru", 36.0),
                          SizedBox(height: 10.0),
                          Sans('Masukan password baru anda', 20.0),
                          SizedBox(height: 30.0),
                          TextInputCustom(
                            text: "Password Baru",
                            icon: Icon(Icons.lock),
                            isPassword: true,
                          ),
                          SizedBox(height: 20.0),
                          TextInputCustom(
                            text: "Ulangi Password Baru",
                            icon: Icon(Icons.lock),
                            isPassword: true,
                          ),
                          SizedBox(height: 20.0),
                          DividerBorder(),
                          SizedBox(height: 20.0),
                          ElevateButtonCustom(
                            text: "Simpan",
                            size: 18.0,
                            route: "/dashboard",
                            color: Colors.white,
                          ),
                          SizedBox(height: 20.0),
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
