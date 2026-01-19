import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_web_app/Calculator/CalculatorScreen.dart';
import 'package:my_web_app/Login_pages/SignIn_screen.dart';
import 'package:my_web_app/Login_pages/Signup_screen.dart';
import 'package:my_web_app/Whatsapp_Chat/chat_list_screen.dart';
import 'Firebase/firebase_options.dart';

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