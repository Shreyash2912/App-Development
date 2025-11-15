import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../widgets/confetti_overlay.dart';
import '../../widgets/success_icon_animation.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool _showConfetti = false;
  bool _isPurchasing = false;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final colors = Theme.of(context).colorScheme;

    return ConfettiOverlay(
      showConfetti: _showConfetti,
      onComplete: () {
        setState(() {
          _showConfetti = false;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Go Premium"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Unlock Premium",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Get full access to:\n"
                    "• All languages (Japanese, Korean, Chinese, Russian)\n"
                    "• Unlimited Daily Challenges\n"
                    "• Unlimited Practice\n"
                    "• Progress tracking & streak analytics\n",
                style: TextStyle(fontSize: 16, color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: Center(
                  child: _showConfetti
                      ? const SuccessIconAnimation(size: 150, color: Colors.amber)
                      : Icon(
                          Icons.workspace_premium,
                          size: 120,
                          color: colors.primary,
                        ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: _isPurchasing ? null : () async {
                    setState(() {
                      _isPurchasing = true;
                    });

                    await context.read<AppState>().upgradeToPremium();

                    if (mounted) {
                      setState(() {
                        _showConfetti = true;
                        _isPurchasing = false;
                      });

                      await Future.delayed(const Duration(milliseconds: 500));

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Premium Unlocked! Enjoy Lingo ✨"),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );

                        await Future.delayed(const Duration(seconds: 2));
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      }
                    }
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isPurchasing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          "Unlock Premium • ₹199",
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "One-time purchase • Lifetime access",
                  style: TextStyle(color: colors.outline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
