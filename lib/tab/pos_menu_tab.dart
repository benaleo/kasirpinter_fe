import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kasirpinter_fe/components/pos_components.dart';

import '../components/components.dart';

class PosMenuTab extends StatefulWidget {
  const PosMenuTab({super.key});
  @override
  State<PosMenuTab> createState() => _PosMenuTabState();
}

class _PosMenuTabState extends State<PosMenuTab> {
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
              SizedBox(height: 20.0),
              SizedBox(
                height: 40.0,
                child: RowListCategoryMenu(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}