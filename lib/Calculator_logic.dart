class CalculatorLogic {
  String displayText = "0";

  double? firstNumber;
  double? lastSecondNumber;
  String? currentOperator;
  bool waitingForSecondNumber = false;

  bool _isNumber(String value) =>
      ['0','1','2','3','4','5','6','7','8','9'].contains(value);
  bool _isOperator(String value) =>
      ['+','-','×','÷'].contains(value);

  void input(String value) {
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
  }

  double _calculate(double a, double b, String op) {
    switch (op) {
      case '+': return a + b;
      case '-': return a - b;
      case '×': return a * b;
      case '÷': return b == 0 ? 0 : a / b;
      default: return 0;
    }
  }

  String _formatResult(double result) {
    if (result % 1 == 0) {
      return result.toInt().toString();
    }
    return result.toString();
  }
}
