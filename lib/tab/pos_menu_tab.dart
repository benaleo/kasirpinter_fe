import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kasirpinter_fe/components/components.dart';
import 'package:kasirpinter_fe/components/pos_components.dart';

class PosMenuTab extends StatefulWidget {
  const PosMenuTab({super.key});

  @override
  State<PosMenuTab> createState() => _PosMenuTabState();
}

class _PosMenuTabState extends State<PosMenuTab> {
  final List<Map<String, dynamic>> menuItems = [
    {
      "name": "Caffe Latte",
      "availability": "5 gelas",
      "price": "20000",
      "image": "assets/images/menu/coffee.png",
    },
    {
      "name": "Green Tea",
      "availability": "5 gelas",
      "price": "18000",
      "image": "assets/images/menu/pudding.png",
    },
    {
      "name": "Chicken BBQ",
      "availability": "5 porsi",
      "price": "23000",
      "image": "assets/images/menu/chicken.png",
    },
    {
      "name": "Croissant Keju",
      "availability": "5 porsi",
      "price": "20000",
      "image": "assets/images/menu/crossaint.png",
    },
    {
      "name": "Fried Fries",
      "availability": "5 porsi",
      "price": "20000",
      "image": "assets/images/menu/fried_fries.png",
    },
  ];

  List<Map<String, dynamic>> cartItems = [];
  int crossAxisCount = 5;

  void addToCart(Map<String, dynamic> item) {
    setState(() {
      var existingItem = cartItems.firstWhere(
            (cartItem) => cartItem["name"] == item["name"],
        orElse: () => {},
      );
      if (existingItem.isNotEmpty) {
        existingItem["quantity"] += 1;
      } else {
        cartItems.add({...item, "quantity": 1});
      }
      setCrossAxisCount(3);
    });
  }

  void removeFromCart(String itemName) {
    setState(() {
      cartItems.removeWhere((item) => item["name"] == itemName);
      if (cartItems.isEmpty) {
        setCrossAxisCount(5);
      }
    });
  }

  void clearCart() {
    setState(() {
      cartItems.clear();
      setCrossAxisCount(5);
    });
  }

  void setCrossAxisCount(int count) {
    setState(() {
      crossAxisCount = count;
    });
  }

  int getTotalPrice() {
    return cartItems.fold(0, (total, item) {
      int price = int.tryParse(item["price"].toString()) ?? 0;
      int quantity = item["quantity"] ?? 1;
      return total + (price * quantity);
    });
  }

  int getTotalItem() {
    return cartItems.fold(0, (total, item) {
      int quantity = item["quantity"] ?? 1;
      return total + quantity;
    });
  }

  static String format(String value) {
    final formatter = NumberFormat("###,###", "id_ID");
    return formatter.format(int.tryParse(value) ?? 0);
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
        drawer: DrawerElement(),
        backgroundColor: Colors.black12,
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                flex: cartItems.isEmpty ? 1 : 2,
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
                      RowListCategoryMenu(),
                      SizedBox(height: 10.0),
                      PosMenuList(
                        menuItems: menuItems,
                        crossAxisCount: crossAxisCount,
                        format: format,
                        addToCart: addToCart,
                      ),
                    ],
                  ),
                ),
              ),
              if (cartItems.isNotEmpty)
                PostMenuSideBarDetail(
                  crossAxisCount: crossAxisCount,
                  cartItems: cartItems,
                  removeFromCart: removeFromCart,
                  format: format,
                  getTotalItem: getTotalItem,
                  getTotalPrice: getTotalPrice,
                  clearCart: clearCart,
                  setCrossAxisCount: setCrossAxisCount,
                )
            ],
          ),
        ),
      ),
    );
  }
}

