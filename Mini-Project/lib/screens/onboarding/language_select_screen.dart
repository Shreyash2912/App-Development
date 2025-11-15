import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../premium/premium_screen.dart';

class LanguageSelectScreen extends StatelessWidget {
  static const routeName = '/language-select';   // ✅ FIXED

  const LanguageSelectScreen({super.key});


  final Map<String, String> languages = const {
    'French': 'fr',
    'Spanish': 'es',
    'German': 'de',
    'Italian': 'it',
    'Portuguese': 'pt',
    'Hindi': 'hi',
    'Japanese': 'ja',      // LOCKED
    'Korean': 'ko',        // LOCKED
    'Chinese': 'zh',       // LOCKED
    'Russian': 'ru',       // LOCKED
  };

  final List<String> premiumOnly = const ['ja','ko','zh','ru'];

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Choose Language")),
      body: ListView(
        children: languages.entries.map((entry) {
          final name = entry.key;
          final code = entry.value;
          final isLocked = premiumOnly.contains(code) && !app.isPremium;

          return ListTile(
            title: Text(name),
            subtitle: isLocked
                ? const Text("Premium Only", style: TextStyle(color: Colors.red))
                : null,
            trailing: isLocked
                ? Icon(Icons.lock, color: colors.error)
                : (app.targetLanguageCode == code
                ? Icon(Icons.check, color: colors.primary)
                : null),
            onTap: () {
              if (isLocked) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PremiumScreen()),
                );
                return;
              }

              context.read<AppState>().setTargetLanguage(code);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}
