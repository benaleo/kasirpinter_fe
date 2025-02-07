import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'components.dart';

class PosAppBar extends StatefulWidget implements PreferredSizeWidget {
  const PosAppBar({super.key});

  @override
  State<PosAppBar> createState() => _PosAppBarState();

  // Implement the preferredSize getter
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PosAppBarState extends State<PosAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }
}

class PosMenuOrderTabs extends StatelessWidget {
  const PosMenuOrderTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                onPressed: () {
                  Navigator.of(context).pushNamed("/pos-menu");
                },
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
                onPressed: () {
                  Navigator.of(context).pushNamed("/pos-order");
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Sans("Order", 12.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RowListCategoryMenu extends StatefulWidget {
  @override
  _RowListCategoryMenuState createState() => _RowListCategoryMenuState();
}

class _RowListCategoryMenuState extends State<RowListCategoryMenu> {
  // Variabel untuk melacak indeks tombol yang aktif
  int _selectedIndex = 0;

  final List<String> categories = [
    "All",
    "Coffee based",
    "Milk based",
    "Tea",
    "Rice",
    "Bread",
    "Pastry",
    "Burger",
    "Snack"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0, // Tinggi tetap untuk ListView horizontal
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                // Update indeks tombol yang aktif
                setState(() {
                  _selectedIndex = index;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedIndex == index
                    ? Color(0xffE7772D) // Warna aktif
                    : Colors.grey.shade200, // Warna tidak aktif
                foregroundColor: _selectedIndex == index
                    ? Colors.white // Warna teks aktif
                    : Colors.black, // Warna teks tidak aktif
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 0.0,
              ),
              child: RowListCategory(text: categories[index]),
            ),
          );
        },
      ),
    );
  }
}

class RowListCategory extends StatelessWidget {
  final String text;

  const RowListCategory({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 40.0),
        child: SizedBox(
          height: 30.0,
          child: Center(child: Sans(text, 16)),
        ),
      ),
    );
  }
}
