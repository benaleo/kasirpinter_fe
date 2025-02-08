import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  Map<String, dynamic>? selectedItem;
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
      crossAxisCount = 3;
    });
  }

  void removeFromCart(String itemName) {
    setState(() {
      cartItems.removeWhere((item) => item["name"] == itemName);
      if (cartItems.isEmpty) {
        crossAxisCount = 5;
      }
    });
  }

  int getTotalPrice() {
    return cartItems.fold(0, (total, item) {
      int price = int.tryParse(item["price"].toString()) ?? 0;
      int quantity = item["quantity"] ?? 1;
      return total + (price * quantity);
    });
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
                      SizedBox(height: 20.0),
                      RowListCategoryMenu(),
                      SizedBox(height: 20.0),
                      Expanded(
                        child: GridView.builder(
                          itemCount: menuItems.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 16.0,
                            crossAxisSpacing: 12.0,
                            childAspectRatio: 1.8,
                          ),
                          itemBuilder: (context, index) {
                            final item = menuItems[index];
                            return GestureDetector(
                              onTap: () {
                                addToCart(item);
                              },
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 40.0),
                                    child: Container(
                                      height: 120.0,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1.0, color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      padding: EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  item["name"],
                                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: 4.0),
                                                RichText(
                                                  text: TextSpan(
                                                    text: "Tersedia: ",
                                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                                    children: [
                                                      TextSpan(
                                                        text: item["availability"],
                                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  "Rp ${item["price"]}",
                                                  style: TextStyle(fontSize: 18.0, color: Colors.orange, fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 8.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0.0,
                                    top: 20.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.orange, width: 3),
                                      ),
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundImage: AssetImage(item["image"]),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (cartItems.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    width: 400.0,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PoppinsBold(
                              text: "Detail Pesanan",
                              size: 24.0,
                              color: Color(0xff464646),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  selectedItem = null;
                                  crossAxisCount = 5;
                                  cartItems.clear();
                                });
                              },
                            ),
                          ],
                        ),
                        Container(
                          width: widthDevice,
                          padding: EdgeInsets.only(right: 10.0),
                          child: Poppins(
                            text: "No.123",
                            size: 16.0,
                            textAlign: TextAlign.end,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        SizedBox(
                          height: 110.0,
                          child: ListView(
                            children: [
                              Poppins(text: "Form data", size: 18.0),
                              SizedBox(height: 10.0),
                              TextInputCustom(text: "Nama Pelanggan"),
                              SizedBox(height: 10.0),
                              Divider(height: 1.0, color: Colors.grey.shade200),
                            ],
                          ),
                        ),

                        Expanded(
                          child: ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 60.0,
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.grey.shade200, width: 2),
                                      ),
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(item["image"]),
                                      ),
                                    ),
                                    SizedBox(width: 16.0),
                                    Expanded(
                                      child: ListTile(
                                        title: Text(item["name"]),
                                        subtitle: Text("Rp ${item["price"]} x ${item["quantity"]}"),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.remove_circle_outline),
                                              onPressed: () {
                                                if (item["quantity"] == 1) {
                                                  removeFromCart(item["name"]);
                                                } else {
                                                  setState(() {
                                                    item["quantity"] -= 1;
                                                  });
                                                }
                                              },
                                            ),
                                            Text(item["quantity"].toString()),
                                            IconButton(
                                              icon: Icon(Icons.add_circle_outline),
                                              onPressed: () {
                                                setState(() {
                                                  item["quantity"] += 1;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Divider(),
                        Text("Total: Rp ${getTotalPrice()}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

