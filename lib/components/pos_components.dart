import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kasirpinter_fe/services/menu_service.dart';

import '../services/transaction_service.dart';
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
      currentRoute = ModalRoute
          .of(context)
          ?.settings
          .name;
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
  final Function(String?) onCategorySelected;

  RowListCategoryMenu({required this.onCategorySelected});

  @override
  _RowListCategoryMenuState createState() => _RowListCategoryMenuState();
}

class _RowListCategoryMenuState extends State<RowListCategoryMenu> {
  late Future<List<Map<String, dynamic>>> categories;

  // Variabel untuk melacak indeks tombol yang aktif
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch data dari API atau layanan lainnya
    categories = MenuService().getSavedMenuCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: categories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Tampilkan loading indicator saat data sedang di-fetch
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Tampilkan pesan error jika terjadi kesalahan
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Tampilkan pesan jika tidak ada data
          return Center(child: Text('No categories available.'));
        } else {
          // Gunakan data yang berhasil di-fetch
          final List<Map<String, dynamic>> fetchedCategories = snapshot.data!;
          final List<String> categoryNames =
          fetchedCategories.map((category) => (category['name'] as String)).map((name) => name[0].toUpperCase() + name.substring(1)).toList();

          return Container(
            height: 30.0, // Tinggi tetap untuk ListView horizontal
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoryNames.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Update indeks tombol yang aktif
                      setState(() {
                        _selectedIndex = index;
                        widget.onCategorySelected(categoryNames[index]);
                        print("clicked category is : ${categoryNames[index]}");
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
                    child: Text(categoryNames[index]),
                  ),
                );
              },
            ),
          );
        }
      },
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
  final Future<List<Map<String, dynamic>>> menuItems;
  final int crossAxisCount;
  final String Function(String value) format;
  final void Function(Map<String, dynamic> item) addToCart;
  final bool? isMobile;

  const PosMenuList({
    super.key,
    required this.crossAxisCount,
    required this.format,
    required this.addToCart,
    required this.menuItems,
    this.isMobile,
  });

  @override
  State<PosMenuList> createState() => _PosMenuListState();
}

class _PosMenuListState extends State<PosMenuList> {
  late Future<List<Map<String, dynamic>>> _futureMenuItems;

  @override
  void initState() {
    super.initState();
    _futureMenuItems = widget.menuItems;
  }

  @override
  void didUpdateWidget(PosMenuList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.menuItems != oldWidget.menuItems) {
      _futureMenuItems = widget.menuItems; // Perbarui Future jika prop berubah
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: widget.menuItems, // Gunakan widget.menuItems langsung
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No menu items available.'));
          } else {
            final List<Map<String, dynamic>> items = snapshot.data!;
            return GridView.builder(
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 12.0,
                childAspectRatio: 1.8,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () => widget.addToCart(item),
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
                                            text: item["stock"].toString(),
                                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    PoppinsBold(
                                      text: "Rp ${widget.format(item["price"].toString())}",
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
                        top: 18.0,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xffE7772D), width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage:
                            AssetImage('assets/images/empty.png'),
                            backgroundColor: Colors.transparent,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage:
                              item["image"] == null ? AssetImage('assets/images/empty.png') as ImageProvider : NetworkImage(item["image"]),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
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
  final bool? isMobile;

  const PostMenuSideBarDetail({
    super.key,
    required this.crossAxisCount,
    required this.cartItems,
    required this.removeFromCart,
    required this.format,
    required this.getTotalItem,
    required this.getTotalPrice,
    required this.setCrossAxisCount,
    required this.clearCart, this.isMobile,
  });

  @override
  State<PostMenuSideBarDetail> createState() => _PostMenuSideBarDetailState();
}

class _PostMenuSideBarDetailState extends State<PostMenuSideBarDetail> {
  final TextEditingController _customerName = TextEditingController();
  late BuildContext _stableContext;
  bool _isMounted = false;
  int _paymentAmount = 0;
  String _paymentMethod = "";
  Color _paymentMethodColorCash = Colors.white;
  Color _paymentMethodColorQris = Colors.white;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stableContext = context;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  void _showErrorNeedSelectPaymentMethod(String text) {
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
                Poppins(text: text, size: 16.0),
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
            return ShowCheckoutPopupDialog(
              totalPrice: totalPrice,
              format: widget.format,
              cartItems: widget.cartItems,
              paymentAmount: _paymentAmount,
              paymentMethod: _paymentMethod,
              change: change,
              customerName: _customerName.text,
              isCreateTransaction: true,
              transactionId: "0",
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
  }

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

  Future<void> _confirmPendingOrderPopup() async {
    showDialog(
      context: _stableContext,
      builder: (context) {
        return ConfirmDialog(
          onPressed: () async {
            final items = widget.cartItems
                .map((item) =>
            {
              "productId": item["id"],
              "quantity": item["quantity"],
            })
                .toList();
            final totalPrice = widget.cartItems.fold<int>(
              0,
                  (sum, item) => sum + ((item["price"] as int) * (item["quantity"] as int)),
            );
            if (totalPrice <= 0) {
              print('Invalid total price: $totalPrice');
              return;
            }

            try {
              final transactionService = TransactionService();
              final response = await transactionService.createTransaction(
                _customerName.text,
                0,
                (_paymentMethod.isNotEmpty ? _paymentMethod : 'CASH').toUpperCase(),
                'PENDING',
                items: items,
              );

              print('Transaction response: $response');

              if (response == null || response['success'] != true) {
                throw Exception(response?['message'] ?? 'Transaction failed');
              }

              if (mounted) {
                Navigator.pop(_stableContext);
                Navigator.pushReplacementNamed(_stableContext, '/pos-menu');
                print('Transaction created successfully: ${response['data']}');

                Fluttertoast.showToast(
                  msg: "Simpan transaksi berhasil!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            } catch (e) {
              print('Full error details: $e');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_isMounted) {
                  showDialog(
                    context: _stableContext,
                    builder: (ctx) =>
                        AlertDialog(
                          title: Text('Transaction Failed'),
                          content: Text(e.toString()),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                  );
                }
              });
            }
          },
          text: "Apakah kamu yakin untuk melakukan order nanti?",
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery
        .of(context)
        .size
        .width;
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Container(
        width: 300.0,
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
              height: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom == 0 ? 90.0 : 40.0,
              child: ListView(
                children: [
                  Poppins(text: "Form data", size: 14.0),
                  SizedBox(height: 10.0),
                  TextInputCustom(
                    controller: _customerName,
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
                                backgroundImage: item["image"] == null ? AssetImage('assets/images/empty.png') : NetworkImage(item["image"]),
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
                                      "Rp ${widget.format(
                                          (int.parse(item["price"].toString()) * int.parse(item["quantity"].toString())).toString())}",
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
                          onPresses: () {
                            if (_customerName.text == "") {
                              _showErrorNeedSelectPaymentMethod("Harap pilih masukan nama pelanggan terlebih dahulu!");
                            } else {
                              _confirmPendingOrderPopup();
                            }
                          },
                        ),
                        IconBoxText(
                          "Checkout",
                          12.0,
                          onPresses: () {
                            if (_paymentMethod == "") {
                              _showErrorNeedSelectPaymentMethod("Harap pilih method pembayaran terlebih dahulu!");
                            } else if (_customerName.text == "") {
                              _showErrorNeedSelectPaymentMethod("Harap pilih masukan nama pelanggan terlebih dahulu!");
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
    remainingSeconds = widget.targetTime
        .difference(DateTime.now())
        .inSeconds;

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
    double widthDevice = MediaQuery
        .of(context)
        .size
        .width;

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
                              "${widget.targetTime.day} Oktober ${widget.targetTime.year}, ${widget.targetTime.hour}:${widget.targetTime.minute
                                  .toString().padLeft(2, '0')}",
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
                                ElevatedButtonCustom(
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

class ShowCheckoutPopupDialog extends StatefulWidget {
  final int totalPrice;
  final List<Map<String, dynamic>> cartItems;
  final String Function(String value) format;
  final int paymentAmount;
  final String paymentMethod;
  final int change;
  final String customerName;
  final String transactionId;
  final bool isCreateTransaction;

  const ShowCheckoutPopupDialog({
    super.key,
    required this.totalPrice,
    required this.format,
    required this.cartItems,
    required this.paymentMethod,
    required this.change,
    required this.paymentAmount,
    required this.customerName,
    required this.isCreateTransaction,
    required this.transactionId,
  });

  @override
  State<ShowCheckoutPopupDialog> createState() => _ShowCheckoutPopupDialogState();
}

class _ShowCheckoutPopupDialogState extends State<ShowCheckoutPopupDialog> {
  int _paymentAmount = 0;
  int _change = 0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
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
                          height: MediaQuery
                              .of(context)
                              .viewInsets
                              .bottom == 0 ? 200.0 : 0.0,
                          child: Scrollbar(
                            child: ListView(
                              children: [
                                ...widget.cartItems.map((item) =>
                                    ListTile(
                                        title: Row(
                                          children: [
                                            Poppins(text: item["name"], size: 14.0),
                                            SizedBox(width: 10.0),
                                            Poppins(text: "x ${item["quantity"]}", size: 12.0, color: Colors.grey.shade600)
                                          ],
                                        ),
                                        trailing: PoppinsBold(
                                            text:
                                            "Rp ${widget.format(
                                                (int.parse(item["price"].toString()) * int.parse(item["quantity"].toString())).toString())}",
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
                          height: MediaQuery
                              .of(context)
                              .viewInsets
                              .bottom == 0 ? 270.0 : 160.0,
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                          child: ListView(
                            children: [
                              SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  PoppinsBold(text: "Total: ", size: 20.0),
                                  GradientText(
                                      text: "Rp ${widget.format(widget.totalPrice.toString())}",
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
                                    _change = _paymentAmount - widget.totalPrice;
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
                                        text: "Rp ${widget.format(_change < 0 ? '0' : _change.toString())}",
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
                                  backgroundColor: (_paymentAmount >= widget.totalPrice || _isLoading) ? Color(0xff723E29) : Colors.grey.shade600,
                                  elevation: 0.0,
                                ),
                                onPressed: _isLoading
                                    ? null
                                    : () async {
                                  if (_paymentAmount >= widget.totalPrice) {
                                    setState(() {
                                      _isLoading = true; // Set loading state to true
                                    });

                                    // Prepare transaction data
                                    final customerName = widget.customerName; // Replace with actual customer name from input
                                    final typePayment = "CASH"; // CASH or QRIS
                                    final status = "PAID"; // Default status
                                    final items = widget.cartItems
                                        .map((item) =>
                                    {
                                      "productId": item["id"], // Assuming each item has an "id"
                                      "quantity": item["quantity"],
                                    })
                                        .toList();
                                    final transactionId = widget.transactionId;

                                    // Call TransactionService to create the transaction
                                    try {
                                      final transactionService = TransactionService();
                                      final response;
                                      if (widget.isCreateTransaction) {
                                        response = await transactionService.createTransaction(
                                          customerName,
                                          _paymentAmount,
                                          typePayment,
                                          status,
                                          items: items,
                                        );
                                      } else {
                                        response = await transactionService.updateTransaction(
                                          transactionId,
                                          customerName,
                                          _paymentAmount,
                                          typePayment,
                                          status,
                                          items: items,
                                        );
                                      }

                                      print("Transaction created: $response");

                                      // Close the dialog and show success message
                                      Navigator.of(context).pushNamed("/pos-menu");

                                      // add toas
                                      Fluttertoast.showToast(
                                        msg: "Transaksi berhasil!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    } catch (e) {
                                      print("Error creating transaction: $e");
                                      Fluttertoast.showToast(
                                        msg: "Transaksi gagal!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.orange,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    } finally {
                                      setState(() {
                                        _isLoading = false; // Set loading state to false after transaction
                                      });
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "Transaksi gagal!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.orange,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  }
                                },
                                child: _isLoading ? CircularProgressIndicator() : Poppins(text: "Bayar", size: 16.0, color: Colors.white),
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0.0,
                                  ),
                                  onPressed: () {
                                    _change = 0;
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
                      _change = 0;
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
  }
}
