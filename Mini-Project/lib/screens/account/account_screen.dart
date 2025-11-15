import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../onboarding/language_select_screen.dart';
import '../premium/premium_screen.dart';
import '../auth/login_signup_screen.dart';
import '../admin/admin_panel_screen.dart';

class _AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final int index;

  const _AnimatedCard({
    required this.child,
    this.onTap,
    required this.index,
  });

  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300 + (widget.index * 100)),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final colors = Theme.of(context).colorScheme;

    // ---------------- SAFE NAME LOGIC ----------------
    final bool loggedIn = app.isLoggedIn;

    // Safely choose display name
    final String name = loggedIn
        ? (app.displayName != null && app.displayName!.trim().isNotEmpty
        ? app.displayName!.trim()
        : "User")
        : "Guest";

    // Safely generate first letter (prevents RangeError)
    final String letter = name.isNotEmpty ? name[0].toUpperCase() : "?";

    return Scaffold(
      appBar: AppBar(title: const Text("Account")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // PROFILE HEADER
            CircleAvatar(
              radius: 40,
              backgroundColor: colors.primaryContainer,
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: 32,
                  color: colors.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(name, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 20),

            // PREMIUM STATUS
            _AnimatedCard(
              index: 0,
              child: app.isPremium
                  ? Card(
                color: colors.primaryContainer.withOpacity(0.5),
                child: ListTile(
                  leading:
                  Icon(Icons.workspace_premium, color: colors.primary),
                  title: const Text("Premium Member"),
                  subtitle: const Text("You have all features unlocked"),
                ),
              )
                  : Card(
                child: ListTile(
                  leading: Icon(Icons.lock, color: colors.primary),
                  title: const Text("Get Premium"),
                  subtitle: const Text("Unlock all languages and features"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const PremiumScreen()),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // LANGUAGE
            _AnimatedCard(
              index: 1,
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.translate, color: colors.primary),
                  title: const Text("Target Language"),
                  subtitle: Text(app.targetLanguageCode ?? "Not set"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LanguageSelectScreen()),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ADMIN PANEL ACCESS
            if (app.isAdmin)
              _AnimatedCard(
                index: 2,
                child: Card(
                  color: colors.primaryContainer.withOpacity(0.5),
                  child: ListTile(
                    leading:
                    Icon(Icons.admin_panel_settings, color: colors.primary),
                    title: const Text("Admin Panel"),
                    subtitle: const Text("Manage users and features"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AdminPanelScreen()),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),
            const Spacer(),

            // LOGIN / LOGOUT
            loggedIn
                ? FilledButton(
              onPressed: () => context.read<AppState>().logout(),
              child: const Text("Logout"),
            )
                : FilledButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const LoginSignupScreen()),
              ),
              child: const Text("Login / Signup"),
            ),
          ],
        ),
      ),
    );
  }
}
