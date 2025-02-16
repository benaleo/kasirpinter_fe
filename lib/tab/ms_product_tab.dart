import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kasirpinter_fe/components/components.dart';
import 'package:skeleton_text/skeleton_text.dart';

import '../services/ms_product_service.dart';

class MsProductTab extends StatefulWidget {
  @override
  _MsProductTabState createState() => _MsProductTabState();
}

class _MsProductTabState extends State<MsProductTab> {
  final MsProductService _service = MsProductService();
  List<Map<String, dynamic>> _products = [];
  int _currentPage = 0;
  String _searchKeyword = '';
  Timer? _debounce;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _service.fetchProducts(page: _currentPage, keyword: _searchKeyword);
      setState(() {
        _products = List<Map<String, dynamic>>.from(response['data']['result']);
        _isLoading = false;
      });
      print('Fetched ${_products.length} products');
      print('Response: $response');
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String keyword) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(seconds: 1), () {
      setState(() {
        _searchKeyword = keyword;
      });
      _fetchProducts();
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
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PoppinsBold(text: "Daftar Produk", size: 24.0, color: Colors.black),
                  ElevatedButtonCustom(
                    text: "Tambah",
                    size: 16.0,
                    boxSize: 150.0,
                    bgColor: Colors.blue,
                    color: Colors.white,
                    boxHeight: 40.0,
                    onPressed: () {
                      Navigator.pushNamed(context, '/setting/product-list/add');
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Container(
                height: 40.0,
                width: 300.0,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari kategori',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: widthDevice,
                    child: DataTable(
                      headingRowColor: MaterialStateColor.resolveWith((states) => Color(0xFF464646)),
                      columnSpacing: 20.0,
                      columns: const <DataColumn>[
                        DataColumn(label: PoppinsBold(text: 'ID', size: 16.0, color: Colors.white)),
                        DataColumn(label: PoppinsBold(text: 'Nama', size: 16.0, color: Colors.white)),
                        DataColumn(label: PoppinsBold(text: 'Kategori', size: 16.0, color: Colors.white)),
                        DataColumn(label: PoppinsBold(text: 'Status', size: 16.0, color: Colors.white)),
                        DataColumn(label: PoppinsBold(text: 'Upsales', size: 16.0, color: Colors.white)),
                        DataColumn(label: PoppinsBold(text: 'HPP', size: 16.0, color: Colors.white)),
                        DataColumn(label: PoppinsBold(text: 'Harga Jual', size: 16.0, color: Colors.white)),
                        DataColumn(label: PoppinsBold(text: 'Action', size: 16.0, color: Colors.white)),
                      ],
                      rows: List<DataRow>.generate(
                        _isLoading ? 5 : _products.length,
                        (index) {
                          if (_isLoading) {
                            return DataRow(cells: <DataCell>[
                              DataCell(SkeletonShimmer(50.0, 20.0)),
                              DataCell(SkeletonShimmer(100.0, 20.0)),
                              DataCell(SkeletonShimmer(100.0, 20.0)),
                              DataCell(SkeletonShimmer(100.0, 20.0)),
                              DataCell(SkeletonShimmer(100.0, 20.0)),
                              DataCell(SkeletonShimmer(100.0, 20.0)),
                              DataCell(SkeletonShimmer(100.0, 20.0)),
                              DataCell(SkeletonShimmer(50.0, 20.0)),
                            ]);
                          } else {
                            final product = _products[index];
                            return DataRow(cells: <DataCell>[
                              DataCell(Poppins(
                                text: (index + 1 + _currentPage * 10).toString(),
                                size: 16.0,
                              )),
                              DataCell(Poppins(
                                text: product['name'] ?? '',
                                size: 16.0,
                              )),
                              DataCell(Poppins(
                                text: product['categoryName'] ?? '',
                                size: 16.0,
                              )),
                              DataCell(Poppins(
                                text: product['isActive'] == true ? 'Aktif' : 'Tidak Aktif',
                                size: 16.0,
                              )),
                              DataCell(Poppins(
                                text: product['isUpSale'] == true ? 'Aktif' : 'Tidak Aktif',
                                size: 16.0,
                              )),
                              DataCell(Poppins(
                                text: product['hppPrice'] != 0 ? "Rp. ${product['hppPrice'].toString()}" : '0',
                                size: 16.0,
                              )),
                              DataCell(Poppins(
                                text: product['price'] != 0 ? "Rp. ${product['price'].toString()}" : '0',
                                size: 16.0,
                              )),
                              DataCell(IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Implement edit functionality
                                },
                              )),
                            ]);
                          }
                        },
                      ).toList(),
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
