// ignore_for_file: deprecated_member_use, camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class SignIn_screen extends StatefulWidget {
  const SignIn_screen({super.key});

  @override
  State<SignIn_screen> createState() => _SignIn_screenState();
}

class _SignIn_screenState extends State<SignIn_screen> {

  final email = TextEditingController();
  final password = TextEditingController();

  Future login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {

        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .set({
              "email": user.email,
              "lastLogin": FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login Sucessful")));

      Navigator.pushReplacementNamed(context, "/whatsapp");
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }


  Future resetPassword() async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password reset email sent")),
    );

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [

          // Avatar section
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 40),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFF2F3A4A),
              child: const Icon(
                Icons.person_outline,
                size: 48,
                color: Colors.cyanAccent,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Login box
          Container(
            width: 300,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2F3A4A),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  offset: const Offset(4, 4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [

                // Email field
                TextField(
                  controller: email,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyanAccent),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Password field
                TextField(
                  controller: password,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyanAccent),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Sign In button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: login, // UI only
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: resetPassword,
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: const Text(
                      "New User? Sign up",
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
