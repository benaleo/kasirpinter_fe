import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'components.dart';

class SideBarAuth extends StatelessWidget {
  final bool? isMobile;
  const SideBarAuth({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    double heightDevice = MediaQuery.of(context).size.height;
    double _top = isMobile == true ? 30.0 : 10.0;

    return Expanded(
      child: Container(
        height: heightDevice,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/left_side_login.png'), // Ganti dengan path gambar Anda
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Padding(
            padding: EdgeInsets.only(
                left: 10.0, right: 10.0, bottom: 10.0, top: _top),
            child: Column(
              mainAxisAlignment: isMobile == true
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/logo_white.svg",
                  width: isMobile == true ? 150.0 : 300.0,
                ),
                SizedBox(height: 10),
                if (isMobile != true)
                Poppins(
                  text: 'Atur dan kembangkan bisnis bersama kami sekarang!',
                  size: 18,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SuccessAuthPopup extends StatelessWidget {
  final route;
  final title;
  final body;
  final buttonText;
  final VoidCallback? onPressed;

  const SuccessAuthPopup(
      {super.key,
      this.route,
      this.buttonText,
      this.title,
      this.body,
      this.onPressed});

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
                  Image.asset("assets/images/success_man.png",
                      height: 200.0, width: 200.0),
                  SizedBox(height: 10.0),
                  SansBold(
                      title != null ? title : "OTP berhasil dikirim", 20.0),
                  SizedBox(height: 10.0),
                  SizedBox(
                      width: 350.0,
                      child: Sans(
                        body != null
                            ? body
                            : "Silakan cek kotak masuk emailmu dan masukkan kode OTP di langkah selanjutnya",
                        16.0,
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      if (onPressed != null) {
                        onPressed!();
                      } else {
                        Navigator.of(context).pushNamed(route);
                      }
                    },
                    child: Text(buttonText != null
                        ? buttonText
                        : "Langkah selanjutnya"),
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
