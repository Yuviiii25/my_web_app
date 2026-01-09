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
  double? firstNumber;
  String? currentOperator;
  bool waitingForSecondNumber = false;
  double? lastSecondNumber;
  double _calculate(double a, double b, String op) {
  switch (op) {
    case '+':
      return a + b;
    case '-':
      return a - b;
    case '×':
      return a * b;
    case '÷':
      return b == 0 ? 0 : a / b;
    default:
      return 0;
  }
}

String _formatResult(double result) {
  if (result % 1 == 0) {
    return result.toInt().toString();
  }
  return result.toString();
}

  void onButtonPressed(String value) {
  setState(() {

    // CLEAR
    if (value == "C") {
      displayText = "0";
      firstNumber = null;
      currentOperator = null;
      waitingForSecondNumber = false;
      return;
    }

    // NUMBER
    if (_isNumber(value)) {
      if (displayText == "0" || waitingForSecondNumber) {
        displayText = value;
        waitingForSecondNumber = false;
      } else {
        displayText += value;
      }
      return;
    }

    // OPERATOR
    if (_isOperator(value)) {
      firstNumber = double.parse(displayText);
      currentOperator = value;
      waitingForSecondNumber = true;
      return;
    }

    // EQUALS
    if (value == "=" &&
    firstNumber != null &&
    currentOperator != null) {

  double secondNumber;

  if (!waitingForSecondNumber) {
    secondNumber = double.parse(displayText);
    lastSecondNumber = secondNumber;
  } else {
    secondNumber = lastSecondNumber ?? firstNumber!;
  }

  final result =
      _calculate(firstNumber!, secondNumber, currentOperator!);

  displayText = _formatResult(result);

  firstNumber = result;
  waitingForSecondNumber = true;
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