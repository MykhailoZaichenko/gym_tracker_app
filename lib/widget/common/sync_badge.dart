import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';

class SyncBadge extends StatefulWidget {
  final Widget child;

  const SyncBadge({super.key, required this.child});

  @override
  State<SyncBadge> createState() => _SyncBadgeState();
}

class _SyncBadgeState extends State<SyncBadge> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isVisible = false;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    // Слухаємо зміни інтернету
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      // Ігноруємо перший запуск, щоб не показувати плашку відразу при відкритті
      if (_isFirstLoad) {
        _isFirstLoad = false;
        return;
      }

      // Якщо з'явився інтернет (мобільний або wifi)
      if (results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.ethernet)) {
        _showBadge();
      }
    });
  }

  void _showBadge() {
    if (mounted) {
      setState(() => _isVisible = true);
      // Ховаємо через 3 секунди
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _isVisible = false);
        }
      });
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Stack(
      children: [
        widget.child, // Основний контент сторінки
        // Анімована плашка зверху
        AnimatedPositioned(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutBack,
          top: _isVisible ? MediaQuery.of(context).padding.top + 10 : -100,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.cloud_done_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    loc.synchronized,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
