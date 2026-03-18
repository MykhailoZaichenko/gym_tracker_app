import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/profile/models/user_model.dart';
import 'package:gym_tracker_app/features/sosial/widgets/friend_stat_item.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';
import 'package:gym_tracker_app/utils/time_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendProfilePage extends StatefulWidget {
  final UserModel friend;

  const FriendProfilePage({super.key, required this.friend});

  @override
  State<FriendProfilePage> createState() => _FriendProfilePageState();
}

class _FriendProfilePageState extends State<FriendProfilePage> {
  final FirestoreService _firestore = FirestoreService();

  bool _isLoading = true;
  double? _latestWeight;
  int _workoutsThisMonth = 0;
  Map<String, double> _monthlyRecords = {};

  @override
  void initState() {
    super.initState();
    _loadFriendData();
  }

  Future<void> _loadFriendData() async {
    String friendId = widget.friend.id ?? '';

    // Якщо ID пустий, шукаємо по email
    if (friendId.isEmpty && widget.friend.email.isNotEmpty) {
      try {
        final snap = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: widget.friend.email)
            .limit(1)
            .get();
        if (snap.docs.isNotEmpty) friendId = snap.docs.first.id;
      } catch (_) {}
    }

    if (friendId.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    // 1. Отримуємо ВАГУ
    double? weight = await _firestore.getFriendLatestWeight(friendId);
    if (weight == 0) weight = null;

    // 2. Отримуємо ТРЕНУВАННЯ
    final workoutsList = await _firestore.getFriendWorkoutsList(friendId);

    final now = DateTime.now();
    int count = 0;
    Map<String, double> records = {};

    for (var wData in workoutsList) {
      try {
        DateTime? date;

        if (wData['date'] != null) {
          if (wData['date'] is Timestamp) {
            date = (wData['date'] as Timestamp)
                .toDate(); // Якщо це Timestamp Firebase
          } else {
            date = DateTime.tryParse(wData['date'].toString()); // Якщо текст
          }
        }
        // Якщо поля date взагалі немає, пробуємо взяти дату з назви документа
        date ??= DateTime.tryParse(wData['docId'].toString());

        // Якщо дата належить цьому місяцю
        if (date != null && date.year == now.year && date.month == now.month) {
          count++;

          final exercisesList = wData['exercises'];
          if (exercisesList is List) {
            for (var exData in exercisesList) {
              if (exData is Map) {
                final mapData = Map<String, dynamic>.from(exData);
                final exercise = WorkoutExercise.fromMap(mapData);

                for (var set in exercise.sets) {
                  final w = set.weight ?? 0.0;
                  if (w > (records[exercise.name] ?? 0.0)) {
                    records[exercise.name] = w;
                  }
                }
              }
            }
          }
        }
      } catch (e) {
        debugPrint("Помилка обробки тренування: $e");
      }
    }

    if (mounted) {
      setState(() {
        _latestWeight = weight;
        _workoutsThisMonth = count;
        _monthlyRecords = records;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final friend = widget.friend;
    final loc = AppLocalizations.of(context)!;

    final name = (friend.name.isNotEmpty == true)
        ? friend.name
        : (friend.name.isNotEmpty == true
              ? friend.name
              : friend.email.split('@')[0]);

    final lastSeen = TimeUtils.formatRelativeTime(
      friend.lastWorkoutDate,
      loc.localeName,
    );

    final hasPhoto = friend.avatarUrl != null && friend.avatarUrl!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(name), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Аватарка
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.colorScheme.primary.withValues(
                      alpha: 0.1,
                    ),
                    backgroundImage: hasPhoto
                        ? NetworkImage(friend.avatarUrl!)
                        : null,
                    child: hasPhoto
                        ? null
                        : Text(
                            name[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 40,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text("@$name", style: textTheme.titleLarge),
                  Text(loc.lastSeenInGym(lastSeen), style: textTheme.bodySmall),
                  const SizedBox(height: 30),

                  // Блок загальної статистики
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FriendStatItem(
                        title: loc.statWeight,
                        value: _latestWeight != null
                            ? "$_latestWeight кг"
                            : "--",
                        icon: Icons.monitor_weight_outlined,
                        color: Colors.blueAccent,
                      ),
                      FriendStatItem(
                        title: loc.statStreak,
                        value: loc.statWeeks(friend.currentStreak.toString()),
                        icon: Icons.local_fire_department,
                        color: Colors.deepOrange,
                      ),
                      FriendStatItem(
                        title: loc.statPerMonth,
                        value: loc.statWorkouts(_workoutsThisMonth.toString()),
                        icon: Icons.calendar_month,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Блок Рекордів Місяця
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      loc.recordsThisMonth,
                      style: textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Використовуємо підраховані рекорди
                  if (_monthlyRecords.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        loc.noRecordsThisMonth,
                        style: textTheme.bodySmall,
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.dividerColor.withValues(alpha: 0.1),
                        ),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _monthlyRecords.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final entry = _monthlyRecords.entries.elementAt(
                            index,
                          );

                          return ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.fitness_center,
                                color: Colors.amber,
                                size: 20,
                              ),
                            ),
                            title: Text(entry.key, style: textTheme.labelLarge),
                            trailing: Text(
                              "${entry.value.toStringAsFixed(1).replaceAll('.0', '')} kg",
                              style: textTheme.titleMedium,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
