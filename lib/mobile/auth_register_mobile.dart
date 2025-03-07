import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kasirpinter_fe/components/auth_components.dart';
import 'package:kasirpinter_fe/components/data_model.dart';
import 'package:kasirpinter_fe/services/auth_service.dart';

import '../components/components.dart';

class RegisterMobile extends StatefulWidget {
  const RegisterMobile({super.key});

  @override
  State<RegisterMobile> createState() => _RegisterMobileState();
}

class _RegisterMobileState extends State<RegisterMobile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyAddressController =
      TextEditingController();
  final TextEditingController _companyCityController = TextEditingController();
  final TextEditingController _companyPhoneController = TextEditingController();
  bool isLoading = false;
  bool isCompanyForm = false;

  void _handleNext() {
    setState(() {
      isCompanyForm = true;
    });
  }

  void _handleBack() {
    setState(() {
      isCompanyForm = false;
    });
  }

  void _handleSave() async {
    setState(() {
      isLoading = true;
    });
    ApiResponse response = await AuthService().register(
      _emailController.text,
      _passwordController.text,
      _nameController.text,
      _phoneController.text,
      _companyNameController.text.isEmpty ? '' : _companyNameController.text,
      _companyAddressController.text.isEmpty
          ? ''
          : _companyAddressController.text,
      _companyCityController.text.isEmpty ? '' : _companyCityController.text,
      _companyPhoneController.text.isEmpty ? '' : _companyPhoneController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (response.success) {
      _successPopup();
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return InformationDialog(response.message);
        },
      );
    }
  }

  void _successPopup() {
    showDialog(
        context: context,
        builder: (context) {
          return SuccessAuthPopup(
            title: "Hore! Berhasil Mendaftar",
            body:
                "Silahkan login dengan email dan password yang telah Anda daftarkan",
            buttonText: "Login",
            route: "/login",
          );
        });
  }

  Future<bool> _onBackPressed() async {
    bool shouldClose = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Poppins(text: 'Konfirmasi', size: 20.0),
            content: Poppins(
                text: 'Apakah Anda yakin ingin keluar dari aplikasi?',
                size: 16.0),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Poppins(text: 'Tidak', size: 16.0),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Poppins(text: 'Ya', size: 16.0),
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
          child: ListView(
            children: [
              Stack(
                children: [
                  Container(
                    height: heightDevice - 60.0,
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/left_side_login.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 40.0),
                      child: ListView(
                        children: [
                          SizedBox(height: 120.0),
                          PoppinsBold(
                            text: "Pendaftaran",
                            size: 36.0,
                            textAlign: TextAlign.center,
                            color: Colors.white,
                          ),
                          SizedBox(height: 10.0),
                          // Poppins(
                          //     text:
                          //         'Selamat Datang di Sistem Back Office Kasir Pinter',
                          //     size: 16.0,
                          //     textAlign: TextAlign.center,
                          //     color: Colors.white),
                          SizedBox(height: 30.0),
                          if (!isCompanyForm)
                            TextInputCustom(
                              controller: _nameController,
                              text: "Nama",
                              textColor: Colors.white,
                              icon: Icon(Icons.person, color: Colors.white),
                            ),
                          if (!isCompanyForm) SizedBox(height: 20.0),
                          if (!isCompanyForm)
                            TextInputCustom(
                              controller: _phoneController,
                              text: "Telepon",
                              textColor: Colors.white,
                              icon: Icon(Icons.phone, color: Colors.white),
                            ),
                          if (!isCompanyForm) SizedBox(height: 20.0),
                          if (!isCompanyForm)
                            TextInputCustom(
                              controller: _emailController,
                              text: "Email",
                              textColor: Colors.white,
                              icon: Icon(Icons.alternate_email_outlined,
                                  color: Colors.white),
                            ),
                          if (!isCompanyForm) SizedBox(height: 20.0),
                          if (!isCompanyForm)
                            TextInputCustom(
                              controller: _passwordController,
                              text: "Password",
                              textColor: Colors.white,
                              icon: Icon(Icons.lock, color: Colors.white),
                              isPassword: true,
                            ),
                          if (!isCompanyForm) SizedBox(height: 10.0),
                          if (!isCompanyForm)
                            ElevatedButtonCustom(
                              onPressed: isLoading ? null : _handleNext,
                              text: 'Selanjutnya',
                              size: 18.0,
                              child: isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white)
                                  : Poppins(
                                      text: "Selanjutnya",
                                      size: 18.0,
                                      color: Colors.white,
                                    ),
                            ),
                          if (isCompanyForm)
                            TextInputCustom(
                              controller: _companyNameController,
                              text: "Nama Perusahaan",
                              textColor: Colors.white,
                              icon: Icon(Icons.business, color: Colors.white),
                            ),
                          if (isCompanyForm) SizedBox(height: 20.0),
                          if (isCompanyForm)
                            TextInputCustom(
                              controller: _companyAddressController,
                              text: "Alamat Perusahaan",
                              textColor: Colors.white,
                              icon:
                                  Icon(Icons.location_on, color: Colors.white),
                            ),
                          if (isCompanyForm) SizedBox(height: 20.0),
                          if (isCompanyForm)
                            TextInputCustom(
                              controller: _companyCityController,
                              text: "Kota Perusahaan",
                              textColor: Colors.white,
                              icon: Icon(Icons.location_city,
                                  color: Colors.white),
                            ),
                          if (isCompanyForm) SizedBox(height: 20.0),
                          if (isCompanyForm)
                            TextInputCustom(
                              controller: _companyPhoneController,
                              text: "Telepon Perusahaan",
                              textColor: Colors.white,
                              icon: Icon(Icons.phone, color: Colors.white),
                            ),
                          if (isCompanyForm) SizedBox(height: 10.0),
                          if (isCompanyForm)
                            Row(
                              spacing: 10.0,
                              children: [
                                Expanded(
                                  child: ElevatedButtonCustom(
                                    onPressed: isLoading ? null : _handleBack,
                                    text: 'Kembali',
                                    size: 18.0,
                                    bgColor: isLoading ? Colors.grey[200] : Colors.white,
                                    child: Poppins(
                                      text: "Kembali",
                                      size: 18.0,
                                      color: isLoading ? Colors.grey[600] : Colors.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ElevatedButtonCustom(
                                    onPressed: isLoading ? null : _handleSave,
                                    text: 'Daftar',
                                    size: 18.0,
                                    child: isLoading
                                        ? CircularProgressIndicator(
                                            color: Colors.white)
                                        : Poppins(
                                            text: "Daftar",
                                            size: 18.0,
                                            color: Colors.white,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 20.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Poppins(
                                text: "Sudah punya akun ?",
                                size: 14.0,
                                color: Colors.white,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed("/login");
                                },
                                child: Poppins(
                                  text: "Masuk",
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
