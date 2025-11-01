import 'package:flutter/material.dart';
import 'db_helper.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String expression = '';
  String result = '';
  final dbHelper = DBHelper();
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final data = await dbHelper.getHistory();
    setState(() {
      history = data;
    });
  }

  void calculate() async {
    try {
      final exp = expression;
      final res = _evaluateExpression(exp);
      setState(() => result = res);
      await dbHelper.insertCalculation(exp, res);
      loadHistory();
    } catch (e) {
      setState(() => result = 'Error');
    }
  }

  String _evaluateExpression(String exp) {
    // simple math eval using Dart's parsing
    try {
      final parsed = exp.replaceAll('x', '*');
      final res = double.parse(parsed);
      return res.toString();
    } catch (e) {
      return 'Invalid';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SQLite Calculator')),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Expression',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => setState(() => expression = val),
                ),
                ElevatedButton(
                  onPressed: calculate,
                  child: Text('Calculate'),
                ),
                Text('Result: $result'),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return ListTile(
                  title: Text(item['expression']),
                  subtitle: Text(item['result']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
