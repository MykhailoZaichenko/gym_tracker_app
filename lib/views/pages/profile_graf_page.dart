import 'package:flutter/material.dart';
import 'package:gym_tracker_app/data/notiers.dart';
import 'package:gym_tracker_app/views/pages/settings_page.dart';
import 'package:gym_tracker_app/views/pages/welcome_page.dart';

class ProfileGrafPage extends StatelessWidget {
  const ProfileGrafPage({Key? key}) : super(key: key);

  // Утиліта для створення картки зі статистикою
  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // Динамічний колір для іконки та значення
    final iconColor = isDark ? Colors.white : theme.primaryColor;
    final valueColor = iconColor;
    final labelColor = isDark ? Colors.white70 : Colors.grey;
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, size: 28, color: iconColor),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: labelColor)),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Вихід із профілю'),
        content: const Text('Ви дійсно хочете вийти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Ні'),
          ),
          TextButton(
            onPressed: () {
              selectedPageNotifier.value = 0;
              Navigator.of(ctx).pushReplacement(
                MaterialPageRoute(builder: (_) => const WelcomePage()),
              );
            },
            child: const Text('Так'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль користувача'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ——— Аватар та ім'я ———
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                'Імʼя Прізвище',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'email@example.com',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey),
              ),

              const SizedBox(height: 24),

              // ——— Статистика ———
              Row(
                children: [
                  _buildStatCard(
                    context,
                    icon: Icons.fitness_center,
                    label: 'Тренувань',
                    value: '42',
                  ),
                  const SizedBox(width: 8),
                  _buildStatCard(
                    context,
                    icon: Icons.local_fire_department,
                    label: 'Калорій',
                    value: '1 234',
                  ),
                  const SizedBox(width: 8),
                  _buildStatCard(
                    context,
                    icon: Icons.access_time,
                    label: 'Годин',
                    value: '12',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ——— Налаштування профілю ———
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 1,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Редагувати профіль'),
                      onTap: () {
                        // TODO: перейти на екран редагування
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Налаштування'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SettingsPage(title: 'Settings');
                            },
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Вийти'),
                      onTap: () => _confirmLogout(context),
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
