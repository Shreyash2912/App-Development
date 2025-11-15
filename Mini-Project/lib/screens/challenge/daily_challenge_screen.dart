import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../../services/free_translator.dart';
import '../premium/premium_screen.dart';
import '../../widgets/answer_feedback_animation.dart';
import '../../widgets/success_icon_animation.dart';

/// ---------------- PREMIUM LOCK BANNER ----------------
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

/// ---------------- DAILY CHALLENGE SCREEN ----------------
class DailyChallengeScreen extends StatefulWidget {
  const DailyChallengeScreen({super.key});

  @override
  State<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen> {
  final translator = FreeTranslator();
  final _tts = FlutterTts();
  final controller = TextEditingController();

  bool loading = false;
  String? english;
  String? target;
  String? feedback;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);

    final pool = [
      "Practice makes perfect",
      "Never stop learning",
      "Believe in yourself",
      "Stay positive",
      "Keep improving",
    ];

    pool.shuffle();
    english = pool.first;

    final app = context.read<AppState>();
    final lang = app.targetLanguageCode ?? "es";

    target = await translator.translate(english!, "en", lang);

    setState(() => loading = false);
  }

  void _submit() {
    if (controller.text.trim().isEmpty) return;

    final attempt = controller.text.trim();

    if (attempt.toLowerCase() == target!.toLowerCase()) {
      context.read<AppState>().recordDailyChallenge();
      setState(() => feedback = "Correct! 🎉");
    } else {
      setState(() => feedback = "Correct answer: $target");
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Daily Challenge")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// PREMIUM CHECK
            if (!app.isPremium)
              const PremiumLockBanner(
                message:
                "Premium required to access Daily Challenges.",
              ),

            Text(
              "Translate this into your target language:",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 12),

            Text(
              '"$english"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Your answer",
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: app.isPremium ? _submit : null,
              child: const Text("Check"),
            ),

            if (feedback != null)
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
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
                    if (feedback!.contains("Correct"))
                      const AnswerFeedbackAnimation(
                        isCorrect: true,
                        child: SuccessIconAnimation(size: 40, color: Colors.green),
                      )
                    else
                      Icon(Icons.cancel, color: Colors.red, size: 40),
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
