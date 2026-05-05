import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';

class FunLoadingScreen extends StatefulWidget {
  const FunLoadingScreen({super.key});

  @override
  State<FunLoadingScreen> createState() => _FunLoadingScreenState();
}

class _FunLoadingScreenState extends State<FunLoadingScreen> {
  Timer? _timer;
  int _currentJokeIndex = 0;

  @override
  void initState() {
    super.initState();
    _setRandomPhrase();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _setRandomPhrase();
    });
  }

  void _setRandomPhrase() {
    if (!mounted) return;

    setState(() {
      _currentJokeIndex = Random().nextInt(13);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final List<String> phrases = [
      loc.loadingJoke1,
      loc.loadingJoke2,
      loc.loadingJoke3,
      loc.loadingJoke4,
      loc.loadingJoke5,
      loc.loadingJoke6,
      loc.loadingJoke7,
      loc.loadingJoke8,
      loc.loadingJoke9,
      loc.loadingJoke10,
      loc.loadingJoke11,
      loc.loadingJoke12,
      loc.loadingJoke13,
    ];

    final currentPhrase = phrases[_currentJokeIndex];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Text(
                currentPhrase,
                key: ValueKey<String>(currentPhrase),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
