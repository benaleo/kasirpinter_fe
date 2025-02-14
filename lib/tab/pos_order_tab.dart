import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kasirpinter_fe/services/transaction_service.dart';

import '../components/components.dart';
import '../components/pos_components.dart';

class PosOrderTab extends StatefulWidget {
  @override
  _PosOrderTabState createState() => _PosOrderTabState();
}

class _PosOrderTabState extends State<PosOrderTab> {
  late Future<List<Map<String, dynamic>>> futureTransactions;

  @override
  void initState() {
    super.initState();
    futureTransactions =
        TransactionService().getTransactions(paymentMethod: _paymentMethod, paymentStatus: _paymentStatus); // Panggil API saat widget diinisialisasi
  }

  List<Map<String, dynamic>> orders = [];

  Map<String, dynamic>? selectedOrder;
  String _paymentMethod = "";
  String _paymentStatus = "";

  // Fungsi untuk mendapatkan daftar pesanan yang difilter
  List<Map<String, dynamic>> getFilteredOrders() {
    return orders.where((order) {
      bool matchesPaymentStatus = _paymentStatus.isEmpty || order['payment_status'] == _paymentStatus;
      bool matchesPaymentMethod = _paymentMethod.isEmpty || order['payment_method'] == _paymentMethod;
      return matchesPaymentStatus && matchesPaymentMethod;
    }).toList();
  }

  void _closeSide() {
    setState(() {
      print("run the close side");
      selectedOrder = null;
    });
  }

  int getTotalItem() {
    return orders.fold(0, (total, item) {
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
                flex: selectedOrder == null ? 1 : 2, // TODO why not be null after closeSide
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                  child: Column(
                    children: [
                      PosMenuOrderTabs(),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          OrderFilterCategory(
                            text: "All",
                            onPressed: () {
                              setState(() {
                                _paymentMethod = "";
                                _paymentStatus = "";
                                futureTransactions =
                                    TransactionService().getTransactions(paymentMethod: _paymentMethod, paymentStatus: _paymentStatus);
                              });
                            },
                          ),
                          OrderFilterCategory(
                            text: "Lunas",
                            onPressed: () {
                              setState(() {
                                _paymentMethod = "";
                                _paymentStatus = "PAID";
                                futureTransactions =
                                    TransactionService().getTransactions(paymentMethod: _paymentMethod, paymentStatus: _paymentStatus);
                              });
                            },
                          ),
                          OrderFilterCategory(
                            text: "Nanti",
                            onPressed: () {
                              setState(() {
                                _paymentMethod = "";
                                _paymentStatus = "PENDING";
                                futureTransactions =
                                    TransactionService().getTransactions(paymentMethod: _paymentMethod, paymentStatus: _paymentStatus);
                              });
                            },
                          ),
                          OrderFilterCategory(
                            text: "Cash",
                            onPressed: () {
                              setState(() {
                                _paymentMethod = "CASH";
                                _paymentStatus = "";
                                futureTransactions =
                                    TransactionService().getTransactions(paymentMethod: _paymentMethod, paymentStatus: _paymentStatus);
                              });
                            },
                          ),
                          OrderFilterCategory(
                            text: "QRIS",
                            onPressed: () {
                              setState(() {
                                _paymentMethod = "QRIS";
                                _paymentStatus = "";
                                futureTransactions =
                                    TransactionService().getTransactions(paymentMethod: _paymentMethod, paymentStatus: _paymentStatus);
                              });
                            },
                          ),
                        ],
                      ),
                      KeyboardVisibilityBuilder(builder: (context, visible) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: visible ? 170.0 : 500.0,
                          child: FutureBuilder<List<Map<String, dynamic>>>(
                            future: futureTransactions,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                // Safely cast the data to List<Map<String, dynamic>>
                                orders = List<Map<String, dynamic>>.from(snapshot.data!);
                                return ListView(
                                  children: getFilteredOrders().map((order) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedOrder = order;
                                        });
                                      },
                                      child: Card(
                                        color: order['payment_status'] == 'Lunas' ? Colors.white : Colors.grey[300],
                                        child: ListTile(
                                          title: Text('No. Pesanan: ${order['order_no']}'),
                                          subtitle: Text('Nama: ${order['customer']}\nTotal: Rp. ${order['total_price']}'),
                                          trailing: Chip(
                                            label: Text(order['payment_status']),
                                            backgroundColor: order['payment_status'] == 'Lunas' ? Colors.green : Colors.red,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }

                              return Center(child: CircularProgressIndicator());
                            },
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ),
              if (selectedOrder != null)
                Expanded(
                  child: PosOrderSideBarDetail(
                    cartItems: List<Map<String, dynamic>>.from(selectedOrder!['details']),
                    format: format,
                    getTotalItem: getTotalItem,
                    close: _closeSide,
                    customerName: selectedOrder!['customer'],
                    status: selectedOrder!['payment_status'],
                    transactionId: selectedOrder!['transaction_id'],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderFilterCategory extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const OrderFilterCategory({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

class PosOrderSideBarDetail extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final String Function(String value) format;
  final int Function() getTotalItem;
  final void Function() close;
  final String customerName;
  final String status;
  final String transactionId;

  const PosOrderSideBarDetail({
    super.key,
    required this.cartItems,
    required this.format,
    required this.getTotalItem,
    required this.close,
    required this.customerName,
    required this.status,
    required this.transactionId,
  });

  @override
  State<PosOrderSideBarDetail> createState() => _PosOrderSideBarDetailState();
}

class _PosOrderSideBarDetailState extends State<PosOrderSideBarDetail> {
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

  void _showCheckoutPopup({required int totalPrice, required String transactionId}) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            int change = _paymentAmount - totalPrice;
            return ShowCheckoutPopupDialog(
              totalPrice: totalPrice,
              format: widget.format,
              cartItems: widget.cartItems,
              paymentAmount: _paymentAmount,
              paymentMethod: _paymentMethod,
              change: change,
              customerName: widget.customerName,
              isCreateTransaction: false,
              transactionId: transactionId,
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

  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery.of(context).size.width;
    List<Map<String, dynamic>> cartItems = widget.cartItems ?? [];
    int totalPrice = widget.cartItems.fold(0, (sum, item) {
      int price = int.tryParse(item["price"].toString()) ?? 0;
      int quantity = item["quantity"] ?? 1;
      return sum + (price * quantity);
    });
    String status = widget.status;

    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Container(
        width: 400.0,
        decoration: BoxDecoration(
          color: status != "Lunas" ? Colors.white : Colors.grey.shade200,
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
                      widget.close(); // TODO run the close side
                    });
                    ;
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(width: 1.0, style: BorderStyle.solid, color: Colors.grey.shade600),
                    ),
                    child: widget.customerName == null ? null : Poppins(text: widget.customerName, size: 16.0),
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
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
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
                                backgroundImage: NetworkImage(item["image"]),
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
                                    Text("x ${item["quantity"]}"),
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
            Spacer(),
            Divider(),
            if (status != "PAID")
              KeyboardVisibilityBuilder(
                builder: (context, visible) {
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
                                  text: "Rp ${widget.format(totalPrice.toString())}",
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
                              "Checkout",
                              12.0,
                              onPresses: () {
                                if (_paymentMethod == "") {
                                  _showErrorNeedSelectPaymentMethod();
                                } else {
                                  _paymentMethod == "cash"
                                      ? _showCheckoutPopup(totalPrice: totalPrice, transactionId: widget.transactionId)
                                      : _showBarcodePopup(total: totalPrice);
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
                },
              ),
            if (status != "PENDING")
              KeyboardVisibilityBuilder(
                builder: (context, visible) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: visible ? 30.0 : 80.0,
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
                                  text: "Rp ${widget.format(totalPrice.toString())}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: [
                            IconBoxText(
                              "Print Bukti Pembayaran",
                              12.0,
                              onPresses: () {
                                print("printed struck");
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
                },
              ),
          ],
        ),
      ),
    );
  }
}
