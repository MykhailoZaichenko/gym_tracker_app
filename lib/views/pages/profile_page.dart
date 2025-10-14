import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/data/constants.dart';
import 'package:gym_tracker_app/data/exersise_meta.dart';
import 'package:gym_tracker_app/views/pages/edit_profile_page.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_tracker_app/data/notiers.dart';
import 'package:gym_tracker_app/views/pages/settings_page.dart';
import 'package:gym_tracker_app/views/pages/welcome_page.dart';

import '../../db/app_db.dart';
import '../../models/user_model.dart';

class ProfileGrafPage extends StatefulWidget {
  const ProfileGrafPage({super.key});

  @override
  State<ProfileGrafPage> createState() => _ProfileGrafPageState();
}

class _ProfileGrafPageState extends State<ProfileGrafPage> {
  User? _user;
  bool _isLoading = true;

  // stats
  int _totalSets = 0;
  double _totalWeight = 0.0;
  double _calMET = 0.0;
  bool _slideToLeft = true;
  String get _visibleKey => '${_visibleMonth.year}-${_visibleMonth.month}';

  late final VoidCallback _workoutSavedListener;

  @override
  void initState() {
    super.initState();
    _workoutSavedListener = () => _computeStats();
    workoutSavedNotifier.addListener(_workoutSavedListener);

    _loadCurrentUser().then((_) => _computeStats());
  }

  @override
  void dispose() {
    workoutSavedNotifier.removeListener(_workoutSavedListener);
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('current_user_id');
    if (userId == null) {
      setState(() {
        _isLoading = false;
        _user = null;
      });
      return;
    }

    final user = await AppDb().getUserById(userId);
    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  Future<void> _computeStats() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('all_workouts');
    if (raw == null) {
      if (!mounted) return;
      setState(() {
        _totalSets = 0;
        _totalWeight = 0.0;
        _calMET = 0.0;
      });
      return;
    }

    late Map<String, dynamic> decoded;
    try {
      final parsed = jsonDecode(raw);
      decoded = (parsed is Map<String, dynamic>) ? parsed : <String, dynamic>{};
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _totalSets = 0;
        _totalWeight = 0.0;
        _calMET = 0.0;
      });
      return;
    }

    // 🔹 Обчислюємо межі поточного видимого місяця
    final firstDayOfMonth = DateTime(
      _visibleMonth.year,
      _visibleMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _visibleMonth.year,
      _visibleMonth.month + 1,
      0,
    );

    int totalSets = 0;
    double totalWeight = 0.0;
    double totalCaloriesMet = 0.0;

    const double secondsPerSet = 60 * 2.0;
    final double hoursPerSet = secondsPerSet / 3600.0;

    decoded.forEach((dateStr, exercisesRaw) {
      DateTime date;
      try {
        date = DateTime.parse(dateStr);
      } catch (_) {
        return; // ігнорувати некоректні ключі
      }
      // 🔹 залишаємо лише тренування у вибраному місяці
      if (date.isBefore(firstDayOfMonth) || date.isAfter(lastDayOfMonth)) {
        return;
      }

      final List<dynamic> exerciseList = (exercisesRaw is List<dynamic>)
          ? exercisesRaw
          : [];

      for (final exEntry in exerciseList) {
        if (exEntry is! Map<String, dynamic>) continue;
        final ex = exEntry;
        final sets = (ex['sets'] is List<dynamic>)
            ? ex['sets'] as List<dynamic>
            : <dynamic>[];
        final exId = ex['exerciseId'] as String?;
        final met = (exId != null && kExerciseMet.containsKey(exId))
            ? kExerciseMet[exId]!
            : 4.0;

        for (final s in sets) {
          if (s is! Map<String, dynamic>) continue;
          final reps = (s['reps'] as num?)?.toInt() ?? 0;
          final weight = (s['weight'] as num?)?.toDouble() ?? 0.0;
          if (reps <= 0) continue;

          totalSets += 1;
          totalWeight += weight * reps;

          final userWeight = _user?.weightKg ?? 70.0;
          final calsSet = met * userWeight * hoursPerSet;
          totalCaloriesMet += calsSet;
        }
      }
    });

    if (!mounted) return;
    setState(() {
      _totalSets = totalSets;
      _totalWeight = totalWeight;
      _calMET = totalCaloriesMet;
    });
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Вихід із профілю'),
        content: const Text('Ви дійсно хочете вийти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Ні'),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('current_user_id');
              selectedPageNotifier.value = 0;
              Navigator.of(ctx).pushReplacement(
                MaterialPageRoute(builder: (_) => const WelcomePage()),
              );
            },
            child: const Text('Так'),
          ),
        ],
      ),
    );
  }

  DateTime _visibleMonth = DateTime.now();
  String ukmounth = ukrainianMonths[DateTime.now().month - 1];

  void _prevMonth() {
    setState(() {
      ukmounth =
          ukrainianMonths[DateTime(
                _visibleMonth.year,
                _visibleMonth.month - 1,
                1,
              ).month -
              1];
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1, 1);
    });
    _computeStats();
  }

  void _nextMonth() {
    setState(() {
      ukmounth =
          ukrainianMonths[DateTime(
                _visibleMonth.year,
                _visibleMonth.month + 1,
                1,
              ).month -
              1];
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 1);
    });
    _computeStats();
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : theme.primaryColor;
    final valueColor = iconColor;
    final labelColor = isDark ? Colors.white70 : Colors.grey;
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, size: 28, color: iconColor),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: labelColor)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  //todo make localization
  //todo make constant for text styles and use it
  //todo make separate widgets for profile header, stats, settings list
  //todo fix color scheme for dark mode
  //todo add avatar upload
  //todo fix month navigation (swipe + buttons)
  //todo fix stats calculation (weight*reps, METs)(use defolt kcarl calculation not met)
  Widget build(BuildContext context) {
    final name = _user?.name ?? 'Гість';
    final email = _user?.email ?? 'Немає email';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль користувача'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Аватар та ім'я
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(name, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isDarkModeNotifier.value
                            ? Colors.white70
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2.8),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, animation) {
                        // childKey — ключ поточного child у AnimatedSwitcher
                        final childKey = (child.key is ValueKey)
                            ? (child.key as ValueKey).value.toString()
                            : null;
                        final isIncoming = childKey == _visibleKey;

                        // direction залежить від збереженого прапорця _slideToLeft
                        // якщо _slideToLeft == true, тоді новий child має заходити справа (від +x) і старий виходити вліво (до -x)
                        final enterOffset = _slideToLeft
                            ? const Offset(0.2, 0)
                            : const Offset(-0.2, 0);
                        final exitOffset = _slideToLeft
                            ? const Offset(-0.2, 0)
                            : const Offset(0.2, 0);

                        final offsetTween = isIncoming
                            ? Tween<Offset>(
                                begin: enterOffset,
                                end: Offset.zero,
                              )
                            : Tween<Offset>(
                                begin: Offset.zero,
                                end: exitOffset,
                              );

                        final offsetAnimation = animation
                            .drive(CurveTween(curve: Curves.easeInCubic))
                            .drive(offsetTween);

                        final fadeAnimation = animation.drive(
                          CurveTween(curve: Curves.easeOutCubic),
                        );

                        return SlideTransition(
                          position: offsetAnimation,
                          child: FadeTransition(
                            opacity: fadeAnimation,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        key: ValueKey(_visibleKey),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            width: 1.2,
                          ),
                        ),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onHorizontalDragEnd: (details) {
                            if (details.primaryVelocity == null) return;
                            if (details.primaryVelocity! < 0) {
                              // свайп вліво — йдемо до наступного місяця, анімація має йти з права наліво
                              setState(() => _slideToLeft = true);
                              _nextMonth();
                            } else if (details.primaryVelocity! > 0) {
                              // свайп вправо — йдемо до попереднього, анімація має йти зліва направо
                              setState(() => _slideToLeft = false);
                              _prevMonth();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            child: Column(
                              children: [
                                // Заголовок з назвою місяця
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Text(
                                    'Ваш прогрес за $ukmounth ${_visibleMonth.year}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                          letterSpacing: 0.2,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                // Навігація по місяцях
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.swipe_left,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.5),
                                        size: 24,
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.chevron_left,
                                            ),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.7),
                                            iconSize: 28,
                                            onPressed: () {
                                              setState(
                                                () => _slideToLeft = false,
                                              );
                                              _prevMonth();
                                            },
                                          ),
                                          Text(
                                            '${_visibleMonth.year} - ${_visibleMonth.month.toString().padLeft(2, '0')}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.chevron_right,
                                            ),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.7),
                                            iconSize: 28,
                                            onPressed: () {
                                              setState(
                                                () => _slideToLeft = true,
                                              );
                                              _nextMonth();
                                            },
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.swipe_right,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.5),
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ),

                                // Статистика за місяць
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildStatCard(
                                      context,
                                      icon: Icons.fitness_center,
                                      label: 'Підходів',
                                      value: '$_totalSets',
                                    ),
                                    const SizedBox(width: 8),
                                    _buildStatCard(
                                      context,
                                      icon: Icons.square_foot,
                                      label: 'Вага (kg·reps)',
                                      value: _formatNumber(_totalWeight),
                                    ),
                                    const SizedBox(width: 8),
                                    _buildStatCard(
                                      context,
                                      icon: Icons.local_fire_department,
                                      label: 'Калорії (MET)',
                                      value: _formatNumber(_calMET),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Налаштування профілю
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 1,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.edit),
                            title: const Text('Редагувати профіль'),
                            onTap: () async {
                              final updated = await Navigator.push<User?>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditProfilePage(user: _user!),
                                ),
                              );
                              if (updated != null && mounted) {
                                setState(() {
                                  _user = updated;
                                  _computeStats();
                                });
                              }
                            },
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.settings),
                            title: const Text('Налаштування'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingsPage(),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text('Вийти'),
                            onTap: () => _confirmLogout(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

String _formatNumber(double v) {
  if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
  if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
  if (v == v.roundToDouble()) return v.toInt().toString();
  return v.toStringAsFixed(1);
}
