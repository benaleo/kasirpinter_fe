import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasirpinter_fe/routes.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async{
  setPathUrlStrategy();
  await dotenv.load(fileName: ".env");

  try {
    final result = await InternetAddress.lookup('confused-whippet-benaleo-dev-aa750ae1.koyeb.app');
    print("Success: $result");
  } on SocketException catch (e) {
    print("Error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login Kasir Pinter",
      onGenerateRoute: (settings) => Routes.generateRoute(settings),
      initialRoute: "/",
    );
  }
}
