import 'package:flutter/material.dart';

class AnimatedCounter extends ImplicitlyAnimatedWidget {
  final int value;
  final TextStyle? textStyle;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.textStyle,
    super.duration = const Duration(milliseconds: 500),
    super.curve = Curves.easeOut,
  });

  @override
  ImplicitlyAnimatedWidgetState<AnimatedCounter> createState() =>
      _AnimatedCounterState();
}

class _AnimatedCounterState
    extends AnimatedWidgetBaseState<AnimatedCounter> {
  IntTween? _intTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _intTween = visitor(
      _intTween,
      widget.value,
          (dynamic value) => IntTween(begin: value as int),
    ) as IntTween?;
  }

  @override
  Widget build(BuildContext context) {
    final currentValue =
        _intTween?.evaluate(animation) ?? widget.value;

    return Text(
      '$currentValue',
      style: widget.textStyle,
    );
  }
}
