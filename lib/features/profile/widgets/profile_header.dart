import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/profile/models/user_model.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/widget/common/avatar_widget.dart';

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
    final loc = AppLocalizations.of(context)!;
    final name = user?.name ?? loc.guest;
    final avatarPath = user?.avatarUrl;

    return Column(
      children: [
        AvatarWidget(name: name, avatarPath: avatarPath, radius: 80),
        const SizedBox(height: 12),
        Text(name, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
      ],
    );
  }
}
