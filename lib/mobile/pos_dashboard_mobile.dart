import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:kasirpinter_fe/components/data_model.dart';
import 'package:kasirpinter_fe/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/components.dart';

class PosDashboardMobile extends StatefulWidget {
  const PosDashboardMobile({super.key});

  @override
  State<PosDashboardMobile> createState() => _PosDashboardMobileState();
}

class _PosDashboardMobileState extends State<PosDashboardMobile> {
  final _userService = UserService();

  String name = '';
  String company = '';
  String shift = '';
  String shiftTime = '';

  String? clockIn;
  String? clockOut;

  int _modalAwal = 0;
  int _pembayaranTunai = 0;
  int _pengembalianTunai = 0;
  int _pemasukanPenjualan = 0;
  int _pengeluaran = 0;
  int _totalSummary = 0;
  int _diskon = 0;
  int _totalPenjualanBersih = 0;

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
          company = userData['company_name'] ?? '';
          shift = userData['shift'] ?? '';
          shiftTime = userData['shift_time'] ?? '';
          clockIn = userData['in_at'];
          clockOut = userData['out_at'];
        });
      }
    }
  }

  Future<void> _updateUserInfo(String? newClockIn, String? newClockOut) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfo = prefs.getString('userInfo');
    if (userInfo != null) {
      Map<String, dynamic> userData = json.decode(userInfo);
      if (newClockIn != null) {
        userData['in_at'] = newClockIn;
      }
      if (newClockOut != null) {
        userData['out_at'] = newClockOut;
      }
      await prefs.setString('userInfo', json.encode(userData));
      setState(() {
        clockIn = userData['in_at'];
        clockOut = userData['out_at'];
        _modalAwal = userData['company_modal'];
      });
    }
  }

  void presencePopup(String type) {
    String verb = type == 'IN' ? 'masuk' : 'pulang';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          onPressed: () async {
            try {
              final UserService userService = UserService();
              await userService.userPresence(type);
              String dateTimeNow =
                  DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
              if (type == 'IN') {
                await _updateUserInfo(dateTimeNow, null);
              } else if (type == 'OUT') {
                await _updateUserInfo(null, dateTimeNow);
              }
              Fluttertoast.showToast(
                msg: "Absensi $verb berhasil!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              Navigator.of(context).pop();

              await Future.delayed(Duration(milliseconds: 1500));
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Absensi $verb berhasil!"),
                      content: Text("Data absensi berhasil disimpan"),
                      actions: [
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            } catch (e) {
              print("Error on dashboard: $e");
              Fluttertoast.showToast(
                msg: e.toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          },
          text: "Apakah kamu yakin akan $verb?",
        );
      },
    );
  }

  void _showAddModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int value = 0;
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            width: 500.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                PoppinsBold(
                  text: "Input Modal Awal",
                  size: 24.0,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),

                // name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Poppins(text: "Jumlah modal awal :", size: 16.0),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: TextEditingController(text: value.toString()),
                      onChanged: (value) {
                        value = (int.tryParse(value) ?? 0).toString();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey[200]!),
                        ),
                        hintText: 'Masukan jumlah modal awal',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButtonCustom(
                    text: "Batal",
                    size: 16.0,
                    boxHeight: 40.0,
                    width: 150.0,
                    bgColor: Colors.transparent,
                    color: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(width: 100.0),
                Expanded(
                  child: ElevatedButtonCustom(
                    text: "Simpan",
                    size: 16.0,
                    boxHeight: 40.0,
                    width: 150.0,
                    bgColor: Colors.blue,
                    color: Colors.white,
                    onPressed: () async {
                      try {
                        int? result = value;
                        print("result is: $result");
                        ApiResponse _result =
                            await _userService.userCompanyModal(result);
                        print("result is 2: $result");
                        if (_result.success) {
                          // close popup
                          Navigator.of(context).pop();
                          print("close popup");
                          // add toast
                          Fluttertoast.showToast(
                            msg: "Berhasil menyimpan modal awal!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          print("add toast");
                          // fetch
                          await _updateUserInfo(null, null);
                          print("fetch");
                        } else {
                          Navigator.of(context).pop();
                          _showInformationDialog(_result.message);
                        }
                      } on Exception catch (e) {
                        print("Error: $e");
                        Navigator.of(context).pop();
                        _showInformationDialog(e.toString());
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _showInformationDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return InformationDialog(message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
        body: Container(
          width: widthDevice,
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: PoppinsBold(text: "Dashboard", size: 24.0),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Card(
                      color: Color(0xffFFEDE2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 10.0),
                              width: widthDevice,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                  ),
                                  color: Color.fromRGBO(231, 119, 45, 0.3)),
                              child: PoppinsBold(text: "Profil", size: 20.0)),
                          SizedBox(height: 10.0),
                          Container(
                            height: 150.0,
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              spacing: 20.0,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  spacing: 5.0,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Poppins(text: "Name", size: 16.0),
                                    Poppins(text: "Perusahaan", size: 16.0),
                                    Poppins(text: "Shift", size: 16.0),
                                    Poppins(text: "Waktu Shift", size: 16.0),
                                  ],
                                ),
                                Column(
                                  spacing: 5.0,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Poppins(text: ": $name", size: 16.0),
                                    Poppins(text: ": $company", size: 16.0),
                                    Poppins(text: ": $shift", size: 16.0),
                                    Poppins(text: ": $shiftTime", size: 16.0),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Color(0xffFFEDE2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 10.0),
                              width: widthDevice,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                  ),
                                  color: Color.fromRGBO(231, 119, 45, 0.3)),
                              child: PoppinsBold(text: "Absensi", size: 20.0)),
                          SizedBox(height: 10.0),
                          Container(
                            height: 150.0,
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Poppins(
                                          text: "Waktu mulai: ",
                                          size: 16.0,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: PoppinsBold(
                                            text: clockIn ?? '',
                                            size: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButtonCustom(
                                      boxSize: 250.0,
                                      text: "Masuk",
                                      size: 16.0,
                                      width: 250.0,
                                      color: clockIn != null
                                          ? Colors.grey[600]
                                          : Colors.white,
                                      bgColor: clockIn != null
                                          ? Colors.grey[200]
                                          : null,
                                      boxHeight: 40.0,
                                      onPressed: clockIn != null
                                          ? null
                                          : () {
                                              presencePopup('IN');
                                            },
                                    )
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Poppins(
                                          text: "Waktu selesai: ",
                                          size: 16.0,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: PoppinsBold(
                                            text: clockOut ?? '',
                                            size: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButtonCustom(
                                      boxSize: 250.0,
                                      text: "Pulang",
                                      size: 16.0,
                                      width: 250.0,
                                      color: clockIn == null
                                          ? Colors.grey[600]
                                          : Colors.white,
                                      bgColor: clockIn == null
                                          ? Colors.grey[200]
                                          : null,
                                      boxHeight: 40.0,
                                      onPressed: clockIn == null
                                          ? null
                                          : () {
                                              presencePopup('OUT');
                                            },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Shift Sales Summary
              Expanded(
                child: Card(
                  color: Color(0xffFFEDE2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10.0),
                          width: widthDevice,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                              color: Color.fromRGBO(231, 119, 45, 0.3)),
                          child: PoppinsBold(text: "Shift Sales", size: 20.0)),
                      SizedBox(height: 10.0),
                      Container(
                        height: 110.0,
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          spacing: 20.0,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CardDashboard(
                              "Modal Awal",
                              "Rp. $_modalAwal",
                              onTap: () {
                                print("tapped Modal Awal");
                                _showAddModal();
                              },
                            ),
                            CardDashboard(
                                "Total Pemasukan", "Rp. $_pemasukanPenjualan"),
                            CardDashboard("Total Modal", "Rp. $_pengeluaran"),
                            CardDashboard(
                                "Total Profit", "Rp. $_totalPenjualanBersih"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Kas
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Card(
                      color: Color(0xffFFEDE2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 10.0),
                              width: widthDevice,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                  ),
                                  color: Color.fromRGBO(231, 119, 45, 0.3)),
                              child:
                                  PoppinsBold(text: "Laci uang", size: 20.0)),
                          SizedBox(height: 10.0),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              spacing: 20.0,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  spacing: 5.0,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Poppins(text: "Modal Awal", size: 16.0),
                                    Poppins(
                                        text: "Pembayaran tunai", size: 16.0),
                                    Poppins(
                                        text: "Pengembalian tunai", size: 16.0),
                                    Poppins(
                                        text: "Pemasukan Penjualan",
                                        size: 16.0),
                                    Poppins(text: "Pengeluaran", size: 16.0),
                                    PoppinsBold(
                                        text: "Jumlah Uang yang diharapkan",
                                        size: 16.0),
                                  ],
                                ),
                                Column(
                                  spacing: 5.0,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Poppins(
                                        text: "Rp. $_modalAwal", size: 16.0),
                                    Poppins(
                                        text: "Rp. $_pembayaranTunai",
                                        size: 16.0),
                                    Poppins(
                                        text: "Rp. $_pengembalianTunai",
                                        size: 16.0),
                                    Poppins(
                                        text: "Rp. $_pemasukanPenjualan",
                                        size: 16.0),
                                    Poppins(
                                        text: "Rp. $_pengeluaran", size: 16.0),
                                    Poppins(
                                        text: "Rp. $_totalSummary", size: 16.0),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Color(0xffFFEDE2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 10.0),
                              width: widthDevice,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                  ),
                                  color: Color.fromRGBO(231, 119, 45, 0.3)),
                              child:
                                  PoppinsBold(text: "Laci uang", size: 20.0)),
                          SizedBox(height: 10.0),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              spacing: 20.0,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  spacing: 5.0,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Poppins(
                                        text: "Penjualan kotor", size: 16.0),
                                    Poppins(
                                        text: "Pengembalian uang", size: 16.0),
                                    Poppins(text: "Diskon", size: 16.0),
                                    PoppinsBold(
                                        text: "Penjualan Bersih", size: 16.0),
                                  ],
                                ),
                                Column(
                                  spacing: 5.0,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Poppins(
                                        text: "Rp. $_pemasukanPenjualan",
                                        size: 16.0),
                                    Poppins(
                                        text: "Rp. $_pengembalianTunai",
                                        size: 16.0),
                                    Poppins(text: "Rp. $_diskon", size: 16.0),
                                    Poppins(
                                        text: "Rp. $_totalPenjualanBersih",
                                        size: 16.0),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CardDashboard extends StatelessWidget {
  final String title;
  final String value;
  final Function()? onTap;

  const CardDashboard(this.title, this.value, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery.of(context).size.width;

    return Expanded(
      child: Stack(
        children: [
          Container(
            width: widthDevice,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              spacing: 5.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Poppins(text: title, size: 16.0),
                Poppins(text: value, size: 16.0),
              ],
            ),
          ),
          if (onTap != null)
            Positioned(
              top: 0.0,
              right: 0.0,
              child: ElevatedButton(
                  onPressed: () {
                    onTap!();
                  },
                  child: Poppins(text: "Add", size: 16.0)),
            ),
        ],
      ),
    );
  }
}
