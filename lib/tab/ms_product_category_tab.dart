import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kasirpinter_fe/components/components.dart';
import 'package:kasirpinter_fe/services/menu_service.dart';
import '../services/ms_product_category_service.dart';

class MsProductCategoryTab extends StatefulWidget {
  @override
  _MsProductCategoryTabState createState() => _MsProductCategoryTabState();
}

class _MsProductCategoryTabState extends State<MsProductCategoryTab> {
  final MsProductCategoryService _service = MsProductCategoryService();
  final TextEditingController _nameController = TextEditingController();

  List<Map<String, dynamic>> _categories = [];
  int _currentPage = 0;
  String _searchKeyword = '';
  Timer? _debounce;
  bool _isLoading = true;
  String name = '';
  bool isActive = true;

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await _service.fetchProductCategories(
          page: _currentPage, keyword: _searchKeyword);
      setState(() {
        _categories =
            List<Map<String, dynamic>>.from(response['data']['result']);
      });
    } catch (e) {
      print('Error fetching categories: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchMenuCategoriesWithRetry() async {
    bool success = false;
    int retryCount = 0;
    const maxRetries = 5;
    while (!success && retryCount < maxRetries) {
      try {
        await MenuService().fetchMenuCategories();
        success = true;
      } catch (e) {
        retryCount++;
        print("Retry $retryCount: Error fetching menu categories: $e");
        await Future.delayed(const Duration(seconds: 2));
      }
    }
    if (!success) {
      print("Failed to fetch user info after $maxRetries retries.");
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

  void _showAddCategoryDialog(
      String? dataId, String? initialName, bool? initialIsActive) {
    // Reset the controller with the initial value (if any)
    _nameController.text = initialName ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            width: 500.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                PoppinsBold(
                  text: "Tambah kategori",
                  size: 24.0,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),

                // Name Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Poppins(text: "Nama :", size: 16.0),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: _nameController,
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
                SizedBox(height: 10.0),

                // IsActive Dropdown
                if (dataId != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Poppins(text: "Status :", size: 16.0),
                      SizedBox(height: 10.0),
                      DropdownButtonFormField<bool>(
                        decoration: InputDecoration(
                          hintText: 'Status apakah aktif?',
                          border: OutlineInputBorder(),
                        ),
                        value: initialIsActive,
                        items: [
                          DropdownMenuItem(value: true, child: Text('Aktif')),
                          DropdownMenuItem(
                              value: false, child: Text('Non Aktif')),
                        ],
                        onChanged: (value) => setState(() => isActive = value!),
                      ),
                    ],
                  )
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButtonCustom(
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
                ),
                Expanded(
                  child: ElevatedButtonCustom(
                    text: "Simpan",
                    size: 16.0,
                    boxHeight: 40.0,
                    width: 150.0,
                    bgColor: Colors.blue,
                    color: Colors.white,
                    onPressed: () {
                      String name = _nameController.text
                          .trim(); // Use the controller's text
                      if (name.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "Nama kategori tidak boleh kosong!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        return; // Exit if the name is empty
                      }
                      _createProductCategory(dataId, name, isActive ?? true);
                    },
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _popupDeleteProductCategory(category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDialog(
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });
            try {
              final MsProductCategoryService service =
                  MsProductCategoryService();
              final response =
                  await service.deleteProductCategory(category['id']);
              print('Response after delete: $response');
              if (response.success) {
                Fluttertoast.showToast(
                  msg: "Berhasil menghapus kategori!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                // fetch list and state
                await _fetchCategories();
                await _fetchMenuCategoriesWithRetry();
              } else {
                Fluttertoast.showToast(
                  msg: "Gagal menghapus kategori!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            } catch (e) {
              print('Failed to delete kategori: $e');
              Fluttertoast.showToast(
                msg: "Gagal menghapus kategori!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            } finally {
              setState(() {
                _isLoading = false;
              });
            }
          },
          text: "Apakah kamu yakin akan menghapus produk ini?",
        );
      },
    );
  }

  void _createProductCategory(
      String? dataId, String name, bool isActive) async {
    try {
      await _service.createUpdateProductCategory(
        dataId: dataId,
        name: name,
        type: 'MENU',
        isActive: isActive,
      );
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

      // Fetch the updated categories after successful addition
      await _fetchCategories();
      await _fetchMenuCategoriesWithRetry(); // Call the fetch function here
    } catch (e) {
      print('Failed to create product category: $e');
      // add toast
      Fluttertoast.showToast(
        msg: "Gagal menyimpan kategori!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
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
        backgroundColor: Colors.grey[200],
        body: Container(
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
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
                    onPressed: () => _showAddCategoryDialog(null, "", true),
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
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Color(0xFF464646)),
                      columnSpacing: 20.0,
                      columns: [
                        DataColumn(
                            label: PoppinsBold(
                                text: 'ID', size: 16.0, color: Colors.white)),
                        DataColumn(
                            label: PoppinsBold(
                                text: 'Name', size: 16.0, color: Colors.white)),
                        DataColumn(
                            label: PoppinsBold(
                                text: 'Status',
                                size: 16.0,
                                color: Colors.white)),
                        DataColumn(
                            label: PoppinsBold(
                                text: 'Type', size: 16.0, color: Colors.white)),
                        DataColumn(
                            label: PoppinsBold(
                                text: 'Total Data',
                                size: 16.0,
                                color: Colors.white)),
                        DataColumn(
                            label: PoppinsBold(
                                text: 'Action',
                                size: 16.0,
                                color: Colors.white)),
                      ],
                      rows: List<DataRow>.generate(
                        _isLoading ? 5 : _categories.length,
                        (index) {
                          if (_isLoading) {
                            return DataRow(cells: <DataCell>[
                              DataCell(SkeletonShimmer(50.0, 20.0)),
                              DataCell(SkeletonShimmer(100.0, 20.0)),
                              DataCell(SkeletonShimmer(100.0, 20.0)),
                              DataCell(SkeletonShimmer(100.0, 20.0)),
                              DataCell(SkeletonShimmer(100.0, 20.0)),
                              DataCell(SkeletonShimmer(50.0, 20.0)),
                            ]);
                          } else {
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
                                DataCell(
                                    Poppins(text: category['name'], size: 14)),
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
                                    text: '${category['totalProducts']} item',
                                    size: 14)),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () => _showAddCategoryDialog(
                                            category['id'],
                                            category['name'],
                                            category['isActive']),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          _popupDeleteProductCategory(category);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
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
