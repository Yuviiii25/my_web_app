import 'package:flutter/material.dart';
import 'package:my_web_app/CalculatorScreen.dart';
import 'package:my_web_app/SignIn_screen.dart';
import 'package:my_web_app/Signup_screen.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignupScreen(),
    );
  }
}