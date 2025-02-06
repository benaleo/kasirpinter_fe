
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
  const ElevateButtonCustom({super.key, required this.text, required this.size, this.onPressed, this.route, this.bgColor, this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed != null ? onPressed : () {
        route != null ? Navigator.of(context).pushNamed(route ?? "") : null;
      },
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50.0),
        backgroundColor: bgColor != null ? bgColor : Color(0xFF723E29),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      ),
      child: Sans(
        text,
        size,
        color: color
      ),
    );
  }
}

class TextInputCustom extends StatefulWidget {
  final String text;
  final Icon? icon;
  final TextEditingController? controller;
  final bool? isPassword;
  const TextInputCustom({super.key, required this.text, this.icon, this.controller, this.isPassword});

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
    return TextField(
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
    );
  }
}


