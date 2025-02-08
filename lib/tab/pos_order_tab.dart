import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kasirpinter_fe/components/pos_components.dart';

import '../components/components.dart';

class PosOrderTab extends StatefulWidget {
  const PosOrderTab({super.key});
  @override
  State<PosOrderTab> createState() => _PosOrderTabState();
}

class _PosOrderTabState extends State<PosOrderTab> {
  @override
  Widget build(BuildContext context) {
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
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
          color: Colors.grey.shade200,
          child: Column(
            children: [
              PosMenuOrderTabs(),
              SizedBox(),
              RowListCategoryMenu()
            ],
          ),
        ),
      ),
    );
  }
}