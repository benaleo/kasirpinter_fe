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
            children: [SansBold("Dashboard", 36.0)],
          ),
        ),
      ),
    );
    ;
  }
}
