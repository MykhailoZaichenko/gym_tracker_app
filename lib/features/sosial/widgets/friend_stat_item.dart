import 'package:flutter/material.dart';

class FriendStatItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const FriendStatItem({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
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
          style: textTheme.titleLarge,
        ),
        Text(
          title,
          style: textTheme.bodySmall,
        ),
      ],
    );
  }
}
