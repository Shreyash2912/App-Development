import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart'; // Add in pubspec.yaml

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Calculator',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = "";

  final List<String> buttons = [
    "7", "8", "9", "÷",
    "4", "5", "6", "×",
    "1", "2", "3", "-",
    "0", "C", "=", "+"
  ];

  void _onButtonPressed(String button) {
    setState(() {
      if (button == "C") {
        _display = "";
      } else if (button == "=") {
        _calculate();
      } else {
        _display += button;
      }
    });
  }

  void _calculate() {
    try {
      String expression = _display;
      expression = expression.replaceAll("×", "*");
      expression = expression.replaceAll("÷", "/");

      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);

      if (result.toString() == "Infinity" || result.isNaN) {
        _display = "Error";
      } else {
        _display = result.toString();
      }
    } catch (e) {
      _display = "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Calculator"),
      ),
      body: Column(
        children: [
          // Display
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: Text(
                _display,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Buttons
          Expanded(
            flex: 2,
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (context, index) {
                final button = buttons[index];

                // Color logic
                Color buttonColor;
                if (button == "C") {
                  buttonColor = Colors.redAccent;
                } else if (button == "=") {
                  buttonColor = Colors.green;
                } else if (["+", "-", "×", "÷"].contains(button)) {
                  buttonColor = Colors.orange;
                } else {
                  buttonColor = Colors.grey[850]!;
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(20),
                    ),
                    onPressed: () => _onButtonPressed(button),
                    child: Text(
                      button,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
