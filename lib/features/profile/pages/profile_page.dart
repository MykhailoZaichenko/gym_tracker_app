import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gym_tracker_app/core/constants/exersise_meta.dart';
import 'package:gym_tracker_app/features/profile/models/user_model.dart';
import 'package:gym_tracker_app/features/profile/profile_exports.dart';

class ProfileGrafPage extends StatefulWidget {
  const ProfileGrafPage({super.key});

  @override
  State<ProfileGrafPage> createState() => _ProfileGrafPageState();
}

class _ProfileGrafPageState extends State<ProfileGrafPage> {
  User? _user;
  bool _isLoading = true;
  final FirestoreService _firestore = FirestoreService();

  // stats and UI
  DateTime _visibleMonth = DateTime.now();

  int _totalSets = 0;
  double _totalWeight = 0.0;
  double _calories = 0.0;
  // ignore: unused_field
  bool _slideToLeft = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    // _loadCurrentUser().then((_) => _computeStats());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadData() async {
    // 1. Завантажуємо юзера з Firestore
    final user = await _firestore.getUser();

    if (!mounted) return;

    setState(() {
      _user = user;
      _isLoading = false;
    });

    // Передаємо завантажені тренування для підрахунку
    _computeStats();
  }

  // compute stats for _visibleMonth, uses user.weightKg if available
  Future<void> _computeStats() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('all_workouts');
    if (raw == null) {
      if (!mounted) return;
      setState(() {
        _totalSets = 0;
        _totalWeight = 0.0;
        _calories = 0.0;
      });
      return;
    }

    late Map<String, dynamic> decoded;
    try {
      final parsed = jsonDecode(raw);
      decoded = (parsed is Map<String, dynamic>) ? parsed : <String, dynamic>{};
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _totalSets = 0;
        _totalWeight = 0.0;
        _calories = 0.0;
      });
      return;
    }

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
    double totalCalories = 0.0;

    const double secondsPerRep = 4.0;
    final double? userWeight = _user?.weightKg;
    final canComputeCalories = userWeight != null;

    decoded.forEach((dateStr, exercisesRaw) {
      DateTime date;
      try {
        date = DateTime.parse(dateStr);
      } catch (_) {
        return;
      }
      if (date.isBefore(firstDayOfMonth) || date.isAfter(lastDayOfMonth)) {
        return;
      }

      final List<dynamic> exerciseList = (exercisesRaw is List<dynamic>)
          ? exercisesRaw
          : <dynamic>[];
      for (final exEntry in exerciseList) {
        if (exEntry is! Map<String, dynamic>) continue;
        final sets = (exEntry['sets'] is List<dynamic>)
            ? exEntry['sets'] as List<dynamic>
            : <dynamic>[];
        final exId = exEntry['exerciseId'] as String?;
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

          if (canComputeCalories) {
            final secondsThisSet = reps * secondsPerRep;
            final minutesThisSet = secondsThisSet / 60.0;
            final kcalPerMin = met * userWeight / 60.0;
            totalCalories += kcalPerMin * minutesThisSet;
          }
        }
      }
    });

    if (!mounted) return;
    setState(() {
      _totalSets = totalSets;
      _totalWeight = totalWeight;
      _calories = totalCalories;
    });
  }

  void _prevMonth() {
    setState(() {
      _slideToLeft = false;
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1, 1);
    });
    _computeStats();
  }

  void _nextMonth() {
    setState(() {
      _slideToLeft = true;
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 1);
    });
    _computeStats();
  }

  Future<void> _onEditProfile(BuildContext ctx) async {
    if (_user == null) return;
    final updated = await Navigator.push<User?>(
      ctx,
      MaterialPageRoute(builder: (_) => EditProfilePage(user: _user!)),
    );
    if (updated != null && mounted) {
      setState(() {
        _user = updated;
      });
      _computeStats();
    }
  }

  void _onProfileUpdated(User updated) {
    if (!mounted) return;
    setState(() => _user = updated);
    _computeStats();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!.localeName;

    final monthName = DateFormat.MMMM(locale).format(_visibleMonth);
    final capitalizedMonth = toBeginningOfSentenceCase(monthName);

    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  //Todo think how to del this scrollable element listView
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ProfileHeader(user: _user, onEditPressed: _onEditProfile),
                      const SizedBox(height: 12),
                      ProfileStatsCard(
                        visibleMonth: _visibleMonth,
                        ukMonthLabel: capitalizedMonth,
                        totalSets: _totalSets,
                        totalWeight: _totalWeight,
                        totalCalories: _calories,
                        onPrevMonth: _prevMonth,
                        onNextMonth: _nextMonth,
                        onPickMonth: (newMonth) {
                          setState(() {
                            _visibleMonth = newMonth;
                          });
                          _computeStats();
                        },
                      ),
                      const SizedBox(height: 12),
                      ProfileSettingsList(
                        user: _user,
                        onProfileUpdated: _onProfileUpdated,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
