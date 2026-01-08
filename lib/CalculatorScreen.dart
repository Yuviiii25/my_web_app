import 'package:flutter/material.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  Widget CalculatorButton(String text){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: (){}, 
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 22),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(text, style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            ),
          ),
        )
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
        title: const Text("Calculator"),
        centerTitle: true,
      ),
      body: Column(
        children: [
           Container(
            height: 200,
            color: Colors.blue,
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(24),
            child: const Text(
              "0",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w600,
              )
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