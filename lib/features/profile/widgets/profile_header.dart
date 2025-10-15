import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gym_tracker_app/models/user_model.dart';
import 'package:gym_tracker_app/views/pages/welcome_page.dart';

typedef OnMonthChanged = void Function(DateTime newMonth);

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key? key,
    required this.user,
    required this.onEditPressed,
  }) : super(key: key);

  final User? user;
  final Future<void> Function(BuildContext context) onEditPressed;

  @override
  Widget build(BuildContext context) {
    final name = user?.name ?? 'Гість';
    final email = user?.email ?? 'Немає email';
    final avatarPath = user?.avatarUrl;

    Widget avatarWidget() {
      final initial = name.isNotEmpty ? name[0].toUpperCase() : '';
      if (avatarPath != null && avatarPath.isNotEmpty) {
        final file = File(avatarPath);
        if (file.existsSync()) {
          return CircleAvatar(radius: 50, backgroundImage: FileImage(file));
        }
      }
      return CircleAvatar(
        radius: 50,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Text(
          initial,
          style: const TextStyle(color: Colors.white, fontSize: 40),
        ),
      );
    }

    return Column(
      children: [
        avatarWidget(),
        const SizedBox(height: 12),
        Text(name, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          email,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => onEditPressed(context),
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Редагувати'),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Вихід із профілю'),
                    content: const Text('Ви дійсно хочете вийти?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Ні'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Так'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('current_user_id');
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const WelcomePage()),
                  );
                }
              },
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Вийти'),
            ),
          ],
        ),
      ],
    );
  }
}
