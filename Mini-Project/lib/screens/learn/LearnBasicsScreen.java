// lib/screens/learn/learn_basics_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../providers/app_state.dart';
import '../../theme/custom_theme.dart';

// NEW → OpenAI Translator
import '../../services/openai_translation_service.dart';

class LearnBasicsScreen extends StatefulWidget {
  const LearnBasicsScreen({super.key});

  @override
  State<LearnBasicsScreen> createState() => _LearnBasicsScreenState();
}

class _LearnBasicsScreenState extends State<LearnBasicsScreen> {
  final _translator = OpenAITranslationService();   // ✅ REPLACED
  final _tts = FlutterTts();
  bool _loading = false;

  final _phrases = [
    'Hello',
    'Good morning',
    'Thank you',
    'Please',
    'Goodbye',
    'How are you?',
    'See you later'
  ];

  List<String>? _translated;
  String? _titleText;
  String? _subtitleText;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);

    final langCode = context.read<AppState>().targetLanguageCode ?? 'es';
    final langName = _getLanguageName(langCode); // Spanish, French, etc.

    try {
      // ---- TRANSLATE PHRASES ----
      final out = <String>[];
      for (final p in _phrases) {
        final t = await _translator.translate(p, langName);
        out.add(t);
      }

      // ---- TRANSLATE UI TITLES ----
      final title =
          await _translator.translate("Essential Phrases", langName);

      final subtitle = await _translator.translate(
          "Tap a phrase to add to favorites", langName);

      if (!mounted) return;

      setState(() {
        _translated = out;
        _titleText = title;
        _subtitleText = subtitle;
      });

    } catch (e) {
      setState(() {
        _translated = List<String>.from(_phrases);
        _titleText = "Essential Phrases";
        _subtitleText = "Tap a phrase to add to favorites";
      });
    }

    if (mounted) setState(() => _loading = false);
  }

  // ------------------------- TTS -------------------------
  Future<void> _speak(String text, String langCode) async {
    final ttsCode = _ttsCode(langCode);

    await _tts.setLanguage(ttsCode);
    await _tts.setSpeechRate(0.55);
    await _tts.speak(text);
  }

  String _ttsCode(String code) {
    return {
      'fr': 'fr-FR',
      'es': 'es-ES',
      'de': 'de-DE',
      'it': 'it-IT',
      'pt': 'pt-PT',
      'hi': 'hi-IN',
      'ja': 'ja-JP',
      'ko': 'ko-KR',
      'zh': 'zh-CN',
      'ru': 'ru-RU',
    }[code] ?? 'en-US';
  }

  // ------------------ Helper (English names) ------------------
  String _getLanguageName(String code) {
    return {
      'fr': 'French',
      'es': 'Spanish',
      'de': 'German',
      'it': 'Italian',
      'pt': 'Portuguese',
      'hi': 'Hindi',
      'ja': 'Japanese',
      'ko': 'Korean',
      'zh': 'Chinese',
      'ru': 'Russian',
    }[code] ?? 'Spanish';
  }

  // ------------------------- UI -------------------------
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Basics'),
        backgroundColor: colors.surface,
        elevation: 0,
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.outline),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _titleText ?? "Essential Phrases",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _subtitleText ?? "Tap a phrase to add to favorites",
                          style: TextStyle(color: colors.outline),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Phrase List
                  Expanded(
                    child: ListView.separated(
                      itemCount: _phrases.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final src = _phrases[i];
                        final dst = _translated?[i] ?? src;

                        final isFav = app.isFavorite(dst);

                        return Card(
                          child: ListTile(
                            title: Text(
                              dst,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 18),
                            ),
                            subtitle: Text(
                              src,
                              style: TextStyle(color: colors.outline),
                            ),
                            leading: IconButton(
                              icon: Icon(Icons.volume_up,
                                  color: colors.primary),
                              onPressed: () => _speak(
                                  dst, app.targetLanguageCode ?? 'es'),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                isFav ? Icons.star : Icons.star_border,
                                color: isFav
                                    ? colors.tertiary
                                    : colors.primary.withOpacity(0.5),
                              ),
                              onPressed: () => isFav
                                  ? app.removeFavorite(dst)
                                  : app.addFavorite(dst),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
