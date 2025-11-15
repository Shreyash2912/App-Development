import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../../services/free_translator.dart';
import '../premium/premium_screen.dart';

/// PREMIUM LOCK BANNER -----------------------------
class PremiumLockBanner extends StatelessWidget {
  final String message;

  const PremiumLockBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.errorContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.lock, color: colors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: colors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PremiumScreen()),
            ),
            child: const Text("Upgrade"),
          )
        ],
      ),
    );
  }
}

/// MAIN SCREEN -------------------------------------
class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final translator = FreeTranslator();
  final _tts = FlutterTts();

  bool _loading = false;
  String? foreign;
  String? correct;
  List<String> options = [];
  int? selected;
  String? feedback;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  // CREATE NEW QUESTION
  Future<void> _generate() async {
    setState(() {
      _loading = true;
      selected = null;
      feedback = null;
    });

    final sample = [
      "Good morning",
      "How are you?",
      "Thank you",
      "Thank you very much",
      "Please help me",
      "Where is the station?",
      "What is your name?",
      "I am learning languages",
    ];

    sample.shuffle();
    final english = sample.first;
    correct = english.toLowerCase();

    final app = context.read<AppState>();
    final lang = app.targetLanguageCode ?? "es";

    final translated = await translator.translate(english, "en", lang);

    setState(() {
      foreign = translated;
      options = [...sample.take(4)];
      options.shuffle();
      _loading = false;
    });
  }

  // SUBMIT ANSWER
  void _submit() {
    if (selected == null) return;

    final chosen = options[selected!].toLowerCase();
    final app = context.read<AppState>();

    if (chosen == correct) {
      app.recordQuestionSolved();
      setState(() => feedback = "Correct! 🎉");
    } else {
      setState(() => feedback = "Wrong! Correct answer: $correct");
    }
  }

  // SPEAK
  Future<void> _speak() async {
    await _tts.setLanguage("en-US");
    await _tts.speak(foreign ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Practice")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// PREMIUM RESTRICTION
            if (!app.isPremium)
              const PremiumLockBanner(
                message: "Premium required to unlock unlimited practice.",
              ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.outline),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Translate to English:\n"$foreign"',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.volume_up, color: colors.primary),
                    onPressed: _speak,
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// NO ANIMATIONS IN OPTIONS
            ...List.generate(options.length, (i) {
              final isSelected = selected == i;
              final isCorrect = feedback != null &&
                  options[i].toLowerCase() == correct;
              final isWrong = feedback != null &&
                  isSelected &&
                  !isCorrect;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Card(
                  elevation: isSelected ? 4 : 1,
                  color: isCorrect
                      ? Colors.green.shade50
                      : isWrong
                      ? Colors.red.shade50
                      : isSelected
                      ? colors.primaryContainer
                      : null,
                  child: ListTile(
                    title: Text(
                      options[i],
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isCorrect
                            ? Colors.green.shade900
                            : isWrong
                            ? Colors.red.shade900
                            : null,
                      ),
                    ),
                    trailing: isCorrect
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : isWrong
                        ? Icon(Icons.cancel, color: Colors.red)
                        : isSelected
                        ? Icon(Icons.radio_button_checked,
                        color: colors.primary)
                        : Icon(Icons.radio_button_unchecked,
                        color: colors.outline),
                    onTap: feedback == null
                        ? () => setState(() => selected = i)
                        : null,
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _submit,
              child: const Text("Submit"),
            ),
            ElevatedButton(
              onPressed: _generate,
              child: const Text("Next"),
            ),

            if (feedback != null)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: feedback!.contains("Correct")
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: feedback!.contains("Correct")
                        ? Colors.green
                        : Colors.red,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      feedback!.contains("Correct")
                          ? Icons.check_circle
                          : Icons.cancel,
                      size: 40,
                      color: feedback!.contains("Correct")
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        feedback!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: feedback!.contains("Correct")
                              ? Colors.green.shade900
                              : Colors.red.shade900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
