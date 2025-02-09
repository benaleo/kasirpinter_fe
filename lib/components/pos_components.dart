import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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

class PosMenuOrderTabs extends StatefulWidget {
  const PosMenuOrderTabs({super.key});

  @override
  _PosMenuOrderTabsState createState() => _PosMenuOrderTabsState();
}

class _PosMenuOrderTabsState extends State<PosMenuOrderTabs> {
  String? currentRoute;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      currentRoute = ModalRoute.of(context)?.settings.name;
    });
  }

  void _navigateTo(String route) {
    if (currentRoute != route) {
      print("Navigating to $route");
      Navigator.of(context).pushReplacementNamed(route).then((_) {
        if (mounted) {
          setState(() {
            currentRoute = route;
          });
          print("Current route: $route");
        }
      });
    }
  }

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
                onPressed: currentRoute == "/pos-menu" ? null : () => _navigateTo("/pos-menu"),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: currentRoute == "/pos-menu" ? Color(0xffE7772D).withOpacity(0.3) : null,
                ),
                child: PoppinsBold(
                  text: "Menu",
                  size: 12.0,
                  color: currentRoute == "/pos-menu" ? Color(0xffE7772D) : Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 30.0,
              child: TextButton(
                onPressed: currentRoute == "/pos-order" ? null : () => _navigateTo("/pos-order"),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: currentRoute == "/pos-order" ? Color(0xffE7772D).withOpacity(0.3) : null,
                ),
                child: PoppinsBold(
                  text: "Order",
                  size: 12.0,
                  color: currentRoute == "/pos-order" ? Color(0xffE7772D) : Colors.black,
                ),
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

  final List<String> categories = ["All", "Coffee based", "Milk based", "Tea", "Rice", "Bread", "Pastry", "Burger", "Snack"];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.0, // Tinggi tetap untuk ListView horizontal
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
          child: Center(child: Poppins(text: text, size: 12.0)),
        ),
      ),
    );
  }
}

class PosMenuList extends StatefulWidget {
  final List<Map<String, dynamic>> menuItems;
  final int crossAxisCount;
  final String Function(String value) format;
  final void Function(Map<String, dynamic> item) addToCart;

  const PosMenuList({
    super.key,
    required this.menuItems,
    required this.crossAxisCount,
    required this.format,
    required this.addToCart,
  });

  @override
  State<PosMenuList> createState() => _PosMenuListState();
}

class _PosMenuListState extends State<PosMenuList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: widget.menuItems.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount, // Mengakses crossAxisCount dengan widget.
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 12.0,
          childAspectRatio: 1.8,
        ),
        itemBuilder: (context, index) {
          final item = widget.menuItems[index];
          return GestureDetector(
            onTap: () {
              widget.addToCart(item);
            }, // Memastikan fungsi addToCart tersedia
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
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item["name"],
                                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4.0),
                              RichText(
                                text: TextSpan(
                                  text: "Tersedia: ",
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                  children: [
                                    TextSpan(
                                      text: item["availability"].toString(),
                                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              PoppinsBold(
                                text: "Rp ${widget.format(item["price"].toString())}", // Menggunakan widget.format untuk formatting harga
                                size: 16.0,
                                color: Color(0xffE7772D),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8.0),
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
                      border: Border.all(color: Color(0xffE7772D), width: 3),
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
    );
  }
}

class PostMenuSideBarDetail extends StatefulWidget {
  final int crossAxisCount;
  final List<Map<String, dynamic>> cartItems;
  final void Function(String itemName) removeFromCart;
  final String Function(String value) format;
  final int Function() getTotalPrice;
  final int Function() getTotalItem;
  final void Function(int count) setCrossAxisCount;
  final void Function() clearCart;

  const PostMenuSideBarDetail({
    super.key,
    required this.crossAxisCount,
    required this.cartItems,
    required this.removeFromCart,
    required this.format,
    required this.getTotalItem,
    required this.getTotalPrice,
    required this.setCrossAxisCount,
    required this.clearCart,
  });

  @override
  State<PostMenuSideBarDetail> createState() => _PostMenuSideBarDetailState();
}

class _PostMenuSideBarDetailState extends State<PostMenuSideBarDetail> {
  int _paymentAmount = 0;
  String _paymentMethod = "";
  Color _paymentMethodColorCash = Colors.white;
  Color _paymentMethodColorQris = Colors.white;

  void _showErrorNeedSelectPaymentMethod() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Container(
            padding: EdgeInsets.only(top: 20.0),
            height: 110.0,
            child: Column(
              children: [
                Poppins(text: "Harap pilih method pembayaran terlebih dahulu!", size: 16.0),
                SizedBox(height: 10.0),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Poppins(text: "OK", size: 14.0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCheckoutPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            int totalPrice = widget.getTotalPrice();
            int change = _paymentAmount - totalPrice;
            return AlertDialog(
              backgroundColor: Colors.transparent,
              content: IntrinsicHeight(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 50.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            width: 500.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 20.0),
                                  alignment: Alignment.center,
                                  child: PoppinsBold(text: "Checkout", size: 16.0, color: Color(0xff723E29)),
                                ),
                                Container(
                                  height: MediaQuery.of(context).viewInsets.bottom == 0 ? 200.0 : 0.0,
                                  child: Scrollbar(
                                    child: ListView(
                                      children: [
                                        ...widget.cartItems.map((item) => ListTile(
                                            title: Row(
                                              children: [
                                                Poppins(text: item["name"], size: 14.0),
                                                SizedBox(width: 10.0),
                                                Poppins(text: "x ${item["quantity"]}", size: 12.0, color: Colors.grey.shade600)
                                              ],
                                            ),
                                            trailing: PoppinsBold(
                                                text:
                                                    "Rp ${widget.format((int.parse(item["price"].toString()) * int.parse(item["quantity"].toString())).toString())}",
                                                size: 16.0))),
                                      ],
                                    ),
                                  ),
                                ),
                                Dash(
                                  direction: Axis.horizontal,
                                  length: 460.0,
                                  dashLength: 5,
                                  dashColor: Colors.black12,
                                ),
                                Container(
                                  height: MediaQuery.of(context).viewInsets.bottom == 0 ? 270.0 : 160.0,
                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                                  child: ListView(
                                    children: [
                                      SizedBox(height: 10.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          PoppinsBold(text: "Total: ", size: 20.0),
                                          GradientText(
                                              text: "Rp ${widget.format(totalPrice.toString())}",
                                              style: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                      SizedBox(height: 10.0),
                                      TextField(
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(50.0),
                                          ),
                                          hintText: "Masukan nominal bayar",
                                          hintStyle: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.normal),
                                          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          setState(() {
                                            _paymentAmount = int.tryParse(value) ?? 0;
                                          });
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Poppins(text: "Total Kembalian:", size: 12.0),
                                          SizedBox(width: 10.0),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.black12,
                                                    style: BorderStyle.solid,
                                                  ),
                                                ),
                                              ),
                                              child: GradientText(
                                                text: "Rp ${widget.format(change < 0 ? '0' : change.toString())}",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.0),
                                      Dash(
                                        direction: Axis.horizontal,
                                        length: 460.0,
                                        dashLength: 5,
                                        dashColor: Colors.black12,
                                      ),
                                      SizedBox(height: 2.0),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(400.0, 50.0),
                                          backgroundColor: Color(0xff723E29),
                                          elevation: 0.0,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Poppins(text: "Bayar", size: 16.0, color: Colors.white),
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            elevation: 0.0,
                                          ),
                                          onPressed: () {
                                            change = 0;
                                            Navigator.pop(context);
                                          },
                                          child: Poppins(
                                            text: "Batalkan transaksi",
                                            size: 16.0,
                                            color: Colors.red,
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          StackCloseButton(
                            onPressed: () {
                              change = 0;
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      child: CircleAvatar(
                        radius: 55.0,
                        backgroundColor: Color(0xffE7772D),
                        child: CircleAvatar(
                          radius: 52.0,
                          backgroundColor: Colors.white,
                          child: SvgPicture.asset("assets/images/logo_black.svg", width: 90.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showBarcodePopup({required int total}) {
    showDialog(
      context: context,
      builder: (context) {
        return BarcodePopupDialog(
          targetTime: DateTime(2025, 02, 09, 17, 59), // Waktu target
          total: total,
        );
      },
    );
  } // SET BARCODE

  void _confirmCloseSideDetail() {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          onPressed: () {
            setState(() {
              widget.setCrossAxisCount(5);
              widget.clearCart();
            });
          },
          text: "Apakah kamu yakin akan menghapus detail pesanan ini?",
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery.of(context).size.width;
    return Padding(
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
                    _confirmCloseSideDetail();
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
              height: MediaQuery.of(context).viewInsets.bottom == 0 ? 90.0 : 40.0,
              child: ListView(
                children: [
                  Poppins(text: "Form data", size: 14.0),
                  SizedBox(height: 10.0),
                  TextInputCustom(
                    text: "Nama Pelanggan",
                    height: 40.0,
                  ),
                  SizedBox(height: 10.0),
                  Divider(height: 1.0, color: Colors.grey.shade200),
                ],
              ),
            ),
            KeyboardVisibilityBuilder(builder: (context, visible) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: visible ? 0.0 : 250.0,
                child: ListView.builder(
                  itemCount: widget.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.cartItems[index];
                    return Column(
                      children: [
                        Row(
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
                            Flexible(
                              fit: FlexFit.tight,
                              child: ListTile(
                                contentPadding: EdgeInsets.zero, // Menghapus padding bawaan ListTile
                                title: Text(item["name"]),
                                subtitle: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove_circle_outline),
                                      onPressed: () {
                                        if (item["quantity"] == 1) {
                                          widget.removeFromCart(item["name"]);
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
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    GradientText(
                                      text: "Rp ${widget.format(item["price"].toString())}",
                                      style: GoogleFonts.poppins(fontSize: 12.0),
                                    ),
                                    GradientText(
                                      text:
                                          "Rp ${widget.format((int.parse(item["price"].toString()) * int.parse(item["quantity"].toString())).toString())}",
                                      style: GoogleFonts.poppins(fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 1.0, color: Colors.grey.shade200),
                      ],
                    );
                  },
                ),
              );
            }),
            Divider(),
            KeyboardVisibilityBuilder(builder: (context, visible) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: visible ? 30.0 : 180.0,
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Poppins(text: "Total: ", size: 18.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Poppins(text: "${widget.getTotalItem()} Pcs", size: 12.0),
                            SizedBox(width: 5.0),
                            Poppins(text: "-", size: 12.0),
                            SizedBox(width: 5.0),
                            GradientText(
                              text: "Rp ${widget.format(widget.getTotalPrice().toString())}",
                              style: GoogleFonts.poppins(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Poppins(text: "Pilih pembayaran", size: 16.0),
                    SizedBox(height: 4.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2.0, color: Colors.grey.shade200, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Row(
                        children: [
                          IconBoxText(
                            "Cash",
                            12.0,
                            color: _paymentMethod == "cash" ? Colors.white : Colors.grey.shade600,
                            boxColor: _paymentMethodColorCash,
                            onPresses: () {
                              setState(() {
                                _paymentMethodColorCash = Colors.blue;
                                _paymentMethodColorQris = Colors.white;
                                _paymentMethod = "cash";
                                print(_paymentMethod);
                              });
                            },
                            height: 45.0,
                            icon: SvgPicture.asset(
                              "assets/images/icons/payments.svg",
                              colorFilter: ColorFilter.mode(_paymentMethod == "cash" ? Colors.white : Colors.grey.shade600, BlendMode.srcIn),
                            ),
                          ),
                          SizedBox(width: 5.0),
                          IconBoxText(
                            "QRIS",
                            12.0,
                            color: _paymentMethod == "qris" ? Colors.white : Colors.grey.shade600,
                            boxColor: _paymentMethodColorQris,
                            onPresses: () {
                              setState(() {
                                _paymentMethodColorCash = Colors.white;
                                _paymentMethodColorQris = Colors.blue;
                                _paymentMethod = "qris";
                                print(_paymentMethod);
                              });
                            },
                            height: 45.0,
                            icon: SvgPicture.asset(
                              "assets/images/icons/barcode.svg",
                              colorFilter: ColorFilter.mode(_paymentMethod == "qris" ? Colors.white : Colors.grey.shade600, BlendMode.srcIn),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        IconBoxText(
                          "Bayar nanti",
                          12.0,
                          height: 40.0,
                          color: Colors.white,
                          boxColor: Color(0xffE7772D),
                          icon: SvgPicture.asset(
                            "assets/images/icons/paylater.svg",
                            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                        ),
                        IconBoxText(
                          "Checkout",
                          12.0,
                          onPresses: () {
                            if (_paymentMethod == "") {
                              _showErrorNeedSelectPaymentMethod();
                            } else {
                              _paymentMethod == "cash" ? _showCheckoutPopup() : _showBarcodePopup(total: widget.getTotalPrice());
                            }
                          },
                          height: 40.0,
                          color: Colors.white,
                          boxColor: Color(0xff723E29),
                          icon: SvgPicture.asset(
                            "assets/images/icons/cart.svg",
                            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class BarcodePopupDialog extends StatefulWidget {
  final DateTime targetTime;
  final int total;

  const BarcodePopupDialog({Key? key, required this.targetTime, required this.total}) : super(key: key);

  @override
  _BarcodePopupDialogState createState() => _BarcodePopupDialogState();
}

class _BarcodePopupDialogState extends State<BarcodePopupDialog> {
  late int remainingSeconds;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.targetTime.difference(DateTime.now()).inSeconds;

    // Mulai countdown hanya jika waktunya masih berjalan
    if (remainingSeconds > 0) {
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
        if (remainingSeconds > 0) {
          setState(() {
            remainingSeconds--;
          });
        } else {
          t.cancel();
        }
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel(); // Hentikan timer saat dialog ditutup
    super.dispose();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  static String format(String value) {
    final formatter = NumberFormat("###,###", "id_ID");
    return formatter.format(int.tryParse(value) ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery.of(context).size.width;

    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: IntrinsicHeight(
        child: Container(
          width: 600.0,
          padding: EdgeInsets.only(top: 20.0),
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
          child: Stack(
            children: [
              StackCloseButton(onPressed: () {
                timer?.cancel();
                Navigator.pop(context);
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Poppins(
                              text: "Selesaikan transaksi sebelum",
                              size: 14.0,
                              color: Color(0xff464646),
                            ),
                            SizedBox(height: 5.0),
                            PoppinsBold(
                              text:
                                  "${widget.targetTime.day} Oktober ${widget.targetTime.year}, ${widget.targetTime.hour}:${widget.targetTime.minute.toString().padLeft(2, '0')}",
                              size: 20.0,
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 100.0),
                          child: Column(
                            children: [
                              Poppins(
                                text: "Waktu tersisa",
                                size: 12.0,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(height: 5.0),
                              PoppinsBold(
                                text: formatTime(remainingSeconds),
                                size: 20.0,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 100.0),
                      width: widthDevice,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFF459CFF),
                            Color(0xFF295FFE),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: widthDevice,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/images/icons/qris.svg",
                                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                  width: 50.0,
                                ),
                                SizedBox(height: 10.0),
                                Poppins(text: "Kasir Pinter Indonesia", size: 24.0, color: Colors.white),
                                SizedBox(height: 10.0),
                                Poppins(text: "RAWKODADIWJAIEAE", size: 16.0, color: Colors.white),
                                SizedBox(height: 10.0),
                                Container(
                                  padding: EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Image.asset("assets/images/qr.png"),
                                ),
                                SizedBox(height: 10.0),
                                ElevateButtonCustom(
                                  text: "Check",
                                  size: 16.0,
                                  boxSize: 280.0,
                                  bgColor: Colors.white,
                                  boxHeight: 40.0,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                child: Container(
                  width: 600.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  height: 100.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50.0, right: 50.0, top: 20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PoppinsBold(text: "Total", size: 24.0),
                            GradientText(
                              text: "Rp ${format(widget.total.toString())} ",
                              style: GoogleFonts.poppins(fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Dash(
                          direction: Axis.horizontal,
                          length: 500.0,
                          dashLength: 5,
                          dashColor: Colors.grey.shade600,
                        ),
                        Poppins(text: "Pastikan Nama dan nominal sama sebelum melakukan pembayaran", size: 12.0, color: Colors.red)
                      ],
                    ),
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
