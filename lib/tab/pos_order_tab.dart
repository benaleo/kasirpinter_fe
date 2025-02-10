// order.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../components/components.dart';
import '../components/pos_components.dart';

class PosOrderTab extends StatefulWidget {
  @override
  _PosOrderTabState createState() => _PosOrderTabState();
}

class _PosOrderTabState extends State<PosOrderTab> {
  List<Map<String, dynamic>> orders = [
    {
      'order_no': 'A343',
      'customer': 'Rifqi',
      'items': 2,
      'total_price': 40000,
      'payment_status': 'Lunas',
      'payment_method': 'Cash',
      'details': [
        {'name': 'Caffe Latte', 'price': 20000, 'quantity': 2}
      ]
    },
    {
      'order_no': 'A343',
      'customer': 'Putri',
      'items': 2,
      'total_price': 34000,
      'payment_status': 'Lunas',
      'payment_method': 'QRIS',
      'details': [
        {'name': 'Espresso', 'price': 17000, 'quantity': 2}
      ]
    },
    {
      'order_no': 'A343',
      'customer': 'Imam',
      'items': 2,
      'total_price': 43000,
      'payment_status': 'Nanti',
      'payment_method': 'Cash',
      'details': [
        {'name': 'Mocha', 'price': 21500, 'quantity': 2}
      ]
    },
  ];

  Map<String, dynamic>? selectedOrder;

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
                      SizedBox(height: 500.0,
                        child: ListView(
                          children: orders.map((order) {
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (selectedOrder != null)
              Expanded(
                child: selectedOrder != null && selectedOrder!['payment_status'] == 'Lunas'
                    ? Card(
                  margin: EdgeInsets.only(top: 0.0, left: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Detail Pesanan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text('No. Pesanan: ${selectedOrder!['order_no']}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Nama: ${selectedOrder!['customer']}'),
                        Divider(),
                        ...selectedOrder!['details'].map<Widget>((item) {
                          return ListTile(
                            title: Text(item['name']),
                            subtitle: Text('${item['quantity']} item'),
                            trailing: Text('Rp. ${item['price'] * item['quantity']}'),
                          );
                        }).toList(),
                        Divider(),
                        Text('Total: Rp. ${selectedOrder!['total_price']}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Metode Pembayaran: ${selectedOrder!['payment_method']}'),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Fungsi print nota bisa diimplementasikan di sini
                          },
                          child: Text('Print Nota'),
                        ),
                      ],
                    ),
                  ),
                )
                    : Center(child: Text('Pilih pesanan untuk melihat detail.')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
