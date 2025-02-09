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
    print("Current Route: ${ModalRoute.of(context)?.settings.name}");

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
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      PosMenuOrderTabs(),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}