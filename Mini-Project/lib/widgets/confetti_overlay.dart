import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart' as confetti_package;

class ConfettiOverlay extends StatefulWidget {
  final Widget child;
  final bool showConfetti;
  final VoidCallback? onComplete;

  const ConfettiOverlay({
    super.key,
    required this.child,
    this.showConfetti = false,
    this.onComplete,
  });

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay> {
  late confetti_package.ConfettiController _controllerCenter;
  late confetti_package.ConfettiController _controllerCenterRight;
  late confetti_package.ConfettiController _controllerCenterLeft;

  @override
  void initState() {
    super.initState();
    _controllerCenter = confetti_package.ConfettiController(duration: const Duration(seconds: 3));
    _controllerCenterRight = confetti_package.ConfettiController(duration: const Duration(seconds: 3));
    _controllerCenterLeft = confetti_package.ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void didUpdateWidget(ConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showConfetti && !oldWidget.showConfetti) {
      _controllerCenter.play();
      _controllerCenterRight.play();
      _controllerCenterLeft.play();

      Future.delayed(const Duration(seconds: 3), () {
        if (widget.onComplete != null) {
          widget.onComplete!();
        }
      });
    }
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.showConfetti)
          Align(
            alignment: Alignment.topCenter,
            child: confetti_package.ConfettiWidget(
              confettiController: _controllerCenter,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.amber,
                Colors.red,
                Colors.yellow,
              ],
            ),
          ),
        if (widget.showConfetti)
          Align(
            alignment: Alignment.topRight,
            child: confetti_package.ConfettiWidget(
              confettiController: _controllerCenterRight,
              blastDirection: pi / 4,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.1,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
              ],
            ),
          ),
        if (widget.showConfetti)
          Align(
            alignment: Alignment.topLeft,
            child: confetti_package.ConfettiWidget(
              confettiController: _controllerCenterLeft,
              blastDirection: 3 * pi / 4,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.1,
              colors: const [
                Colors.purple,
                Colors.amber,
                Colors.red,
                Colors.yellow,
              ],
            ),
          ),
      ],
    );
  }
}
