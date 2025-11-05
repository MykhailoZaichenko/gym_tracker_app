import 'dart:io';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String? avatarPath; // Local file path or null
  final String name; // To show first letter if no image
  final double radius;
  final VoidCallback? onEditPressed; // optional edit handler
  final VoidCallback? onDeletePressed; // optional delete handler

  const AvatarWidget({
    super.key,
    required this.name,
    this.avatarPath,
    this.radius = 60,
    this.onEditPressed,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '';

    Widget avatarCircle() {
      if (avatarPath != null && avatarPath!.isNotEmpty) {
        final file = File(avatarPath!);
        if (file.existsSync()) {
          return CircleAvatar(radius: radius, backgroundImage: FileImage(file));
        }
      }
      return CircleAvatar(
        radius: radius,
        backgroundColor: theme.colorScheme.primary,
        child: Text(
          initial,
          style: TextStyle(color: Colors.white, fontSize: radius * 0.6),
        ),
      );
    }

    return Column(children: [avatarCircle()]);
  }
}
