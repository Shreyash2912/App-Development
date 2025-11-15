import 'package:flutter/material.dart';

class AnswerFeedbackAnimation extends StatefulWidget {
  final bool isCorrect;
  final Widget child;

  const AnswerFeedbackAnimation({
    super.key,
    required this.isCorrect,
    required this.child,
  });

  @override
  State<AnswerFeedbackAnimation> createState() => _AnswerFeedbackAnimationState();
}

class _AnswerFeedbackAnimationState extends State<AnswerFeedbackAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: widget.isCorrect ? 0.1 : -0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnswerFeedbackAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCorrect != oldWidget.isCorrect) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

