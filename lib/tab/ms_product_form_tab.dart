import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasirpinter_fe/services/input_attribute_service.dart';
import 'package:kasirpinter_fe/services/ms_product_service.dart';
import 'dart:io';

import '../components/components.dart';

class MsProductFormTab extends StatefulWidget {
  final String? productId;

  MsProductFormTab({this.productId});

  @override
  _MsProductFormTabState createState() => _MsProductFormTabState();
}

class _MsProductFormTabState extends State<MsProductFormTab> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  String imageUrl = '';
  final picker = ImagePicker();
  String name = '';
  int price = 0;
  int hppPrice = 0;
  int stock = 0;
  bool isUnlimited = false;
  bool isUpSale = false;
  bool isActive = true;
  String categoryId = '';
  List<Map<String, String>> categories = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _hppPriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProductCategories();
    if (widget.productId != null) {
      loadProductDetails(widget.productId!);
    }
    _nameController.text = name;
    _priceController.text = price.toString();
    _hppPriceController.text = hppPrice.toString();
    _stockController.text = stock.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _hppPriceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> fetchProductCategories() async {
    try {
      final service = InputAttributeService();
      categories = await service.getProductCategories();
      setState(() {});
    } catch (e) {
      print('Failed to fetch categories: $e');
    }
  }

  Future<void> loadProductDetails(String productId) async {
    try {
      final service = MsProductService();
      final product = await service.getDetailProduct(productId);
      setState(() {
        name = product['name'];
        price = product['price'];
        hppPrice = product['hppPrice'];
        stock = product['stock'];
        isUnlimited = product['isUnlimited'];
        isUpSale = product['isUpSale'];
        isActive = product['isActive'];
        categoryId = product['categoryId'];
        imageUrl = product['image'];
        _nameController.text = name;
        _priceController.text = price.toString();
        _hppPriceController.text = hppPrice.toString();
        _stockController.text = stock.toString();
      });
      print("product details is : $product");
    } catch (e) {
      print('Failed to load product details: $e');
    }
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void removeImage() {
    setState(() {
      _image = null;
    });
  }

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final service = MsProductService();
        if (widget.productId == null) {
          await service.createUpdateProduct(
            productId: null,
            image: _image is File ? _image : null,
            name: _nameController.text,
            price: int.parse(_priceController.text),
            hppPrice: int.parse(_hppPriceController.text),
            stock: int.parse(_stockController.text),
            isUnlimited: isUnlimited,
            isUpSale: isUpSale,
            isActive: isActive,
            categoryId: categoryId,
          );
        } else {
          await service.createUpdateProduct(
            productId: widget.productId!,
            image: _image is File ? _image : null,
            name: _nameController.text,
            price: int.parse(_priceController.text),
            hppPrice: int.parse(_hppPriceController.text),
            stock: int.parse(_stockController.text),
            isUnlimited: isUnlimited,
            isUpSale: isUpSale,
            isActive: isActive,
            categoryId: categoryId,
          );
        }
        Fluttertoast.showToast(
          msg: widget.productId == null
              ? "Simpan produk berhasil!"
              : "Update produk berhasil!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushNamed(context, '/setting/product-list');
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Gagal menyimpan produk.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
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
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Container(
                width: widthDevice,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PoppinsBold(text: "Tambah Produk", size: 24.0),
                    SizedBox(height: 10.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10.0,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final pickedFile = await picker.getImage(
                                      source: ImageSource.gallery);
                                  setState(() {
                                    if (pickedFile != null) {
                                      _image = File(pickedFile.path);
                                    } else {
                                      _image = null;
                                    }
                                  });
                                },
                                child: Container(
                                  width: 400.0,
                                  height: 400.0,
                                  child: Stack(
                                    children: <Widget>[
                                      _image == null
                                          ? Container(
                                              width: 400,
                                              height: 400,
                                              color: Colors.grey[200],
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.cloud_upload_outlined,
                                                    color: Colors.grey[400],
                                                    size: 200.0,
                                                  ),
                                                  SizedBox(height: 12.0),
                                                  Poppins(
                                                      text:
                                                          "Upload gambar produk disini",
                                                      size: 16.0,
                                                      color: Colors.grey[400]),
                                                  SizedBox(height: 12.0),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20.0,
                                                            vertical: 5.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    child: Poppins(
                                                      text: "Pilih gambar",
                                                      size: 16.0,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : imageUrl != ""
                                              ? Image.network(
                                                  imageUrl,
                                                  width: 400,
                                                  height: 400,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.file(
                                                  _image!,
                                                  width: 400,
                                                  height: 400,
                                                  fit: BoxFit.cover,
                                                ),
                                      if (_image != null || imageUrl != "")
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: ElevatedButton(
                                            onPressed: removeImage,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            child: Icon(
                                              Icons.delete_outline,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      spacing: 10.0,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Poppins(
                                                  text: "Nama :", size: 16.0),
                                              SizedBox(height: 5.0),
                                              TextFormField(
                                                controller: _nameController,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Masukan nama produk',
                                                  border: OutlineInputBorder(),
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Masukkan nama';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Poppins(
                                                  text: "Kategori :",
                                                  size: 16.0),
                                              SizedBox(height: 5.0),
                                              DropdownButtonFormField<String>(
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Pilih produk kategori',
                                                  border: OutlineInputBorder(),
                                                ),
                                                value: categoryId.isNotEmpty
                                                    ? categoryId
                                                    : null,
                                                items:
                                                    categories.map((category) {
                                                  return DropdownMenuItem(
                                                    value: category['id'],
                                                    child:
                                                        Text(category['name']!),
                                                  );
                                                }).toList(),
                                                onChanged: (value) => setState(
                                                    () => categoryId = value!),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Pilih kategori';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.0),
                                    Row(
                                      spacing: 10.0,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Poppins(
                                                  text: "Harga (Rp) :",
                                                  size: 16.0),
                                              SizedBox(height: 5.0),
                                              TextFormField(
                                                controller: _priceController,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  hintText:
                                                      'Masukan harga produk',
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Masukkan harga';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Poppins(
                                                  text: "HPP (Rp) :",
                                                  size: 16.0),
                                              SizedBox(height: 5.0),
                                              TextFormField(
                                                controller:
                                                    _hppPriceController,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  hintText: 'Masukan harga hpp',
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.0),
                                    Row(
                                      spacing: 10.0,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Poppins(
                                                  text: "Unlimited :",
                                                  size: 16.0),
                                              SizedBox(height: 5.0),
                                              DropdownButtonFormField<bool>(
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Apakah produk ini unlimited?',
                                                  border: OutlineInputBorder(),
                                                ),
                                                value: isUnlimited,
                                                items: [
                                                  DropdownMenuItem(
                                                      value: true,
                                                      child: Text('Yes')),
                                                  DropdownMenuItem(
                                                      value: false,
                                                      child: Text('No')),
                                                ],
                                                onChanged: (value) => setState(
                                                    () => isUnlimited = value!),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Poppins(
                                                  text: "Upsale :", size: 16.0),
                                              SizedBox(height: 5.0),
                                              DropdownButtonFormField<bool>(
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Apakah produk ini upsale?',
                                                  border: OutlineInputBorder(),
                                                ),
                                                value: isUpSale,
                                                items: [
                                                  DropdownMenuItem(
                                                      value: true,
                                                      child: Text('Yes')),
                                                  DropdownMenuItem(
                                                      value: false,
                                                      child: Text('No')),
                                                ],
                                                onChanged: (value) => setState(
                                                    () => isUpSale = value!),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.0),
                                    Row(
                                      spacing: 10.0,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Poppins(
                                                  text: "Stock produk :",
                                                  size: 16.0),
                                              SizedBox(height: 5.0),
                                              TextFormField(
                                                controller: _stockController,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Masukan stock produk',
                                                  border: OutlineInputBorder(),
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Masukkan stok';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Poppins(
                                                  text: "Status :", size: 16.0),
                                              SizedBox(height: 5.0),
                                              DropdownButtonFormField<bool>(
                                                decoration: InputDecoration(
                                                  hintText: 'Active',
                                                  border: OutlineInputBorder(),
                                                ),
                                                value: isActive,
                                                items: [
                                                  DropdownMenuItem(
                                                      value: true,
                                                      child: Text('Active')),
                                                  DropdownMenuItem(
                                                      value: false,
                                                      child: Text('Inactive')),
                                                ],
                                                onChanged: (value) => setState(
                                                    () => isActive = value!),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            spacing: 10.0,
                            children: [
                              ElevatedButtonCustom(
                                text: "Batalkan",
                                size: 16.0,
                                boxSize: 200.0,
                                boxHeight: 40.0,
                                bgColor: Colors.white,
                                color: Colors.red,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    border: Border.all(
                                        color: Colors.red, width: 2.0),
                                    color: Colors.white),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, "/setting/product-list");
                                },
                              ),
                              ElevatedButtonCustom(
                                text: "Simpan",
                                size: 16.0,
                                boxSize: 200.0,
                                boxHeight: 40.0,
                                bgColor: Colors.blue,
                                color: Colors.white,
                                onPressed: submitForm,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
