import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kasirpinter_fe/components/components.dart';
import 'package:kasirpinter_fe/components/pos_components.dart';
import 'package:kasirpinter_fe/services/menu_service.dart';

class PosSettingTab extends StatefulWidget {
  const PosSettingTab({super.key});

  @override
  State<PosSettingTab> createState() => _PosSettingTabState();
}

class _PosSettingTabState extends State<PosSettingTab> {
  late Future<List<Map<String, dynamic>>> futureMenuItems;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    futureMenuItems = MenuService().fetchMenuItems().then((value) {
      print("futureMenuItems is : $value");
      return value;
    }); // Panggil API saat widget diinisialisasi
  }

  @override
  Widget build(BuildContext context) {
    double heightDevice = MediaQuery.of(context).size.height;
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
          child: SingleChildScrollView(
            child: Column(
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
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: PoppinsBold(text: "Pengaturan", size: 16.0),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
