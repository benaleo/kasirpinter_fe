import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kasirpinter_fe/components/auth_components.dart';
import 'package:kasirpinter_fe/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/components.dart';

class AuthOtpTab extends StatefulWidget {
  const AuthOtpTab({super.key});

  @override
  State<AuthOtpTab> createState() => _AuthOtpTabState();
}

class _AuthOtpTabState extends State<AuthOtpTab> {
  bool _isLoading = false;
  bool _isFailed = false;

  int _countdownTime = 120; // 2 minutes countdown
  Timer? _timer;

  final TextEditingController _otpField1 = TextEditingController();
  final TextEditingController _otpField2 = TextEditingController();
  final TextEditingController _otpField3 = TextEditingController();
  final TextEditingController _otpField4 = TextEditingController();
  final TextEditingController _otpField5 = TextEditingController();
  final TextEditingController _otpField6 = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();

  Future<void> _sendOtp() async {
    setState(() {
      _isLoading = true;
      _isFailed = true; // Set to true to show countdown
    });
    try {
      // Store email in SharedPreferences

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = prefs.getString('tempDataEmail') ?? '';

      // Create an instance of AuthService
      final authService = AuthService();

      // Call the sendOtp API function on the instance
      final response = await authService.sendOtp(email);
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

    // Start countdown timer
    _countdownTime = 120; // Reset countdown to 2 minutes
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdownTime > 0) {
        setState(() {
          _countdownTime--;
        });
      } else {
        timer.cancel(); // Stop the timer when countdown ends
        setState(() {
          _isFailed = false; // Reset _isFailed
        });
      }
    });
  }

  void _successPopup() {
    showDialog(
        context: context,
        builder: (context) {
          return SuccessAuthPopup(
            onPressed: () => Navigator.pop(context),
            buttonText: "OK",
          );
        });
  }

  void _failedPopup(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Poppins(
              text: message,
              size: 18.0,
            ),
            actions: [
              TextButton(
                child: Poppins(
                  text: 'OK',
                  size: 14.0,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  }

  void _verifyOtp() async {
    try {
      String otp = _otpField1.text +
          _otpField2.text +
          _otpField3.text +
          _otpField4.text +
          _otpField5.text +
          _otpField6.text;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = prefs.getString('tempDataEmail') ?? '';
      setState(() {
        _isLoading = true;
      });

      final authService = AuthService();
      final response = await authService.verifyOtp(email, otp);

      print("Response data: $response");
      print("Response success: ${response.success}");
      print("Response data: ${response.data}");

      print("Successfully verified OTP");
      await prefs.setString('tempDataToken', response.data);

      print("get token: ${prefs.getString('tempDataToken')}");

      Navigator.of(context).pushNamed("/change-password");
    } catch (e) {
      _failedPopup("Failed validate otp");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onOtpChanged(String value, FocusNode? nextFocus,
      FocusNode? previousFocus, TextEditingController controller) {
    if (value.isNotEmpty && value.length == 1 && nextFocus != null) {
      // Jika ada input, pindah ke kotak berikutnya
      FocusScope.of(context).requestFocus(nextFocus);
    } else if (value.isEmpty) {
      // Jika kotak kosong, pindah ke kotak sebelumnya
      if (previousFocus != null) {
        FocusScope.of(context).requestFocus(previousFocus);
      }
    }

    // Pastikan hanya satu karakter yang tersimpan di setiap kotak
    if (value.length > 1) {
      controller.text = value[0]; // Batasi hanya satu karakter
      if (nextFocus != null) {
        FocusScope.of(context).requestFocus(nextFocus);
      }
    }
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 40.0),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                child: Center(
                                  child: Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.black12),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: TextField(
                                        controller: index == 0
                                            ? _otpField1
                                            : index == 1
                                                ? _otpField2
                                                : index == 2
                                                    ? _otpField3
                                                    : index == 3
                                                        ? _otpField4
                                                        : index == 4
                                                            ? _otpField5
                                                            : _otpField6,
                                        focusNode: index == 0
                                            ? _focusNode1
                                            : index == 1
                                                ? _focusNode2
                                                : index == 2
                                                    ? _focusNode3
                                                    : index == 3
                                                        ? _focusNode4
                                                        : index == 4
                                                            ? _focusNode5
                                                            : _focusNode6,
                                        onChanged: (value) {
                                          _onOtpChanged(
                                            value,
                                            index == 0
                                                ? _focusNode2
                                                : index == 1
                                                    ? _focusNode3
                                                    : index == 2
                                                        ? _focusNode4
                                                        : index == 3
                                                            ? _focusNode5
                                                            : index == 4
                                                                ? _focusNode6
                                                                : null,
                                            index == 0
                                                ? null
                                                : index == 1
                                                    ? _focusNode1
                                                    : index == 2
                                                        ? _focusNode2
                                                        : index == 3
                                                            ? _focusNode3
                                                            : index == 4
                                                                ? _focusNode4
                                                                : _focusNode5,
                                            index == 0
                                                ? _otpField1
                                                : index == 1
                                                    ? _otpField2
                                                    : index == 2
                                                        ? _otpField3
                                                        : index == 3
                                                            ? _otpField4
                                                            : index == 4
                                                                ? _otpField5
                                                                : _otpField6,
                                          );
                                        },
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          counterText: '',
                                        ),
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        maxLength: 1,
                                        style: TextStyle(fontSize: 24.0),
                                      )),
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
                        color: Colors.white,
                        child: !_isLoading
                            ? Poppins(
                                text: "Verifikasi kode",
                                size: 16.0,
                                color: Colors.white)
                            : CircularProgressIndicator(),
                        boxHeight: 40.0,
                        bgColor: _isLoading ? Colors.grey[200] : null,
                        onPressed: _isLoading ? null : _verifyOtp,
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Poppins(
                              text: "Jika kamu tidak menerima kode",
                              size: 18.0),
                          if (_isFailed) ...[
                            Poppins(
                              text: ' $_countdownTime seconds',
                              size: 18.0,
                              color: Colors.red,
                            ),
                          ] else ...[
                            TextButton(
                              onPressed: _sendOtp,
                              child:
                                  Sans('Kirim ulang', 18.0, color: Colors.blue),
                            ),
                          ],
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
