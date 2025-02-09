import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  const Poppins({super.key, required this.text, required this.size, this.textAlign, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: size,
        color: color,
      ),
    );
  }
}

class PoppinsBold extends StatelessWidget {
  final String text;
  final double size;
  final TextAlign? textAlign;
  final color;

  const PoppinsBold({super.key, required this.text, required this.size, this.textAlign, this.color});

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

class ElevateButtonCustom extends StatelessWidget {
  final String text;
  final double size;
  final VoidCallback? onPressed;
  final String? route;
  final Color? bgColor;
  final Color? color;
  final double? boxSize;
  final double? boxHeight;

  const ElevateButtonCustom({
    super.key,
    required this.text,
    required this.size,
    this.onPressed,
    this.route,
    this.bgColor,
    this.color,
    this.boxSize,
    this.boxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: boxHeight ?? 50.0,
      child: ElevatedButton(
        onPressed: onPressed != null
            ? onPressed
            : () {
                route != null ? Navigator.of(context).pushNamed(route ?? "") : null;
              },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(boxSize ?? double.infinity, 50.0),
          backgroundColor: bgColor != null ? bgColor : Color(0xFF723E29),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
        child: Sans(text, size, color: color),
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

  const TextInputCustom({super.key, required this.text, this.icon, this.controller, this.isPassword, this.height});

  @override
  _TextInputCustomState createState() => _TextInputCustomState();
}

class _TextInputCustomState extends State<TextInputCustom> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    if (widget.isPassword != null && widget.isPassword!) {
      _obscureText = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height != null ? widget.height : 50.0,
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword != null && widget.isPassword! ? _obscureText : false,
        decoration: InputDecoration(
          labelText: widget.text,
          suffixIcon: widget.isPassword != null && widget.isPassword!
              ? IconButton(
                  icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : widget.icon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
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
      blendMode: BlendMode.srcIn, // Tambahkan ini agar ShaderMask bekerja dengan baik
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
          Container(
            height: MediaQuery.of(context).size.height - 200.0,
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
                        icon: Icons.shopping_cart,
                        title: "Order",
                        selectedIndex: _selectedIndex,
                        onItemTapped: _onItemTapped,
                        routeName: "/pos-menu"),
                    DrawerListTile(
                        index: 3,
                        icon: Icons.settings,
                        title: "Setting",
                        selectedIndex: _selectedIndex,
                        onItemTapped: _onItemTapped,
                        routeName: "/setting"),
                  ],
                ),
                DrawerListTile(
                    index: 4, icon: Icons.logout, title: "Logout", selectedIndex: _selectedIndex, onItemTapped: _onItemTapped, routeName: "/"),
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

  const DrawerListTile({
    super.key,
    required this.index,
    required this.icon,
    required this.title,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.routeName,
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

  const IconBoxText(this.text, this.size, {super.key, this.icon, this.color, this.boxColor, this.height, this.onPresses});

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
              icon != null ? icon : Icon(Icons.payment_outlined, color: color != null ? color : Colors.grey.shade600),
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
            width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade200), child: Icon(Icons.close_outlined)),
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
      title: Text("Konfirmasi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
