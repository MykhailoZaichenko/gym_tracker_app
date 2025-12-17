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
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Colors.transparent, // Start transparent (top)
            Colors.black, // Become solid
            Colors.black, // Stay solid
            Colors.transparent, // End transparent (bottom)
          ],
          stops: [
            0.0,
            startFadeSize, // e.g. 0.05
            1.0 - endFadeSize, // e.g. 0.95
            1.0,
          ],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }
}
