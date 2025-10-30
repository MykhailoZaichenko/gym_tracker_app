import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'package:gym_tracker_app/features/profile/models/user_model.dart';
// import 'package:gym_tracker_app/views/pages/welcome_page.dart';

typedef OnMonthChanged = void Function(DateTime newMonth);

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.user,
    required this.onEditPressed,
  });

  final User? user;
  final Future<void> Function(BuildContext context) onEditPressed;

  @override
  Widget build(BuildContext context) {
    final name = user?.name ?? 'Гість';
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
      ],
    );
  }
}
