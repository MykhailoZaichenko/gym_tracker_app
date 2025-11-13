import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/theme/theme_service.dart';
import 'package:lottie/lottie.dart';

class HeroWidget extends StatelessWidget {
  final String tag;

  const HeroWidget({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: ThemeService.isDarkModeNotifier.value
          ? ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcATop,
              ),
              child: Lottie.asset('assets/lotties/dumbell.json', height: 400),
            )
          : Lottie.asset('assets/lotties/dumbell.json', height: 400),
    );
  }
}
