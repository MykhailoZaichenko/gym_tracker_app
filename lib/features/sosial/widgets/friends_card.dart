import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/profile/models/user_model.dart';
import 'package:gym_tracker_app/features/sosial/pages/frend_profile_page.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/utils/time_utils.dart';

class FriendCard extends StatelessWidget {
  final UserModel friend;
  final VoidCallback onDelete;

  const FriendCard({super.key, required this.friend, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    final loc = AppLocalizations.of(context)!;
    final lastSeenDate = TimeUtils.formatRelativeTime(
      friend.lastWorkoutDate,
      loc.localeName,
    );

    String bestStat = loc.noRecords;
    if (friend.monthlyBestWeights.isNotEmpty) {
      final bestEntry = friend.monthlyBestWeights.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
      bestStat = "${bestEntry.key}: ${bestEntry.value.toInt()} kg";
    }

    final name = (friend.name.isNotEmpty == true)
        ? friend.name
        : friend.email.split('@')[0];

    final displayUsername = friend.email;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final hasPhoto = friend.avatarUrl != null && friend.avatarUrl!.isNotEmpty;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FriendProfilePage(friend: friend),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.2,
                  ),
                  backgroundImage: hasPhoto
                      ? NetworkImage(friend.avatarUrl!)
                      : null,
                  child: hasPhoto
                      ? null
                      : Text(
                          initial,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                title: Text(name, style: textTheme.titleMedium),
                subtitle: Text(
                  "$displayUsername\n${loc.lastSeenInGym(lastSeenDate)}",
                  style: textTheme.bodyMedium,
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: Colors.deepOrange,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            loc.statWorkouts(friend.currentStreak.toString()),
                            style: textTheme.labelLarge?.copyWith(
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.grey),
                      onSelected: (value) {
                        if (value == 'delete') onDelete();
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person_remove,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                loc.delete,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emoji_events_outlined,
                      size: 18,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 8),
                    Text(loc.monthlyRecordPrefix, style: textTheme.bodySmall),
                    Expanded(
                      child: Text(
                        bestStat,
                        style: textTheme.labelLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
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
