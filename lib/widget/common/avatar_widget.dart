import 'dart:io';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String? avatarPath;
  final String name;
  final double radius;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

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

            if (onEditPressed != null)
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: onEditPressed,
                  child: Container(
                    padding: const EdgeInsets.all(10),
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
            if (onDeletePressed != null && avatarPath != null)
              Positioned(
                bottom: 0,
                left: 0,
                child: InkWell(
                  onTap: onDeletePressed,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 189, 0, 0),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.delete,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),

        // if (onDeletePressed != null && avatarPath != null)
        //   Padding(
        //     padding: const EdgeInsets.only(top: 8.0),
        //     child: InkWell(
        //       onTap: onDeletePressed,
        //       child: Text(
        //         loc.delPhoto, // Можна локалізувати
        //         style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
