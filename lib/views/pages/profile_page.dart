// lib/views/pages/profile_graf_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/data/constants.dart';
import 'package:gym_tracker_app/views/pages/edit_profile_page.dart';
import 'package:path/path.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_tracker_app/data/notiers.dart';
import 'package:gym_tracker_app/views/pages/settings_page.dart';
import 'package:gym_tracker_app/views/pages/welcome_page.dart';

import '../../db/app_db.dart';
import '../../models/user_model.dart';

class ProfileGrafPage extends StatefulWidget {
  const ProfileGrafPage({Key? key}) : super(key: key);

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
        _totalSets = _totalSets;
        _totalWeight = _totalWeight;
        _calMET = _calMET;
      });
      return;
    }

    late Map<String, dynamic> decoded;
    try {
      final parsed = jsonDecode(raw);
      decoded = (parsed is Map<String, dynamic>) ? parsed : <String, dynamic>{};
    } catch (e) {
      // Некоректний JSON
      if (!mounted) return;
      setState(() {
        _totalSets = 0;
        _totalWeight = 0.0;
        _calMET = 0.0;
      });
      return;
    }

    final now = DateTime.now();
    final from = now.subtract(Duration(days: 30));

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
        return; // ігнорувати ключі, які не парсяться
      }
      if (date.isBefore(from) || date.isAfter(now)) return;

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
  Widget build(BuildContext context) {
    final now = DateTime.now();
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
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Аватар та ім'я
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).primaryColor,
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
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    // Статистика (тимчасові значення — заміни на реальні з бази коли з'являться)
                    Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: SizedBox(
                            width: double
                                .infinity, // займає всю доступну ширину всередині Padding
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ), // внутрішній відступ
                              child: Text(
                                'Ваш прогрес за ${ukrainianMonths[now.month - 1]}',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onBackground,
                                      letterSpacing: 0.2,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
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

                    const SizedBox(height: 24),

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
