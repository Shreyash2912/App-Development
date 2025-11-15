import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../home/home_today_screen.dart';
import '../learn/learn_basics_screen.dart';
import '../practice/question_screen.dart';
import '../account/account_screen.dart';
import '../premium/premium_screen.dart';

class RootNav extends StatefulWidget {
  static const routeName = '/root';   // ✅ FIXED

  const RootNav({super.key});

  @override
  State<RootNav> createState() => _RootNavState();
}

class _RootNavState extends State<RootNav> {
  int index = 0;
  bool _premiumBannerDismissed = false;

  final screens = const [
    HomeTodayScreen(),
    LearnBasicsScreen(),
    QuestionScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final app = context.watch<AppState>();

    // Show banner for non-premium users (guests or logged-in non-premium)
    final showBanner = !app.isPremium && !_premiumBannerDismissed;

    return Scaffold(
      body: Column(
        children: [
          // Premium Banner
          if (showBanner)
            _buildPremiumBanner(context, colors, app),
          // Main content
          Expanded(
            child: screens[index],
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        height: 65,
        onDestinationSelected: (i) {
          setState(() => index = i);
        },
        indicatorColor: colors.primaryContainer,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined), label: "Today"),
          NavigationDestination(
              icon: Icon(Icons.menu_book_outlined), label: "Learn"),
          NavigationDestination(
              icon: Icon(Icons.school_outlined), label: "Practice"),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: "Account"),
        ],
      ),
    );
  }

  Widget _buildPremiumBanner(BuildContext context, ColorScheme colors, AppState app) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade600,
            Colors.orange.shade600,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Icon(
              Icons.workspace_premium,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    app.isLoggedIn 
                        ? "Unlock Premium Features!" 
                        : "Subscribe to Premium!",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Get access to all languages and features",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PremiumScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.orange.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Subscribe",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
              onPressed: () {
                setState(() {
                  _premiumBannerDismissed = true;
                });
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
