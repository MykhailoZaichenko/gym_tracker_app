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

    ImageProvider? getImageProvider() {
      if (avatarPath != null && avatarPath!.isNotEmpty) {
        // 1. Перевірка на URL (Google Photo)
        if (avatarPath!.startsWith('http')) {
          return NetworkImage(avatarPath!);
        }

        // 2. Перевірка на локальний файл
        final file = File(avatarPath!);
        if (file.existsSync()) {
          return FileImage(file);
        }
      }
      return null;
    }

    final imageProvider = getImageProvider();

    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: radius,
              backgroundColor: theme.colorScheme.primary,
              backgroundImage: imageProvider,
              child: imageProvider == null
                  ? Text(
                      initial,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: radius * 0.8, // Трохи збільшив шрифт
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),

            // Кнопка редагування (якщо передана)
            if (onEditPressed != null)
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: onEditPressed,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),

        // Кнопка видалення (якщо передана і є аватар)
        if (onDeletePressed != null && avatarPath != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: InkWell(
              onTap: onDeletePressed,
              child: Text(
                'Видалити фото', // Можна локалізувати
                style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}
