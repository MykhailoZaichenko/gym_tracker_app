import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/profile/models/user_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class FriendProfilePage extends StatelessWidget {
  final UserModel friend;

  const FriendProfilePage({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = (friend.name.isNotEmpty == true)
        ? friend.name
        : (friend.name.isNotEmpty == true
              ? friend.name
              : friend.email.split('@')[0]);

    final lastSeen = friend.lastWorkoutDate != null
        ? timeago.format(friend.lastWorkoutDate!, locale: 'uk')
        : 'Невідомо';

    return Scaffold(
      appBar: AppBar(title: Text(name), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Аватарка
            CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              child: Text(
                name[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 40,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "@${friend.name.isNotEmpty == true ? friend.name : friend.email.split('@')[0]}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "Був(ла) у залі: $lastSeen",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Блок загальної статистики
            // Блок загальної статистики
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                  context,
                  "Вага",
                  friend.weightKg != null ? "${friend.weightKg} кг" : "--",
                  Icons.monitor_weight_outlined,
                  Colors.blueAccent,
                ),
                _buildStatItem(
                  context,
                  "Серія",
                  "${friend.currentStreak} тиж.",
                  Icons.local_fire_department,
                  Colors.deepOrange,
                ),
                // 🔥 Новий блок: Тренування за місяць
                _buildStatItem(
                  context,
                  "За місяць",
                  "${friend.workoutsThisMonth} тр.",
                  Icons.calendar_month,
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Блок Рекордів Місяця
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "🏆 Рекорди цього місяця",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            if (friend.monthlyBestWeights.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Поки немає записів про рекорди цього місяця 😔",
                  style: TextStyle(color: Colors.grey),
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
                  itemCount: friend.monthlyBestWeights.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final entry = friend.monthlyBestWeights.entries.elementAt(
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
                      title: Text(
                        entry.key,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: Text(
                        "${entry.value.toInt()} кг",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _buildStatItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
