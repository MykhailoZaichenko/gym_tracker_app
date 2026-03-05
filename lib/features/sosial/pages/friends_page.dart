import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/profile/models/user_model.dart';
import 'package:gym_tracker_app/features/sosial/pages/frend_profile_page.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:share_plus/share_plus.dart';
import 'dart:async';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage>
    with SingleTickerProviderStateMixin {
  final FirestoreService _firestore = FirestoreService();
  late TabController _tabController;

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  Timer? _debounce;
  List<UserModel> _searchResults = [];
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _showDeleteConfirmation(UserModel friend) async {
    final name = friend.name.isNotEmpty == true ? friend.name : friend.email;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Видалення з друзів"),
        content: Text(
          "Ви впевнені, що хочете видалити $name зі списку друзів?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              "Скасувати",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              "Видалити",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        if (friend.id == null || friend.id!.isEmpty) {
          throw Exception("Invalid friend ID");
        }
        await _firestore.removeFriend(friend.id!);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("$name видалено з друзів")));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Помилка видалення: $e"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Друзі та Спільнота'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Мої друзі'),
            Tab(text: 'Пошук / Запити'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildFriendsList(), _buildAddFriendPage()],
      ),
    );
  }

  // --- ВКЛАДКА 1: МОЇ ДРУЗІ ---
  Widget _buildFriendsList() {
    return StreamBuilder<List<UserModel>>(
      stream: _firestore.getFriendsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final friends = snapshot.data ?? [];

        if (friends.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.people_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text("У вас поки немає друзів"),
                TextButton(
                  onPressed: () {
                    _tabController.animateTo(1);
                    Future.delayed(const Duration(milliseconds: 300), () {
                      _searchFocus.requestFocus();
                    });
                  },
                  child: const Text("Знайти друга"),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: friends.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final friend = friends[index];
            return _buildFriendCard(friend);
          },
        );
      },
    );
  }

  Widget _buildFriendCard(UserModel friend) {
    final theme = Theme.of(context);
    final lastSeen = friend.lastWorkoutDate != null
        ? timeago.format(
            friend.lastWorkoutDate!,
            locale: 'uk',
          ) // Можна 'uk' або 'en'
        : 'Давно';

    String bestStat = "Немає рекордів";
    if (friend.monthlyBestWeights.isNotEmpty) {
      final bestEntry = friend.monthlyBestWeights.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
      bestStat = "${bestEntry.key}: ${bestEntry.value.toInt()} кг";
    }

    final name = (friend.name.isNotEmpty == true)
        ? friend.name
        : friend.email.split('@')[0];

    // Якщо в моделі немає username, залишаємо пустим, або додаємо, якщо є
    // Припустимо, що в моделі є поле username, інакше виводимо email
    final displayUsername = friend.email; // Замініть на friend.username якщо є
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // 🔥 Перехід на сторінку деталей друга
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FriendProfilePage(friend: friend),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("$displayUsername\nБув у залі: $lastSeen"),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Блок зі стріком
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: Colors.deepOrange,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${friend.currentStreak} т.",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),

                    // 🔥 Меню з трьома крапками
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.grey),
                      onSelected: (value) {
                        if (value == 'delete') {
                          _showDeleteConfirmation(friend);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_remove,
                                color: Colors.red,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Видалити",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emoji_events_outlined,
                      size: 18,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Рекорд місяця: ",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Expanded(
                      child: Text(
                        bestStat,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
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

  // --- ВКЛАДКА 2: ПОШУК І ЗАПИТИ ---
  Widget _buildAddFriendPage() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Кнопка для поширення посилання
          ElevatedButton.icon(
            onPressed: _shareFriendLink,
            icon: const Icon(Icons.ios_share),
            label: const Text(
              "Поділитися посиланням на профіль",
              style: TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            "Або знайдіть вручну",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // ПОЛЕ ПОШУКУ
          TextField(
            focusNode: _searchFocus,
            controller: _searchController,
            onChanged: _onSearchChanged, // 🔥 Виклик живого пошуку
            decoration: InputDecoration(
              labelText: "Введіть Email або @нікнейм",
              hintText: "example@gmail.com або @gymbro",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              // Динамічна іконка (завантаження, очищення або пошук)
              suffixIcon: _isSearching
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchResults.clear());
                        FocusScope.of(context).unfocus();
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _performSearch,
                    ),
            ),
            onSubmitted: (_) => _performSearch(),
          ),

          // 🔥 ВИПАДАЮЧИЙ СПИСОК (ЖИВИЙ ПОШУК)
          if (_searchResults.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _searchResults.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final user = _searchResults[index];
                  final name = (user.name.isNotEmpty == true)
                      ? user.name
                      : user.email.split('@')[0];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primary.withValues(
                        alpha: 0.2,
                      ),
                      child: Text(
                        name[0].toUpperCase(),
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      user.email,
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: const Size(0, 32),
                      ),
                      onPressed: () => _sendRequestToUser(user),
                      child: const Text("Додати"),
                    ),
                  );
                },
              ),
            ),

          const Divider(height: 40),

          // ВХІДНІ ЗАПИТИ
          const Text(
            "Вхідні запити",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _firestore.getFriendRequests(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(
                  "Помилка: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red),
                );
              }
              final requests = snapshot.data ?? [];
              if (requests.isEmpty) {
                return const Text(
                  "Немає нових запитів",
                  style: TextStyle(color: Colors.grey),
                );
              }

              return Column(
                children: requests.map((req) {
                  final fromName =
                      req['fromName'] as String? ??
                      req['fromEmail'] as String? ??
                      'Невідомий';
                  final fromUid = req['fromUid'] as String?;
                  return Card(
                    child: ListTile(
                      title: Text(fromName),
                      trailing: IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: fromUid != null
                            ? () => _firestore.acceptFriendRequest(fromUid)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- ЛОГІКА ---

  // 1. Поділитися посиланням
  Future<void> _shareFriendLink() async {
    // Якщо у вас немає цього методу, створіть його у FirestoreService
    // або використовуйте просто базове посилання
    final link =
        "gymtracker://addfriend/${FirebaseAuth.instance.currentUser?.uid}";

    await Share.share(
      'Привіт! Додавай мене в друзі у Gym Tracker, щоб слідкувати за моїми тренуваннями: $link',
      subject: 'Запит у друзі Gym Tracker',
    );
  }

  // 2. Логіка відкладеного (живого) пошуку (Debounce)
  void _onSearchChanged(String query) {
    setState(() {}); // Оновлюємо UI, щоб з'явився хрестик
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.trim().isEmpty) {
        if (mounted) setState(() => _searchResults.clear());
        return;
      }

      setState(() => _isSearching = true);

      try {
        // Виклик методу живого пошуку (переконайтеся, що ви додали його в FirestoreService)
        final results = await _firestore.searchUsersLive(query);
        if (mounted) {
          setState(() {
            _searchResults = results;
          });
        }
      } catch (e) {
        // Ігноруємо помилку тихо для живого пошуку
      } finally {
        if (mounted) {
          setState(() => _isSearching = false);
        }
      }
    });
  }

  // 3. Відправка запиту конкретному користувачу (з випадаючого списку)
  Future<void> _sendRequestToUser(UserModel user) async {
    FocusScope.of(context).unfocus();
    try {
      if (user.id!.isEmpty) return;
      await _firestore.sendFriendRequest(user.id!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Запит надіслано до ${user.email}!"),
            backgroundColor: Colors.green,
          ),
        );
        _searchController.clear();
        setState(() => _searchResults.clear());
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Помилка: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  // 4. Ручний пошук при натисканні "Enter" або кнопки Send
  Future<void> _performSearch() async {
    String query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return;

    FocusScope.of(context).unfocus();
    setState(() => _isSearching = true);

    try {
      UserModel? user;

      // Розпізнаємо тип пошуку
      if (query.contains('@') && query.indexOf('@') > 0) {
        user = await _firestore.findUserByEmail(query);
      } else {
        if (query.startsWith('@')) {
          query = query.substring(1);
        }
        // Переконайтеся, що метод findUserByUsername існує у FirestoreService
        // user = await _firestore.findUserByUsername(query);
        // Тимчасово шукаємо тільки по email для надійності:
        user = await _firestore.findUserByEmail(query);
      }

      final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

      if (!mounted) return;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Користувача не знайдено"),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        final userId = user.id;

        if (userId == currentUserUid) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Ви не можете додати самого себе"),
              backgroundColor: Colors.orange,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Помилка даних користувача"),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          await _firestore.sendFriendRequest(userId!);
          _searchController.clear();
          setState(() => _searchResults.clear());

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Запит надіслано!"),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Помилка: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }
}
