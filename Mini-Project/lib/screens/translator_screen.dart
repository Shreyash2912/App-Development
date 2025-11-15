import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../services/free_translator.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final source = TextEditingController();
  final output = TextEditingController();

  final translator = FreeTranslator();
  final _tts = FlutterTts();

  bool loading = false;

  final Map<String, String> languages = {
    "English": "en",
    "French": "fr",
    "Hindi": "hi",
    "German": "de",
    "Spanish": "es",
    "Japanese": "ja",
    "Korean": "ko",
    "Tamil": "ta",
    "Chinese": "zh",
  };

  String from = "English";
  String to = "French";

  Future<void> translate() async {
    final text = source.text.trim();
    if (text.isEmpty) return;

    setState(() => loading = true);

    final res = await translator.translate(
      text,
      languages[from]!,
      languages[to]!,
    );

    output.text = res;

    setState(() => loading = false);
  }

  Future<void> speak(String text, String lang) async {
    if (text.isEmpty) return;
    await _tts.setLanguage(_ttsLocale(lang));
    await _tts.speak(text);
  }

  String _ttsLocale(String code) {
    return {
      "en": "en-US",
      "fr": "fr-FR",
      "hi": "hi-IN",
      "es": "es-ES",
      "de": "de-DE",
      "ko": "ko-KR",
      "ja": "ja-JP",
      "zh": "zh-CN",
      "ta": "ta-IN",
    }[code] ??
        "en-US";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Translator")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: from,
              items: languages.keys
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => from = v!),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: source,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter text...",
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: to,
              items: languages.keys
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => to = v!),
            ),
            const SizedBox(height: 10),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: translate,
              child: const Text("Translate"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: output,
              maxLines: 3,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.volume_up),
                onPressed: () =>
                    speak(output.text, languages[to] ?? "en"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
