// ignore: file_names
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {

  Color themeColor = Colors.blue;
  String displayText = "0";
  bool _isNumber(String value) => ['0','1','2','3','4','5','6','7','8','9'].contains(value);
  bool _isOperator(String value) =>['+', '-', '×', '÷'].contains(value);

  void onButtonPressed(String value){
    setState(() {
      if(value == "C"){
        displayText = "0";
        return;
      }

    if(_isNumber(value)){
      if(displayText == "0"){
        displayText = value;
      }
      else{
        displayText += value;
      }
    }

    if (_isOperator(value)) {
      // Don’t start with operator
      if (displayText == "0") return;

      // Don’t allow double operators
      final lastChar = displayText[displayText.length - 1];
      if (_isOperator(lastChar)) return;

      displayText += value;
    }
      
    });
  }

  Widget CalculatorButton(String text){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: (){
            onButtonPressed(text);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              padding: const EdgeInsets.symmetric(vertical: 22),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(text, style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black
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
        actions: [
          PopupMenuButton<Color>(
            icon: const Icon(Icons.palette),

            // When user selects a color
            onSelected: (Color selectedColor) {
              setState(() {
                themeColor = selectedColor;
              });
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
              displayText,
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