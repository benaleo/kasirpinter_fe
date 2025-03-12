import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasirpinter_fe/components/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PosSettingTab extends StatefulWidget {
  const PosSettingTab({super.key});

  @override
  State<PosSettingTab> createState() => _PosSettingTabState();
}

class _PosSettingTabState extends State<PosSettingTab> {
  String name = '';
  String email = '';
  String phone = '';
  String address = '';
  String avatar = '';

  bool isPasswordOpen = false;
  bool isEditOpen = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfo = prefs.getString('userInfo');
    if (userInfo != null) {
      Map<String, dynamic> userData = json.decode(userInfo);
      if (mounted) {
        setState(() {
          name = userData['name'] ?? '';
          email = userData['email'] ?? '';
          phone = userData['phone'] ?? '';
          address = userData['address'] ?? '';
          avatar = userData['avatar'] ?? '';

          _nameController.text = name;
          _emailController.text = email;
          _phoneController.text = phone;
          _addressController.text = address;
          _passwordController.text = "";
        });
      }
    }
  }

  void handleEditProfile() {}

  void handleEditPassword() {}

  @override
  Widget build(BuildContext context) {
    double heightDevice = MediaQuery.of(context).size.height;
    double widthDevice = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(50.0),
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: SvgPicture.asset(
            "assets/images/logo_black.svg",
            width: 200.0,
          ),
        ),
        drawer: DrawerElement(),
        backgroundColor: Colors.black12,
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Container(
                height: heightDevice - 120.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Stack(
                      children: [
                        Container(
                          height: 200.0,
                          width: widthDevice,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/left_side_login.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 70.0, top: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Poppins(
                                    text: "Halo",
                                    size: 32.0,
                                    color: Colors.white,
                                  ),
                                  PoppinsBold(
                                    text: "Benaleo Bayu",
                                    size: 20.0,
                                    color: Colors.white,
                                  ),
                                ],
                              )),
                        ),
                        Stack(
                          children: [AvatarField(), ProfileField()],
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

  Positioned AvatarField() {
    return Positioned(
      top: 130.0,
      left: 30.0,
      child: Column(
        children: [
          CircleAvatar(
            radius: 106.0,
            backgroundColor: Color(0xffF88F01),
            child: CircleAvatar(
              radius: 100.0,
              backgroundImage: avatar.isNotEmpty
                  ? NetworkImage(avatar)
                  : AssetImage('assets/images/empty.png'),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            width: 100.0,
            height: 30.0,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1.0,
                color: Color(0xff1976D2),
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: Text(
                'Ganti Foto',
                style: TextStyle(
                  color: Color(0xff1976D2),
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          Container(
            width: 100.0,
            height: 30.0,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.0,
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: Text(
                'Hapus Foto',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row ProfileField() {
    return Row(
      children: [
        SizedBox(width: 300.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 220.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GradientText(
                    text: "Profile admin",
                    style: GoogleFonts.poppins(
                        fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    spacing: 5.0,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButtonCustom(
                          text: isEditOpen ? "Tutup" : "Ubah Data",
                          size: 18,
                          boxSize: 100.0,
                          boxHeight: 40.0,
                          child: Poppins(
                              text: isEditOpen ? "Tutup" : "Ubah Data",
                              size: 18,
                              color: Colors.white),
                          color: Colors.white,
                          bgColor: isEditOpen ? Colors.red : null,
                          onPressed: () {
                            setState(() {
                              isEditOpen = !isEditOpen;
                            });
                            if (isEditOpen) {
                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) {
                                Scrollable.ensureVisible(context,
                                    duration: Duration(milliseconds: 300));
                              });
                            }
                          }),
                      if (isEditOpen)
                        ElevatedButtonCustom(
                            text: "Simpan Data",
                            size: 18,
                            boxSize: 100.0,
                            boxHeight: 40.0,
                            child: Poppins(
                                text: "Simpan Data",
                                size: 18,
                                color: Colors.white),
                            color: Colors.white,
                            bgColor: Colors.blue[600],
                            onPressed: () {
                              handleEditProfile();
                            })
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  FormField(
                      label: 'Nama',
                      controller: _nameController,
                      isEditOpen: isEditOpen),
                  SizedBox(width: 10.0),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  FormField(
                    label: 'Email',
                    controller: _emailController,
                  ),
                  SizedBox(width: 10.0),
                  FormField(
                    label: 'No. Telepon',
                    controller: _phoneController,
                    isEditOpen: isEditOpen,
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  FormField(
                      label: 'Alamat',
                      controller: _addressController,
                      maxLine: 3,
                      isEditOpen: isEditOpen),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GradientText(
                    text: "Password",
                    style: GoogleFonts.poppins(
                        fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    spacing: 5.0,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButtonCustom(
                          text: isPasswordOpen ? "Tutup" : "Ubah Password",
                          size: 18,
                          boxSize: 100.0,
                          boxHeight: 40.0,
                          child: Poppins(
                              text: isPasswordOpen ? "Tutup" : "Ubah Password",
                              size: 18,
                              color: Colors.white),
                          color: Colors.white,
                          bgColor: isPasswordOpen ? Colors.red : null,
                          onPressed: () {
                            setState(() {
                              isPasswordOpen = !isPasswordOpen;
                            });
                            if (isPasswordOpen) {
                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) {
                                Scrollable.ensureVisible(context,
                                    duration: Duration(milliseconds: 300));
                              });
                            }
                          }),
                      if (isPasswordOpen)
                        ElevatedButtonCustom(
                            text: "Simpan Password",
                            size: 18,
                            boxSize: 100.0,
                            boxHeight: 40.0,
                            child: Poppins(
                                text: "Simpan Password",
                                size: 18,
                                color: Colors.white),
                            color: Colors.white,
                            bgColor: Colors.blue[600],
                            onPressed: () {
                              handleEditPassword();
                            })
                    ],
                  )
                ],
              ),
              if (isPasswordOpen) SizedBox(height: 10.0),
              if (isPasswordOpen)
                Row(
                  spacing: 10.0,
                  children: [
                    FormField(
                        label: 'Password Lama',
                        controller: _passwordController,
                        isEditOpen: isPasswordOpen),
                  ],
                ),
              if (isPasswordOpen) SizedBox(height: 10.0),
              if (isPasswordOpen)
                Row(
                  spacing: 10.0,
                  children: [
                    FormField(
                        label: 'Password Baru',
                        controller: _newPasswordController,
                        isEditOpen: isPasswordOpen),
                  ],
                ),
              if (isPasswordOpen) SizedBox(height: 10.0),
              if (isPasswordOpen)
                Row(
                  spacing: 10.0,
                  children: [
                    FormField(
                        label: 'Konfirmasi Password Baru',
                        controller: _confirmNewPasswordController,
                        isEditOpen: isPasswordOpen),
                  ],
                ),
              SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom == 0
                      ? 20.0
                      : 200.0),
            ],
          ),
        ),
      ],
    );
  }

  Expanded FormField(
      {required String label,
      required TextEditingController controller,
      bool isEditOpen = false,
      int? maxLine}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Poppins(text: label, size: 16.0),
          SizedBox(height: 5.0),
          TextFormField(
            controller: controller,
            maxLines: maxLine == null ? 1 : maxLine,
            minLines: maxLine == null ? 1 : null,
            decoration: InputDecoration(
              hintText: 'Masukan $label',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              fillColor: isEditOpen ? null : Colors.grey[200],
              filled: isEditOpen ? false : true,
            ),
            enabled: isEditOpen,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Masukkan $label';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
