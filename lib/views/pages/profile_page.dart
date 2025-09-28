// lib/views/pages/profile_graf_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_tracker_app/data/notiers.dart';
import 'package:gym_tracker_app/views/pages/settings_page.dart';
import 'package:gym_tracker_app/views/pages/welcome_page.dart';
import '../../db/app_db.dart';
import '../../models/user.dart';

class ProfileGrafPage extends StatefulWidget {
  const ProfileGrafPage({Key? key}) : super(key: key);

  @override
  State<ProfileGrafPage> createState() => _ProfileGrafPageState();
}

class _ProfileGrafPageState extends State<ProfileGrafPage> {
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('current_user_id');
    if (userId == null) {
      setState(() {
        _isLoading = false;
        _user = null;
      });
      return;
    }

    final user = await AppDb().getUserById(userId);
    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('current_user_id');
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
    final name = _user?.name ?? 'Гість';
    final email = _user?.email ?? 'Немає email';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль користувача'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Аватар та ім'я
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(name, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    // Статистика (тимчасові значення — заміни на реальні з бази коли з'являться)
                    Row(
                      children: [
                        _buildStatCard(
                          context,
                          icon: Icons.fitness_center,
                          label: 'Тренувань',
                          value: '0',
                        ),
                        const SizedBox(width: 8),
                        _buildStatCard(
                          context,
                          icon: Icons.local_fire_department,
                          label: 'Калорій',
                          value: '0',
                        ),
                        const SizedBox(width: 8),
                        _buildStatCard(
                          context,
                          icon: Icons.access_time,
                          label: 'Годин',
                          value: '0',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Налаштування профілю
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
                              // TODO: реалізувати редагування профілю (наприклад, Modal або окрема сторінка)
                              // Можна передати _user і дозволити змінювати name/email, оновити через AppDb().updateUser(...)
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
                                  builder: (context) => const SettingsPage(),
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
