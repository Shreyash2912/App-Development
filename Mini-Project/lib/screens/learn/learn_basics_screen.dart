import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../../services/free_translator.dart';
import '../premium/premium_screen.dart';

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

/// ---------------- LEARN BASICS SCREEN ----------------
class LearnBasicsScreen extends StatefulWidget {
  const LearnBasicsScreen({super.key});

  @override
  State<LearnBasicsScreen> createState() => _LearnBasicsScreenState();
}

class _LearnBasicsScreenState extends State<LearnBasicsScreen> {
  final translator = FreeTranslator();
  final FlutterTts _tts = FlutterTts();

  bool _loading = false;

  final List<String> basics = [
    "Hello",
    "Good morning",
    "Thank you",
    "Please",
    "Excuse me",
    "How are you?",
    "Good night",
    "Where is the bathroom?",
  ];

  Map<String, String> translated = {};

  @override
  void initState() {
    super.initState();
    _loadTranslations();
  }

  Future<void> _loadTranslations() async {
    final app = context.read<AppState>();
    final lang = app.targetLanguageCode ?? "es";

    setState(() => _loading = true);

    for (final phrase in basics) {
      final t = await translator.translate(phrase, "en", lang);
      translated[phrase] = t;
    }

    setState(() => _loading = false);
  }

  Future<void> _speak(String text) async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.55);
    await _tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final app = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text("Basics")),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(12),
        children: [
          /// PREMIUM LOCK
          if (!app.isPremium)
            const PremiumLockBanner(
              message: "Premium required to unlock full Basics learning.",
            ),

          ...basics.map((text) {
            final fav = app.isFavorite(text);
            final translatedText = translated[text] ?? "...";

            return Card(
              child: ListTile(
                /// 🔊 SPEAKER BUTTON
                leading: IconButton(
                  icon: Icon(Icons.volume_up, color: colors.primary),
                  onPressed: () => _speak(translatedText),
                ),

                title: Text(text),
                subtitle: Text(translatedText),

                /// ❤️ FAVORITES (disabled if not premium)
                trailing: IconButton(
                  icon: Icon(
                    fav ? Icons.favorite : Icons.favorite_border,
                    color: fav ? colors.primary : null,
                  ),
                  onPressed: app.isPremium
                      ? () {
                    fav
                        ? app.removeFavorite(text)
                        : app.addFavorite(text);
                  }
                      : null,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
