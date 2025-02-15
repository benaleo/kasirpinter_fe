import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kasirpinter_fe/components/components.dart';
import '../services/ms_product_category_service.dart';

class MsProductCategoryTab extends StatefulWidget {
  @override
  _MsProductCategoryTabState createState() => _MsProductCategoryTabState();
}

class _MsProductCategoryTabState extends State<MsProductCategoryTab> {
  final MsProductCategoryService _service = MsProductCategoryService();
  List<Map<String, dynamic>> _categories = [];
  int _currentPage = 0;
  String _searchKeyword = '';
  Timer? _debounce;

  Future<void> _fetchCategories() async {
    try {
      final response = await _service.fetchProductCategories(
          page: _currentPage, keyword: _searchKeyword);
      setState(() {
        _categories =
            List<Map<String, dynamic>>.from(response['data']['result']);
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  void _onSearchChanged(String keyword) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(seconds: 1), () {
      setState(() {
        _searchKeyword = keyword;
      });
      _fetchCategories();
    });
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            width: 500.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                PoppinsBold(
                  text: "Tambah kategori",
                  size: 24.0,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                Poppins(
                  text: "Nama :",
                  size: 16.0,
                ),
                SizedBox(height: 10.0),
                TextField(
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                    hintText: 'Masukan nama kategori',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButtonCustom(
              text: "Batal",
              size: 16.0,
              boxHeight: 40.0,
              width: 150.0,
              bgColor: Colors.transparent,
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButtonCustom(
              text: "Simpan",
              size: 16.0,
              boxHeight: 40.0,
              width: 150.0,
              bgColor: Colors.blue,
              color: Colors.white,
              onPressed: () async {
                await _service.createProductCategory(name: name);
                // close popup
                Navigator.of(context).pop();
                // add toast
                Fluttertoast.showToast(
                  msg: "Berhasil menyimpan kategori!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                // fetch
                _fetchCategories();
              },
            )
          ],
        );
      },
    );
  }

  void _nextPage() {
    setState(() {
      _currentPage++;
    });
    _fetchCategories();
  }

  void _prevPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _fetchCategories();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
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
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PoppinsBold(
                      text: "Daftar Kategori", size: 24.0, color: Colors.black),
                  ElevatedButtonCustom(
                    text: "Tambah",
                    size: 16.0,
                    boxSize: 150.0,
                    bgColor: Colors.blue,
                    color: Colors.white,
                    boxHeight: 40.0,
                    onPressed: _showAddCategoryDialog,
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
                child: _categories.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          width: widthDevice,
                          child: DataTable(
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Color(0xFF464646)),
                            columnSpacing: 20.0,
                            columns: [
                              DataColumn(
                                label: PoppinsBold(
                                    text: 'ID',
                                    size: 16.0,
                                    color: Colors.white),
                              ),
                              DataColumn(
                                label: PoppinsBold(
                                    text: 'Name',
                                    size: 16.0,
                                    color: Colors.white),
                              ),
                              DataColumn(
                                label: PoppinsBold(
                                    text: 'Status',
                                    size: 16.0,
                                    color: Colors.white),
                              ),
                              DataColumn(
                                label: PoppinsBold(
                                    text: 'Type',
                                    size: 16.0,
                                    color: Colors.white),
                              ),
                              DataColumn(
                                label: PoppinsBold(
                                    text: 'Total Data',
                                    size: 16.0,
                                    color: Colors.white),
                              ),
                              DataColumn(
                                label: PoppinsBold(
                                    text: 'Action',
                                    size: 16.0,
                                    color: Colors.white),
                              ),
                            ],
                            rows: List<DataRow>.generate(
                              _categories.length,
                              (index) {
                                final category = _categories[index];
                                return DataRow(
                                  color: MaterialStateColor.resolveWith(
                                    (states) => index.isOdd
                                        ? Colors.grey.shade50
                                        : Colors.white,
                                  ),
                                  cells: [
                                    DataCell(Poppins(
                                        text: (index + 1 + _currentPage * 10)
                                            .toString(),
                                        size: 14)),
                                    DataCell(Poppins(
                                        text: category['name'], size: 14)),
                                    DataCell(Poppins(
                                        text: category['isActive']
                                            ? 'Active'
                                            : 'Inactive',
                                        size: 14)),
                                    DataCell(Poppins(
                                        text: 'Menu',
                                        size:
                                            14)), // Assuming type is always 'Menu'
                                    DataCell(Poppins(
                                        text:
                                            '${category['totalProducts']} item',
                                        size: 14)),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.visibility),
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _currentPage == 0 ? null : _prevPage,
                    child: Text('Previous'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => _currentPage == 0
                            ? Colors.grey.shade50
                            : Colors.blue,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _nextPage,
                    child: Text('Next'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
