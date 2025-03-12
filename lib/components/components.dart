import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasirpinter_fe/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:skeleton_text/skeleton_text.dart';

class SansBold extends StatelessWidget {
  final text;
  final double size;

  const SansBold(this.text, this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.openSans(fontSize: size, fontWeight: FontWeight.bold),
    );
  }
}

class Sans extends StatelessWidget {
  final String text;
  final double size;
  final TextAlign? textAlign;
  final color;

  const Sans(this.text, this.size, {super.key, this.textAlign, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.openSans(
        fontSize: size,
        color: color,
      ),
    );
  }
}

class Poppins extends StatelessWidget {
  final String text;
  final double size;
  final TextAlign? textAlign;
  final color;
  final TextDecoration? textDecoration;

  const Poppins(
      {super.key,
      required this.text,
      required this.size,
      this.textAlign,
      this.color,
      this.textDecoration});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: size,
        color: color,
        decoration: textDecoration,
        decorationColor: color,
        decorationThickness: 2.0,
      ),
    );
  }
}

class PoppinsBold extends StatelessWidget {
  final String text;
  final double size;
  final TextAlign? textAlign;
  final color;

  const PoppinsBold(
      {super.key,
      required this.text,
      required this.size,
      this.textAlign,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        fontSize: size,
        color: color,
      ),
    );
  }
}

class DividerBorder extends StatelessWidget {
  const DividerBorder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.black12),
        ),
      ),
    );
  }
}

class ElevatedButtonCustom extends StatelessWidget {
  final String text;
  final double size;
  final VoidCallback? onPressed;
  final String? route;
  final Color? bgColor;
  final Color? color;
  final double? boxSize;
  final double? boxHeight;
  final Widget? child;
  final double? width;
  final BoxDecoration? decoration;

  const ElevatedButtonCustom({
    super.key,
    required this.text,
    required this.size,
    this.onPressed,
    this.route,
    this.bgColor,
    this.color,
    this.boxSize,
    this.boxHeight,
    this.child,
    this.width,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: boxHeight ?? 50.0,
      child: ElevatedButton(
        onPressed: onPressed != null
            ? onPressed
            : () {
                route != null
                    ? Navigator.of(context).pushNamed(route ?? "")
                    : null;
              },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(boxSize ?? double.infinity, 50.0),
          backgroundColor: bgColor != null ? bgColor : Color(0xFF723E29),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
        child: Container(
          child: child ??
              Poppins(
                  text: text,
                  size: size,
                  color: color != null ? color : Colors.black),
        ),
      ),
    );
  }
}

class TextInputCustom extends StatefulWidget {
  final String text;
  final Icon? icon;
  final TextEditingController? controller;
  final bool? isPassword;
  final double? height;
  final String? customerName;
  final FocusNode? focusNode;
  final VoidCallback? onSubmitted;
  final String? Function(String?)? validator;
  final bool? isMobile;
  final Color? textColor;

  const TextInputCustom({
    super.key,
    required this.text,
    this.icon,
    this.controller,
    this.isPassword,
    this.height,
    this.customerName,
    this.focusNode,
    this.onSubmitted,
    this.validator,
    this.isMobile,
    this.textColor,
  });

  @override
  _TextInputCustomState createState() => _TextInputCustomState();
}

class _TextInputCustomState extends State<TextInputCustom> {
  bool _obscureText = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.isPassword != null && widget.isPassword!) {
      _obscureText = true;
    }

    if (widget.customerName != null) {
      widget.controller?.text = widget.customerName!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height != null ? widget.height : 50.0,
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        onFieldSubmitted: (_) {
          widget.onSubmitted?.call();
        },
        obscureText: widget.isPassword != null && widget.isPassword!
            ? _obscureText
            : false,
        decoration: InputDecoration(
          labelText: widget.text,
          labelStyle: TextStyle(color: widget.textColor ?? Colors.black),
          errorText: _errorMessage,
          errorStyle: const TextStyle(color: Colors.red),
          suffixIcon: widget.isPassword != null && widget.isPassword!
              ? IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  color: widget.textColor ?? Colors.black,
                )
              : widget.icon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: widget.textColor ?? Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: widget.textColor ?? Colors.black),
          ),
        ),
        style: TextStyle(color: widget.textColor ?? Colors.black),
        validator: (value) {
          final errorMessage = widget.validator?.call(value);
          // Don't directly set _errorMessage, just return the error
          return errorMessage;
        },
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final List<Color> gradientColors;

  const GradientText({
    required this.text,
    required this.style,
    this.gradientColors = const [Color(0xff723E29), Color(0xffF88F01)],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: gradientColors,
        ).createShader(bounds);
      },
      blendMode:
          BlendMode.srcIn, // Tambahkan ini agar ShaderMask bekerja dengan baik
      child: Text(
        text,
        style: style.copyWith(color: Colors.white), // Pastikan ada warna awal
      ),
    );
  }
}

class DrawerElement extends StatefulWidget {
  const DrawerElement({super.key});

  @override
  State<DrawerElement> createState() => _DrawerElementState();
}

class _DrawerElementState extends State<DrawerElement> {
  int _selectedIndex = 0;
  List<String> userPermissions = [];

  @override
  void initState() {
    super.initState();
    _loadUserPermissions();
  }

  Future<void> _loadUserPermissions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfo = prefs.getString('userInfo');
    if (userInfo != null) {
      Map<String, dynamic> userData = json.decode(userInfo);
      userPermissions = List<String>.from(
          userData['permissions'].map((perm) => perm['name']));
      setState(() {});
    }
    // print("userPermissions: $userPermissions");
  }

  void _onItemTapped(int index) {
    if (index == 4) {
      _onLogout();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _onLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Hapus token
    Navigator.pushNamedAndRemoveUntil(
        context, "/login", (route) => false); // Kembali ke login
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
            ),
            child: Text(''),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: [
                    DrawerListTile(
                        index: 0,
                        icon: Icons.dashboard,
                        title: "Dashboard",
                        selectedIndex: _selectedIndex,
                        onItemTapped: _onItemTapped,
                        routeName: "/dashboard"),
                    DrawerListTile(
                        index: 1,
                        icon: Icons.shopping_cart,
                        title: "Menu",
                        selectedIndex: _selectedIndex,
                        onItemTapped: _onItemTapped,
                        routeName: "/pos-menu"),
                    DrawerListTile(
                        index: 2,
                        icon: Icons.history_outlined,
                        title: "Order",
                        selectedIndex: _selectedIndex,
                        onItemTapped: _onItemTapped,
                        routeName: "/pos-order"),
                    if (userPermissions.contains('snow.view'))
                      DrawerListTile(
                          index: 3,
                          icon: Icons.settings,
                          title: "Product Category",
                          selectedIndex: _selectedIndex,
                          onItemTapped: _onItemTapped,
                          routeName: "/setting/product-list"),
                    if (userPermissions.contains('product_category.view'))
                      DrawerListTile(
                          index: 5,
                          icon: Icons.settings,
                          title: "Product Category",
                          selectedIndex: _selectedIndex,
                          onItemTapped: _onItemTapped,
                          routeName: "/setting/product-category"),
                    if (userPermissions.contains('product.view'))
                      DrawerListTile(
                          index: 6,
                          icon: Icons.settings,
                          title: "Product Menu",
                          selectedIndex: _selectedIndex,
                          onItemTapped: _onItemTapped,
                          routeName: "/setting/product-list"),
                    if (userPermissions.contains('employee.view'))
                      DrawerListTile(
                          index: 7,
                          icon: Icons.settings,
                          title: "Employee",
                          selectedIndex: _selectedIndex,
                          onItemTapped: _onItemTapped,
                          routeName: "/setting/employee"),
                    DrawerListTile(
                        index: 8,
                        icon: Icons.settings,
                        title: "Setting",
                        selectedIndex: _selectedIndex,
                        onItemTapped: _onItemTapped,
                        routeName: "/setting"),
                  ],
                ),
                Container(
                  child: DrawerListTile(
                    index: 100,
                    icon: Icons.logout,
                    title: "Logout",
                    selectedIndex: _selectedIndex,
                    onItemTapped: _onItemTapped,
                    routeName: "/login",
                    onPressed: () async {
                      final AuthService authService = AuthService();
                      await authService.logout();
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final int index;
  final IconData icon;
  final String title;
  final int selectedIndex;
  final Function(int) onItemTapped;
  final String routeName;
  final VoidCallback? onPressed;

  const DrawerListTile({
    super.key,
    required this.index,
    required this.icon,
    required this.title,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.routeName,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
        gradient: selectedIndex == index
            ? LinearGradient(
                colors: [
                  Colors.white,
                  Color(0xffE7772D).withOpacity(1.0),
                ],
                stops: [0.60, 1.0],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: selectedIndex == index ? Color(0xffE7772D) : null,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: selectedIndex == index ? Color(0xffE7772D) : null,
          ),
        ),
        onTap: () {
          if (onPressed != null) {
            onPressed!();
          }
          onItemTapped(index);
          Navigator.of(context).pushNamed(routeName);
        },
      ),
    );
  }
}

class IconBoxText extends StatelessWidget {
  final icon;
  final String text;
  final double size;
  final color;
  final boxColor;
  final double? height;
  final onPresses;

  const IconBoxText(this.text, this.size,
      {super.key,
      this.icon,
      this.color,
      this.boxColor,
      this.height,
      this.onPresses});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => onPresses(),
        style: ElevatedButton.styleFrom(
          elevation: boxColor != null ? 5.0 : 0.0,
          backgroundColor: boxColor != null ? boxColor : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
            side: BorderSide(
              width: 2.0,
              color: Colors.grey.shade200,
              style: BorderStyle.solid,
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.zero,
          height: height != null ? height : 30.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon != null
                  ? icon
                  : Icon(Icons.payment_outlined,
                      color: color != null ? color : Colors.grey.shade600),
              SizedBox(width: 10.0),
              PoppinsBold(
                text: text,
                size: size,
                color: color != null ? color : Colors.grey.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StackCloseButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const StackCloseButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 2.0,
      top: 2.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          shape: const CircleBorder(),
          splashFactory: NoSplash.splashFactory,
        ),
        child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.grey.shade200),
            child: Icon(Icons.close_outlined)),
      ),
    );
  }
}

class ConfirmDialog extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;

  const ConfirmDialog({
    Key? key,
    required this.onPressed,
    this.text = "Apakah anda yakin akan menghapus data ini?",
  }) : super(key: key);

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Text("Konfirmasi",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      content: Text(widget.text, style: TextStyle(fontSize: 14)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Poppins(
            text: "Tidak",
            size: 16.0,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            widget.onPressed();
            Navigator.pop(context);
          },
          child: Poppins(
            text: "Ya",
            size: 16.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class InformationDialog extends StatelessWidget {
  final String? text;

  const InformationDialog(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 80.0,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Poppins(text: text ?? "Email atau password salah!", size: 16.0),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Poppins(text: "OK", size: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ToastCustom extends StatelessWidget {
  final String text;
  final Color color;
  final Color? textColor;

  const ToastCustom(this.text, this.color, {super.key, this.textColor});

  @override
  Widget build(BuildContext context) {
    // Ensure that the widget is still mounted before showing the toast
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Fluttertoast.showToast(
          msg: text,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: color,
          textColor: textColor ?? Colors.white,
          fontSize: 16.0,
        );
      });
    }
    return Container(); // Return an empty container or any other widget
  }
}

class SkeletonShimmer extends StatelessWidget {
  final double width;
  final double height;

  const SkeletonShimmer(this.width, this.height, {super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
      child: Container(
        width: width,
        height: height,
        color: Colors.grey[300],
      ),
      shimmerColor: Colors.white54,
      borderRadius: BorderRadius.circular(10.0),
    );
  }
}
