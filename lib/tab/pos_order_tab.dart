import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kasirpinter_fe/services/transaction_service.dart';
import 'package:flutter/scheduler.dart';

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
    futureTransactions = TransactionService().getTransactions(
        paymentMethod: _paymentMethod,
        paymentStatus:
            _paymentStatus); // Panggil API saat widget diinisialisasi
  }

  List<Map<String, dynamic>> orders = [];

  Map<String, dynamic>? selectedOrder;
  String _paymentMethod = "";
  String _paymentStatus = "";
  int _selectedFilterIndex = -1;

  // Fungsi untuk mendapatkan daftar pesanan yang difilter
  List<Map<String, dynamic>> getFilteredOrders() {
    return orders.where((order) {
      bool matchesPaymentStatus =
          _paymentStatus.isEmpty || order['payment_status'] == _paymentStatus;
      bool matchesPaymentMethod =
          _paymentMethod.isEmpty || order['payment_method'] == _paymentMethod;
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

  int getTotalPrice(Map<String, dynamic> order) {
    return (order['details'] as List<dynamic>).fold(0, (subtotal, item) {
      int price = item['price'] ?? 0;
      int quantity = item['quantity'] ?? 1;
      return subtotal + (price * quantity);
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
                flex: selectedOrder == null ? 1 : 2,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                                _selectedFilterIndex = 0;
                                futureTransactions = TransactionService()
                                    .getTransactions(
                                        paymentMethod: _paymentMethod,
                                        paymentStatus: _paymentStatus);
                              });
                            },
                            isActive: _selectedFilterIndex == 0,
                          ),
                          OrderFilterCategory(
                            text: "Lunas",
                            onPressed: () {
                              setState(() {
                                _paymentMethod = "";
                                _paymentStatus = "PAID";
                                _selectedFilterIndex = 1;
                                futureTransactions = TransactionService()
                                    .getTransactions(
                                        paymentMethod: _paymentMethod,
                                        paymentStatus: _paymentStatus);
                              });
                            },
                            isActive: _selectedFilterIndex == 1,
                          ),
                          OrderFilterCategory(
                            text: "Nanti",
                            onPressed: () {
                              setState(() {
                                _paymentMethod = "";
                                _paymentStatus = "PENDING";
                                _selectedFilterIndex = 2;
                                futureTransactions = TransactionService()
                                    .getTransactions(
                                        paymentMethod: _paymentMethod,
                                        paymentStatus: _paymentStatus);
                              });
                            },
                            isActive: _selectedFilterIndex == 2,
                          ),
                          OrderFilterCategory(
                            text: "Batal",
                            onPressed: () {
                              setState(() {
                                _paymentMethod = "";
                                _paymentStatus = "CANCELLED";
                                _selectedFilterIndex = 3;
                                futureTransactions = TransactionService()
                                    .getTransactions(
                                        paymentMethod: _paymentMethod,
                                        paymentStatus: _paymentStatus);
                              });
                            },
                            isActive: _selectedFilterIndex == 3,
                          ),
                          OrderFilterCategory(
                            text: "Cash",
                            onPressed: () {
                              setState(() {
                                _paymentMethod = "CASH";
                                _paymentStatus = "";
                                _selectedFilterIndex = 4;
                                futureTransactions = TransactionService()
                                    .getTransactions(
                                        paymentMethod: _paymentMethod,
                                        paymentStatus: _paymentStatus);
                              });
                            },
                            isActive: _selectedFilterIndex == 4,
                          ),
                          OrderFilterCategory(
                            text: "QRIS",
                            onPressed: () {
                              setState(() {
                                _paymentMethod = "QRIS";
                                _paymentStatus = "";
                                _selectedFilterIndex = 5;
                                futureTransactions = TransactionService()
                                    .getTransactions(
                                        paymentMethod: _paymentMethod,
                                        paymentStatus: _paymentStatus);
                              });
                            },
                            isActive: _selectedFilterIndex == 5,
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
                                if (snapshot.data!.isEmpty) {
                                  return Center(
                                      child: Text('No orders available.'));
                                }
                                // Safely cast the data to List<Map<String, dynamic>>
                                orders = List<Map<String, dynamic>>.from(
                                    snapshot.data!);
                                return ListView(
                                  children: getFilteredOrders().map((order) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedOrder = order;
                                        });
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: BorderSide(
                                            color: Color(0xffE7772D),
                                          ),
                                        ),
                                        color: order['payment_status'] ==
                                                'CANCELLED'
                                            ? Colors.red[50]
                                            : Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                            vertical: 10.0,
                                          ),
                                          child: ListTile(
                                            subtitle: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    spacing: 10.0,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Poppins(
                                                            text:
                                                                'No. Pesanan: ',
                                                            size: 12,
                                                            color: Colors
                                                                .grey.shade600,
                                                          ),
                                                          PoppinsBold(
                                                            text:
                                                                '${order['order_no']}',
                                                            size: 14,
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Poppins(
                                                            text:
                                                                'Nama pelanggan: ',
                                                            size: 12,
                                                            color: Colors
                                                                .grey.shade600,
                                                          ),
                                                          PoppinsBold(
                                                            text:
                                                                '${order['customer']}',
                                                            size: 14,
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Poppins(
                                                            text: 'Jml item: ',
                                                            size: 12,
                                                            color: Colors
                                                                .grey.shade600,
                                                          ),
                                                          PoppinsBold(
                                                            text: (order[
                                                                        'details']
                                                                    as List<
                                                                        dynamic>)
                                                                .map<int>((item) =>
                                                                    (item['quantity']
                                                                            as int? ??
                                                                        0)) // Ensure int type and default to 0 if null
                                                                .fold<int>(
                                                                    0,
                                                                    (sum, quantity) =>
                                                                        sum +
                                                                        quantity) // Sum all quantities
                                                                .toString(),
                                                            size: 14,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 150.0,
                                                  child: Column(
                                                    spacing: 5.0,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        spacing: 4.0,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Center(
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10.0,
                                                                      vertical:
                                                                          5.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: order[
                                                                            'payment_status'] ==
                                                                        "PAID"
                                                                    ? Color(
                                                                        0xffE7772D)
                                                                    : (order['payment_status'] ==
                                                                            "PENDING"
                                                                        ? Colors
                                                                            .transparent
                                                                        : Colors
                                                                            .red),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                border: order[
                                                                            'payment_status'] ==
                                                                        "PENDING"
                                                                    ? Border.all(
                                                                        color: Color(
                                                                            0xffE7772D),
                                                                        width:
                                                                            2.0)
                                                                    : (order['payment_status'] ==
                                                                            "PAID"
                                                                        ? Border.all(
                                                                            color: Color(
                                                                                0xffE7772D),
                                                                            width:
                                                                                2.0)
                                                                        : Border.all(
                                                                            color:
                                                                                Colors.red,
                                                                            width: 2.0)),
                                                              ),
                                                              child: Poppins(
                                                                  text: order['payment_status'] ==
                                                                          "PAID"
                                                                      ? "Lunas"
                                                                      : (order['payment_status'] ==
                                                                              "PENDING"
                                                                          ? "Nanti"
                                                                          : "Batal"),
                                                                  size: 12,
                                                                  color: order[
                                                                              'payment_status'] ==
                                                                          "PENDING"
                                                                      ? Color(
                                                                          0xffE7772D)
                                                                      : Colors
                                                                          .white),
                                                            ),
                                                          ),
                                                          if (order[
                                                                  'payment_status'] ==
                                                              'PAID')
                                                            Center(
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                  border: Border.all(
                                                                      color: Color(
                                                                          0XFF369AEC),
                                                                      width:
                                                                          1.0),
                                                                ),
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10.0,
                                                                        vertical:
                                                                            5.0),
                                                                child: Poppins(
                                                                    text: order[
                                                                        'payment_method'],
                                                                    size: 12,
                                                                    color: Color(
                                                                        0XFF369AEC)),
                                                              ),
                                                            )
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .schedule_outlined,
                                                              size: 20.0),
                                                          Poppins(
                                                            text: order['created_at'] ==
                                                                    null
                                                                ? "-"
                                                                : DateFormat(
                                                                        'dd-MM-yyyy HH:mm')
                                                                    .format(DateTime
                                                                        .parse(order[
                                                                            'created_at'])),
                                                            size: 14.0,
                                                            color: Colors
                                                                .grey.shade600,
                                                          ),
                                                        ],
                                                      ),
                                                      GradientText(
                                                        text:
                                                            "Rp. ${format(getTotalPrice(order).toString())}",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
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
                    cartItems: List<Map<String, dynamic>>.from(
                        selectedOrder!['details']),
                    format: format,
                    getTotalItem: getTotalItem,
                    close: _closeSide,
                    customerName: selectedOrder!['customer'],
                    status: selectedOrder!['payment_status'],
                    transactionId: selectedOrder!['transaction_id'],
                    invoice: selectedOrder!['order_no'],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderFilterCategory extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isActive;

  const OrderFilterCategory({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isActive,
  });

  @override
  _OrderFilterCategoryState createState() => _OrderFilterCategoryState();
}

class _OrderFilterCategoryState extends State<OrderFilterCategory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.0,
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.isActive
              ? Color(0xffE7772D) // Active color
              : Colors.grey.shade200, // Inactive color
          foregroundColor: widget.isActive
              ? Colors.white // Active text color
              : Colors.black, // Inactive text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0.0,
        ),
        child: Text(widget.text),
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
  final String invoice;

  const PosOrderSideBarDetail({
    super.key,
    required this.cartItems,
    required this.format,
    required this.getTotalItem,
    required this.close,
    required this.customerName,
    required this.status,
    required this.transactionId,
    required this.invoice,
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
                Poppins(
                    text: "Harap pilih method pembayaran terlebih dahulu!",
                    size: 16.0),
                SizedBox(height: 10.0),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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

  void _showCheckoutPopup(
      {required int totalPrice, required String transactionId}) {
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

  void _confirmCancelOrder({required String transactionId}) {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          onPressed: () async {
            final TransactionService transactionService = TransactionService();
            final response =
            await transactionService.cancelTransaction(transactionId);
            if (response['success']) {
              print("Berhasil membatalkan pesanan print toast");
              ToastCustom(
                "Berhasil membatalkan pesanan",
                Colors.green,
              );
              setState(() {
                // Update any necessary state variables
              });
            } else {
              print("Error: ${response['message']}");
            }
            Navigator.pop(context);
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushNamed("/pos-order");
          },
          text: "Apakah kamu yakin akan menghapus detail pesanan ini?",
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
                      widget.close();
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
                text: "Order id : ${widget.invoice.split('/').last}",
                size: 16.0,
                textAlign: TextAlign.end,
              ),
            ),
            SizedBox(height: 5.0),
            SizedBox(
              height:
                  MediaQuery.of(context).viewInsets.bottom == 0 ? 90.0 : 40.0,
              child: ListView(
                children: [
                  Poppins(text: "Form data", size: 14.0),
                  SizedBox(height: 10.0),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          width: 1.0,
                          style: BorderStyle.solid,
                          color: Colors.grey.shade600),
                    ),
                    child: widget.customerName == null
                        ? null
                        : Poppins(text: widget.customerName, size: 16.0),
                  ),
                  SizedBox(height: 10.0),
                  Divider(height: 1.0, color: Colors.grey.shade200),
                ],
              ),
            ),
            KeyboardVisibilityBuilder(builder: (context, visible) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: visible
                    ? 0.0
                    : (status == "PAID"
                        ? 355.0
                        : (status == "PENDING" ? 250.0 : 400.0)),
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
                                border: Border.all(
                                    color: Colors.grey.shade200, width: 2),
                              ),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(item["image"]),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: ListTile(
                                contentPadding: EdgeInsets
                                    .zero, // Menghapus padding bawaan ListTile
                                title: Text(item["name"]),
                                subtitle: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("x ${item["quantity"]}"),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    GradientText(
                                      text:
                                          "Rp ${widget.format(item["price"].toString())}",
                                      style:
                                          GoogleFonts.poppins(fontSize: 12.0),
                                    ),
                                    GradientText(
                                      text:
                                          "Rp ${widget.format((int.parse(item["price"].toString()) * int.parse(item["quantity"].toString())).toString())}",
                                      style:
                                          GoogleFonts.poppins(fontSize: 18.0),
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
            if (status == "PENDING")
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
                                Poppins(
                                    text: "${widget.getTotalItem()} Pcs",
                                    size: 12.0),
                                SizedBox(width: 5.0),
                                Poppins(text: "-", size: 12.0),
                                SizedBox(width: 5.0),
                                GradientText(
                                  text:
                                      "Rp ${widget.format(totalPrice.toString())}",
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 2.0,
                                color: Colors.grey.shade200,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Row(
                            children: [
                              IconBoxText(
                                "Cash",
                                12.0,
                                color: _paymentMethod == "cash"
                                    ? Colors.white
                                    : Colors.grey.shade600,
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
                                  colorFilter: ColorFilter.mode(
                                      _paymentMethod == "cash"
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                      BlendMode.srcIn),
                                ),
                              ),
                              SizedBox(width: 5.0),
                              IconBoxText(
                                "QRIS",
                                12.0,
                                color: _paymentMethod == "qris"
                                    ? Colors.white
                                    : Colors.grey.shade600,
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
                                  colorFilter: ColorFilter.mode(
                                      _paymentMethod == "qris"
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                      BlendMode.srcIn),
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
                                      ? _showCheckoutPopup(
                                          totalPrice: totalPrice,
                                          transactionId: widget.transactionId)
                                      : _showBarcodePopup(total: totalPrice);
                                }
                              },
                              height: 40.0,
                              color: Colors.white,
                              boxColor: Color(0xff723E29),
                              icon: SvgPicture.asset(
                                "assets/images/icons/cart.svg",
                                colorFilter: ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                              ),
                            ),
                            IconBoxText(
                              "Batalkan",
                              12.0,
                              onPresses: () {
                                _confirmCancelOrder(
                                    transactionId: widget.transactionId);
                              },
                              height: 40.0,
                              color: Colors.white,
                              boxColor: Colors.red.shade600,
                              icon: Icon(Icons.cancel_outlined,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            if (status == "PAID")
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
                                Poppins(
                                    text: "${widget.getTotalItem()} Pcs",
                                    size: 12.0),
                                SizedBox(width: 5.0),
                                Poppins(text: "-", size: 12.0),
                                SizedBox(width: 5.0),
                                GradientText(
                                  text:
                                      "Rp ${widget.format(totalPrice.toString())}",
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
                                colorFilter: ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
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
