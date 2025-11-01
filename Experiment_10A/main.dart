import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> _calculate() async {
    try {
      String expression = _display;

      // Convert symbols for math_expressions parser
      expression = expression.replaceAll("×", "*");
      expression = expression.replaceAll("÷", "/");

      // Debug print for verification
      print("Evaluating: $expression");

      Parser parser = Parser();
      Expression exp = parser.parse(expression);
      ContextModel cm = ContextModel();

      double eval = exp.evaluate(EvaluationType.REAL, cm);

      print("Result: $eval");

      if (eval.isInfinite || eval.isNaN) {
        setState(() => _display = "Error");
        return;
      }

      // Store in Firebase history
      await _firestore.collection('history').add({
        'calculation': _display,
        'result': eval.toString(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update display
      setState(() {
        _display = eval.toString();
      });
    } catch (e) {
      print("Error: $e");
      setState(() => _display = "Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Calculator"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryPage()),
              );
            },
          ),
        ],
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

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("History"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('history')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(
              child: Text("No history yet",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final calc = data['calculation'] ?? '';
              final result = data['result'] ?? '';

              return ListTile(
                title: Text(
                  "$calc = $result",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () async {
                    await firestore
                        .collection('history')
                        .doc(docs[index].id)
                        .delete();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
