import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../components/components.dart';

class PosDashboardTab extends StatefulWidget {
  const PosDashboardTab({super.key});

  @override
  State<PosDashboardTab> createState() => _PosDashboardTabState();
}

class _PosDashboardTabState extends State<PosDashboardTab> {
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
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SansBold("Dashboard", 16.0),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
