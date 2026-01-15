import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_web_app/CalculatorScreen.dart';
import 'package:my_web_app/SignIn_screen.dart';
import 'package:my_web_app/Signup_screen.dart';
import 'package:my_web_app/auth_gate.dart';
import 'package:my_web_app/chat_list_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WhatsAppScreen(),
      routes: {
        "/signin": (context) => const SignIn_screen(),
        "/signup": (context) => const SignupScreen(),
        "/calculator": (context) => const CalculatorScreen(),
      }
    );
  }
}