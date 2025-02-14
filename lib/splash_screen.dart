import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kasirpinter_fe/services/menu_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller for controlling the opacity animation
  late AnimationController _controller;

  // Boolean to toggle between fade-in and fade-out
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();

    MenuService().fetchMenuCategories();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duration of each fade-in/fade-out
    );

    // Start the animation loop
    _animateLogo();
  }

  // Function to animate the logo with a looping effect
  void _animateLogo() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isVisible = !_isVisible; // Toggle visibility
      });

      // Reverse or forward the animation based on visibility
      if (_isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }

      // Navigate to the dashboard after the animation ends
      if (!_isVisible) {
        Navigator.of(context).pushNamed("/dashboard");
      }

    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your desired background color
      body: Center(
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0, // Toggle opacity between 1.0 and 0.0
          duration: const Duration(seconds: 1), // Duration of the opacity change
          child: SvgPicture.asset(
            'assets/images/logo_black.svg', // Path to your SVG image
            width: 100.0, // Adjust the size as needed
            height: 100.0,
          ),
        ),
      ),
    );
  }
}