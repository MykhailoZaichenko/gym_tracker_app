import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/health/pages/health_page.dart';
import 'package:gym_tracker_app/features/sosial/pages/friends_page.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:gym_tracker_app/core/constants/exercise_meta.dart';
import 'package:gym_tracker_app/features/profile/models/user_model.dart';
import 'package:gym_tracker_app/features/profile/profile_exports.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/widget/common/custome_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

Widget _buildMinimalStatColumn(
  BuildContext context, {
  required String title,
  required String value,
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
  bool hasBadge = false,
}) {
  final theme = Theme.of(context);

  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      width: double
          .infinity, // 🔥 Розтягує клікабельну зону на всю доступну ширину
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(
                  14,
                ), // Трохи збільшив кружечок іконки
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              if (hasBadge)
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? _user;
  bool _isLoading = true;
  double? _latestWeight; // Сюди запишемо актуальну вагу
  final FirestoreService _firestore = FirestoreService();

  Map<String, List<WorkoutExercise>> _allWorkouts = {};

  DateTime _visibleMonth = DateTime.now();

  int _totalSets = 0;
  double _totalWeight = 0.0;
  double _calories = 0.0;
  // ignore: unused_field
  bool _slideToLeft = true;

  // --- Змінні для Аватарки ---
  final ImagePicker _picker = ImagePicker();
  bool _isPickingAvatar = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final user = await _firestore.getUser();
    final workouts = await _firestore.getAllWorkouts();

    double? latestWeight;

    // 🔥 Дістаємо АКТУАЛЬНУ вагу з історії (щоб не показувало ту, що була при реєстрації)
    if (user != null) {
      try {
        final weightDocs = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .collection('body_weight')
            .orderBy('date', descending: true)
            .limit(1)
            .get();
        if (weightDocs.docs.isNotEmpty) {
          latestWeight = (weightDocs.docs.first.data()['weight'] as num?)
              ?.toDouble();
        }
      } catch (_) {}
    }

    if (!mounted) return;

    setState(() {
      _user = user;
      _allWorkouts = workouts;
      _latestWeight = latestWeight;
      _isLoading = false;
    });

    _recalculateStats();
  }

  void _recalculateStats() {
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
    final double? userWeight = _latestWeight;
    final canComputeCalories = userWeight != null;

    _allWorkouts.forEach((dateStr, exercises) {
      DateTime date;
      try {
        date = DateTime.parse(dateStr);
      } catch (_) {
        return;
      }

      if (date.isBefore(firstDayOfMonth) || date.isAfter(lastDayOfMonth)) {
        return;
      }

      for (final ex in exercises) {
        final exId = ex.exerciseId;
        final met = (exId != null && kExerciseMet.containsKey(exId))
            ? kExerciseMet[exId]!
            : 4.0;

        for (final s in ex.sets) {
          final reps = s.reps ?? 0;
          final weight = s.weight ?? 0.0;
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
    _recalculateStats();
  }

  void _nextMonth() {
    setState(() {
      _slideToLeft = true;
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 1);
    });
    _recalculateStats();
  }

  // --- ЛОГІКА ЗБЕРЕЖЕННЯ АВАТАРКИ ---
  Future<Directory> _appDir() async {
    return await getApplicationDocumentsDirectory();
  }

  Future<String?> _copyFileToAppDir(String sourcePath, {String? userId}) async {
    try {
      final src = File(sourcePath);
      if (!await src.exists()) return null;
      final appDir = await _appDir();
      final safeName =
          '${userId ?? 'anon'}_${DateTime.now().millisecondsSinceEpoch}${p.extension(sourcePath)}';
      final destPath = p.join(appDir.path, 'avatars');
      final destDir = Directory(destPath);
      if (!await destDir.exists()) await destDir.create(recursive: true);
      final destFile = File(p.join(destPath, safeName));
      final copied = await src.copy(destFile.path);
      return copied.path;
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickAvatar() async {
    if (_isPickingAvatar || _user == null) return;
    _isPickingAvatar = true;
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked == null) return;

      final newPath = await _copyFileToAppDir(picked.path, userId: _user!.id);
      if (newPath == null) return;

      // Оновлюємо користувача в базі
      final updatedUser = _user!.copyWith(avatarUrl: newPath);
      await _firestore.saveUser(updatedUser);

      if (mounted) {
        setState(() {
          _user = updatedUser;
        });
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.show(
          context,
          message: 'Помилка вибору фото: $e',
          isError: true,
        );
      }
    } finally {
      _isPickingAvatar = false;
    }
  }

  void _onProfileUpdated(UserModel updated) {
    if (!mounted) return;
    setState(() => _user = updated);
    _recalculateStats();
  }

  // 🔥 Метод для правильного відображення аватарки (Google URL або локальний файл)
  ImageProvider? _getAvatarProvider(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('http')) {
      return NetworkImage(url); // Для Google фото
    } else {
      return FileImage(File(url)); // Для локальних фото
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final locale = AppLocalizations.of(context)!.localeName;
    final monthName = DateFormat.MMMM(locale).format(_visibleMonth);
    final capitalizedMonth = toBeginningOfSentenceCase(monthName);
    final listPadding = MediaQuery.of(context).size.width * 0.05;
    final name = (_user?.name.isNotEmpty == true)
        ? _user!.name
        : (_user?.email != null ? _user!.email.split('@')[0] : "Користувач");
    final double? currentWeight = _latestWeight;
    final bool hasWeight = currentWeight != null && currentWeight > 0;
    final String weightDisplay = hasWeight
        ? "$currentWeight кг"
        : loc.weightNotSet;

    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      // --- HEADER ПРОФІЛЮ ---
                      Center(
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                // Аватарка
                                CircleAvatar(
                                  radius: 65,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.1),
                                  backgroundImage: _getAvatarProvider(
                                    _user?.avatarUrl,
                                  ),
                                  child:
                                      (_user?.avatarUrl == null ||
                                          _user!.avatarUrl!.isEmpty)
                                      ? Icon(
                                          Icons.person,
                                          size: 65,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: 0.5),
                                        )
                                      : null,
                                ),
                                // Іконка редагування (ручка)
                                GestureDetector(
                                  onTap: _pickAvatar,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF006D5B,
                                      ), // Темно зелений як на фото
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(
                                          context,
                                        ).scaffoldBackgroundColor,
                                        width: 4,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Нікнейм під фото
                            Text(
                              "@$name",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (!hasWeight)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: listPadding + 3,
                            vertical: 8,
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (context) => const HealthPage(),
                                    ),
                                  )
                                  .then((_) => _loadData());
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent.withValues(
                                  alpha: 0.1,
                                ),
                                border: Border.all(
                                  color: Colors.orangeAccent.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    color: Colors.orangeAccent,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      loc.weightMissingBanner, // Використовуємо локалізацію
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.orangeAccent,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 12),

                      // --- КАРТКИ "ВАГА" ТА "ДРУЗІ" ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              // 🔥 Займає рівно 50% ширини
                              child: _buildMinimalStatColumn(
                                context,
                                title: "Вага",
                                value: weightDisplay,
                                icon: Icons.monitor_weight_outlined,
                                color: hasWeight
                                    ? Colors.blueAccent
                                    : Colors.orangeAccent,
                                onTap: () {
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HealthPage(),
                                        ),
                                      )
                                      .then((_) => _loadData());
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: StreamBuilder<List<Map<String, dynamic>>>(
                                stream: _firestore.getFriendRequests(),
                                builder: (context, snapshot) {
                                  // Перевіряємо чи є хоч один запит
                                  final hasRequests =
                                      snapshot.hasData &&
                                      snapshot.data!.isNotEmpty;

                                  return _buildMinimalStatColumn(
                                    context,
                                    title: "Друзі",
                                    value: "Спільнота",
                                    icon: Icons.group_outlined,
                                    color: Colors.purpleAccent,
                                    hasBadge: hasRequests,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const FriendsPage(),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // --- ПРОГРЕС ТА СТАТИСТИКА ---
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
                          _recalculateStats();
                        },
                      ),

                      const SizedBox(height: 12),

                      // --- НАЛАШТУВАННЯ ТА ВИХІД ---
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: listPadding + 3,
                        ),
                        child: ProfileSettingsList(
                          user: _user,
                          onProfileUpdated: _onProfileUpdated,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
