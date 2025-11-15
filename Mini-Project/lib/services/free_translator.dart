import 'dart:convert';
import 'package:http/http.dart' as http;

class FreeTranslator {
  // MAIN FREE API: Lingva
  final String lingva = "https://lingva.ml/api/v1";

  // FALLBACK SERVERS
  final List<String> libreServers = [
    "https://translate.terraprint.co/translate",
    "https://libretranslate.com/translate",
    "https://libretranslate.de/translate",
    "https://translate.argosopentech.com/translate",
  ];

  final String memoryBase = "https://api.mymemory.translated.net/get";

  Future<String> translate(String text, String from, String to) async {
    if (text.trim().isEmpty) return text;

    // 1) LINGVA (Google-ish quality)
    try {
      final url = "$lingva/$from/$to/${Uri.encodeComponent(text)}";
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        if (json["translated"] != null && json["translated"] != "") {
          return json["translated"];
        }
      }
    } catch (_) {}

    // 2) LIBRETRANSLATE FALLBACKS
    for (final server in libreServers) {
      try {
        final res = await http.post(
          Uri.parse(server),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "q": text,
            "source": from,
            "target": to,
            "format": "text",
          }),
        );

        if (res.statusCode == 200) {
          return jsonDecode(res.body)["translatedText"];
        }
      } catch (_) {}
    }

    // 3) MYMEMORY FALLBACK
    try {
      final url = "$memoryBase?q=${Uri.encodeComponent(text)}&langpair=$from|$to";
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        return jsonDecode(res.body)["responseData"]["translatedText"] ?? text;
      }
    } catch (_) {}

    // Everything failed → return original
    return text;
  }
}
