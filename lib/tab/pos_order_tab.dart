import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kasirpinter_fe/components.dart';

class PosOrderTab extends StatefulWidget {
  const PosOrderTab({super.key});
  @override
  State<PosOrderTab> createState() => _PosOrderTabState();
}

class _PosOrderTabState extends State<PosOrderTab> {
  int _selectedIndex = 0; // Index item yang aktif

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                ),
                child: Text(''),
              ),
              DrawerListTile(index: 0, icon: Icons.dashboard, title: "Dashboard", selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
              DrawerListTile(index: 1, icon: Icons.shopping_cart, title: "Order", selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
              DrawerListTile(index: 2, icon: Icons.settings, title: "Setting", selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
              DrawerListTile(index: 3, icon: Icons.logout, title: "Logout", selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
            ],
          ),
        ),
        backgroundColor: Colors.black12,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
          color: Colors.grey.shade200,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 30.0,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Sans("Menu", 12.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 30.0,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Sans("Order", 12.0),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}