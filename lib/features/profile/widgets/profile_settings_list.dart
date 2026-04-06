import 'package:flutter/material.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/auth_service.dart';

import 'package:gym_tracker_app/features/profile/models/user_model.dart';
import 'package:gym_tracker_app/features/profile/pages/settings_page.dart';
import 'package:gym_tracker_app/features/welcome/pages/welcome_page.dart';

class ProfileSettingsList extends StatelessWidget {
  const ProfileSettingsList({
    super.key,
    required this.user,
    required this.onProfileUpdated,
  });

  final UserModel? user;
  final void Function(UserModel updated) onProfileUpdated;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(loc.settingsTitle, style: textTheme.bodyLarge),
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
            title: Text(loc.logoutAction, style: textTheme.bodyLarge),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(loc.logoutTitle, style: textTheme.titleMedium),
                  content: Text(loc.logoutConfirm, style: textTheme.bodyMedium),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text(loc.no, style: textTheme.labelLarge),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: Text(
                        loc.yes,
                        style: textTheme.labelLarge?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await AuthService().logout();

                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomePage()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
