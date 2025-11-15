import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../challenge/daily_challenge_screen.dart';
import '../practice/question_screen.dart';
import '../progress/progress_screen.dart';
import '../settings/settings_screen.dart';
import '../../widgets/animated_counter.dart';

class HomeTodayScreen extends StatefulWidget {
  const HomeTodayScreen({super.key});

  @override
  State<HomeTodayScreen> createState() => _HomeTodayScreenState();
}

class _HomeTodayScreenState extends State<HomeTodayScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> fade;
  late final Animation<Offset> slide;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    fade = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    slide = Tween(begin: const Offset(0, 0.05), end: Offset.zero)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String _nameFor(String code) {
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
    }[code] ??
        "Language";
  }

  String _greet(String code) {
    return {
      'fr': 'Bonjour!',
      'es': '¡Hola!',
      'de': 'Guten Tag!',
      'it': 'Ciao!',
      'pt': 'Olá!',
      'hi': 'नमस्ते!',
      'ja': 'こんにちは！',
      'ko': '안녕하세요!',
      'zh': '你好！',
      'ru': 'Привет!',
    }[code] ??
        "Hello!";
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final colors = Theme.of(context).colorScheme;

    if (!app.isReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final code = app.targetLanguageCode ?? 'fr';
    final languageName = _nameFor(code);
    final greeting = _greet(code);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Language of the Day"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: Column(
              children: [
                _languageCard(context, languageName, greeting),
                const SizedBox(height: 16),
                _statsRow(context),
                const SizedBox(height: 16),
                _exploreCard(context),
                const SizedBox(height: 16),
                _profileCard(context), // FIXED HERE
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileCard(BuildContext context) {
    final app = context.read<AppState>();

    // ---------------- SAFE NAME + SAFE LETTER ----------------
    final bool loggedIn = app.isLoggedIn;

    final String userName = loggedIn
        ? (app.displayName != null && app.displayName!.trim().isNotEmpty
        ? app.displayName!.trim()
        : "User")
        : "Guest";

    final String letter =
    userName.isNotEmpty ? userName[0].toUpperCase() : "?";

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            child: Text(letter),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          )
        ],
      ),
    );
  }

  Widget _languageCard(BuildContext context, String name, String greeting) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.primaryContainer],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(greeting, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _AnimatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const DailyChallengeScreen()),
                  ),
                  child: const Text("Daily Challenge"),
                  isFilled: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _AnimatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QuestionScreen()),
                  ),
                  child: const Text("Practice"),
                  isFilled: false,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _statsRow(BuildContext context) {
    final app = context.watch<AppState>();

    return Row(
      children: [
        Expanded(
          child: _statCard("Streak", app.streak, Icons.local_fire_department),
        ),
        const SizedBox(width: 12),
        Expanded(
          child:
          _statCard("Questions", app.totalQuestions, Icons.bolt_outlined),
        ),
      ],
    );
  }

  Widget _statCard(String title, int value, IconData icon) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  builder: (context, iconScale, child) {
                    return Transform.scale(
                      scale: iconScale,
                      child: Icon(icon, size: 28, color: Colors.orange),
                    );
                  },
                ),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  AnimatedCounter(
                    value: value,
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ])
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _exploreCard(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Explore",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _exploreButton(
                  icon: Icons.insights,
                  label: "Progress",
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ProgressScreen())),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _exploreButton(
                  icon: Icons.school,
                  label: "Practice",
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const QuestionScreen())),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _exploreButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: _AnimatedExploreButton(
        icon: icon,
        label: label,
        onTap: onTap,
      ),
    );
  }
}

class _AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final bool isFilled;

  const _AnimatedButton({
    required this.onPressed,
    required this.child,
    this.isFilled = true,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final button = widget.isFilled
        ? FilledButton(onPressed: widget.onPressed, child: widget.child)
        : OutlinedButton(onPressed: widget.onPressed, child: widget.child);

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: button,
      ),
    );
  }
}

class _AnimatedExploreButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AnimatedExploreButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_AnimatedExploreButton> createState() => _AnimatedExploreButtonState();
}

class _AnimatedExploreButtonState extends State<_AnimatedExploreButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(widget.icon, size: 30),
              const SizedBox(height: 6),
              Text(widget.label),
            ],
          ),
        ),
      ),
    );
  }
}
