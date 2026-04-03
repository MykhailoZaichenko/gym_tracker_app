import 'package:flutter/material.dart';

class FadingEdge extends StatelessWidget {
  final Widget child;
  final double startFadeSize;
  final double endFadeSize;
  final Axis direction;

  const FadingEdge({
    super.key,
    required this.child,
    this.startFadeSize = 0.0, // Default: no fade at top
    this.endFadeSize = 0.15, // Default: 15% fade at bottom
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (isDarkMode || (startFadeSize == 0.0 && endFadeSize == 0.0)) {
      return child;
    }

    return ShaderMask(
      shaderCallback: (Rect rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Colors.transparent,
            Colors.white,
            Colors.white,
            Colors.transparent,
          ],
          stops: [0.0, startFadeSize, 1.0 - endFadeSize, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }
}
