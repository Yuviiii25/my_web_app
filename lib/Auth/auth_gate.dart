import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_web_app/Whatsapp_Chat/chat_list_screen.dart';
import 'package:my_web_app/Login_pages/SignIn_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const WhatsAppScreen();
        } else {
          return const SignIn_screen();
        }
      },
    );
  }
}
