import 'package:flutter/material.dart';
import 'package:gym_tracker_app/core/theme/theme_service.dart';
import 'package:lottie/lottie.dart';

// HeroWidget тепер є StatefulWidget для керування контролером анімації.
class HeroWidget extends StatefulWidget {
  final String tag;

  const HeroWidget({super.key, required this.tag});

  @override
  State<HeroWidget> createState() => _HeroWidgetState();
}

// Використовуємо SingleTickerProviderStateMixin для контролера
class _HeroWidgetState extends State<HeroWidget>
    with SingleTickerProviderStateMixin {
  // Контролер для керування Lottie анімацією
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Ініціалізуємо контролер. Ви можете налаштувати тривалість,
    // але Lottie також може використовувати вбудовану тривалість.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Встановіть відповідну тривалість
    );

    // Додаємо слухача, щоб реалізувати логіку паузи
    _controller.addStatusListener(_onAnimationStatusChanged);

    // Запускаємо анімацію одразу
    _controller.forward();
  }

  // Логіка для паузи та циклічного відтворення
  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      // Анімація завершена. Чекаємо 1 секунду.
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          // Якщо віджет ще на екрані, перезапускаємо анімацію з початку
          _controller.forward(from: 0.0);
        }
      });
    }
  }

  @override
  void dispose() {
    // Обов'язково звільняємо контролер
    _controller.removeStatusListener(_onAnimationStatusChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Hero-віджет забезпечує плавний перехід між сторінками
    return Hero(
      tag: widget.tag,
      // ValueListenableBuilder використовується для реакції на зміни теми
      child: ValueListenableBuilder<bool>(
        valueListenable: ThemeService.isDarkModeNotifier,
        builder: (context, isDarkMode, child) {
          // Створюємо Lottie-віджет, прив'язаний до нашого контролера
          final lottieWidget = Lottie.asset(
            'assets/lotties/dumbell.json',
            height: 300,
            controller: _controller, // Передаємо наш контролер
            repeat:
                false, // Вимикаємо вбудований цикл Lottie, ми керуємо ним вручну
          );

          // Застосовуємо фільтр кольорів у темному режимі
          if (isDarkMode) {
            return ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcATop,
              ),
              child: lottieWidget,
            );
          }
          return lottieWidget;
        },
      ),
    );
  }
}
