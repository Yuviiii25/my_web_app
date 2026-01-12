import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Calculator_logic.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {

  @override
  void initState() {
    super.initState();
    loadThemeColor();
}


  Color themeColor = Colors.blue;

  // Calculator logic separated
  final logic = CalculatorLogic();

  Future saveThemeColor(Color color) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  await FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .update({
    "themeColor": color.value,
  });
}

Future loadThemeColor() async {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  final doc = await FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .get();

  if (doc.exists && doc.data()!.containsKey("themeColor")) {
    setState(() {
      themeColor = Color(doc["themeColor"]);
    });
  }
}

  Widget CalculatorButton(String text){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: (){
            setState(() {
              logic.input(text); 
            });
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              padding: const EdgeInsets.symmetric(vertical: 22),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonRow(List<String> buttons){
    return Row(
      children: buttons.map(CalculatorButton).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Calculator"),
        centerTitle: true,
        actions: [
          PopupMenuButton<Color>(
            icon: const Icon(Icons.palette),

            // When user selects a color
            onSelected: (Color selectedColor) {
              setState(() {
                themeColor = selectedColor;
              });

  saveThemeColor(selectedColor);
},

            // Menu items
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: Colors.blue,
                child: Text("Blue"),
              ),
              PopupMenuItem(
                value: Colors.green,
                child: Text("Green"),
              ),
              PopupMenuItem(
                value: Colors.red,
                child: Text("Red"),
              ),
            ],
          ),

          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              Navigator.pushReplacementNamed(context, "/signin");
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Container(
            height: 200,
            color: Colors.grey,
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(24),
            child: Text(
              logic.displayText,  
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const Divider(),

          buttonRow(["7", "8", "9", "÷"]),
          buttonRow(["4", "5", "6", "×"]),
          buttonRow(["1", "2", "3", "-"]),
          buttonRow(["C", "0", "=", "+"]),
        ],
      ),
    );
  }
}
