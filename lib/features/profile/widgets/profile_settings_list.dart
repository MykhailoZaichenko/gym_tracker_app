import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gym_tracker_app/features/profile/models/user_model.dart';
import 'package:gym_tracker_app/views/pages/edit_profile_page.dart';
import 'package:gym_tracker_app/views/pages/settings_page.dart';
import 'package:gym_tracker_app/views/pages/welcome_page.dart';

class ProfileSettingsList extends StatelessWidget {
  const ProfileSettingsList({
    super.key,
    required this.user,
    required this.onProfileUpdated,
  });

  final User? user;
  final void Function(User updated) onProfileUpdated;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Редагувати профіль'),
            onTap: () async {
              if (user == null) return;
              final updated = await Navigator.push<User?>(
                context,
                MaterialPageRoute(builder: (_) => EditProfilePage(user: user!)),
              );
              if (updated != null) {
                onProfileUpdated(updated);
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
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Вийти'),
            onTap: () async {
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
          ),
        ],
      ),
    );
  }
}
