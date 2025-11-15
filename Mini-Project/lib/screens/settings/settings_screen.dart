import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../premium/premium_screen.dart';
import '../onboarding/language_select_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // PROFILE
          ListTile(
            leading: CircleAvatar(child: Text(app.displayName?.substring(0, 1).toUpperCase() ?? "G")),
            title: Text(app.displayName ?? "Guest"),
            subtitle: Text(app.isPremium ? "Premium User" : "Free User"),
            trailing: Icon(Icons.person, color: colors.primary),
          ),

          const Divider(),

          // LANGUAGE
          ListTile(
            leading: Icon(Icons.language, color: colors.primary),
            title: const Text("Change Language"),
            subtitle: Text(app.targetLanguageCode ?? "Not set"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LanguageSelectScreen()),
            ),
          ),

          // PREMIUM
          ListTile(
            leading: Icon(Icons.workspace_premium, color: colors.tertiary),
            title: const Text("Upgrade to Premium"),
            subtitle: const Text("Unlock all features"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PremiumScreen()),
            ),
          ),

          // DIFFICULTY OPTION
          ListTile(
            leading: Icon(Icons.speed, color: colors.primary),
            title: const Text("Difficulty"),
            subtitle: Text(app.difficulty),
          ),

          const Divider(),

          // LOGOUT
          if (app.isLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log Out"),
              onTap: () => context.read<AppState>().logout(),
            )
        ],
      ),
    );
  }
}
