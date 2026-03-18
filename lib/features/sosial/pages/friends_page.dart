import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/profile/models/user_model.dart';
import 'package:gym_tracker_app/features/sosial/widgets/friends_card.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';
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

  Future<void> _showDeleteConfirmation(
    UserModel friend,
    AppLocalizations loc,
  ) async {
    final name = friend.name.isNotEmpty == true ? friend.name : friend.email;
    final textTheme = Theme.of(context).textTheme;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.deleteFriendTitle, style: textTheme.titleLarge),
        content: Text(loc.deleteFriendConfirmBody(name), style: textTheme.bodyLarge),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(loc.cancel, style: textTheme.labelLarge?.copyWith(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              loc.delete,
              style: textTheme.labelLarge?.copyWith(color: Colors.white),
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.friendDeletedSuccess(name), style: textTheme.bodyMedium)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc.deleteError(e.toString()), style: textTheme.bodyMedium),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.friendsAndCommunity, style: textTheme.titleLarge),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: loc.myFriendsTab),
            Tab(text: loc.searchRequestsTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildFriendsList(loc), _buildAddFriendPage(loc)],
      ),
    );
  }

  Widget _buildFriendsList(AppLocalizations loc) {
    final textTheme = Theme.of(context).textTheme;

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
                Text(loc.noFriendsYet, style: textTheme.bodyLarge),
                TextButton(
                  onPressed: () {
                    _tabController.animateTo(1);
                    Future.delayed(const Duration(milliseconds: 300), () {
                      _searchFocus.requestFocus();
                    });
                  },
                  child: Text(loc.findFriendBtn, style: textTheme.labelLarge),
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
            return FriendCard(
              friend: friends[index],
              onDelete: () => _showDeleteConfirmation(friends[index], loc),
            );
          },
        );
      },
    );
  }

  Widget _buildAddFriendPage(AppLocalizations loc) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: () => _shareFriendLink(loc),
            icon: const Icon(Icons.ios_share),
            label: Text(
              loc.shareProfileLink,
              style: textTheme.bodyLarge,
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: theme.colorScheme.primaryContainer,
              foregroundColor: theme.colorScheme.onPrimaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            loc.orFindManually,
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 10),

          TextField(
            focusNode: _searchFocus,
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              labelText: loc.searchFriendHint,
              hintText: loc.searchFriendHelper,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
                      onPressed: () => _performSearch(loc),
                    ),
            ),
            onSubmitted: (_) => _performSearch(loc),
          ),

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
                      style: textTheme.labelLarge,
                    ),
                    subtitle: Text(
                      user.email,
                      style: textTheme.bodySmall,
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: const Size(0, 32),
                      ),
                      onPressed: () => _sendRequestToUser(user, loc),
                      child: Text(loc.addBtn, style: textTheme.labelLarge),
                    ),
                  );
                },
              ),
            ),

          const Divider(height: 40),

          Text(
            loc.incomingRequests,
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _firestore.getFriendRequests(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(
                  "Error: ${snapshot.error}",
                  style: textTheme.bodyMedium?.copyWith(color: Colors.red),
                );
              }
              final requests = snapshot.data ?? [];
              if (requests.isEmpty) {
                return Text(
                  loc.noNewRequests,
                  style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                );
              }

              return Column(
                children: requests.map((req) {
                  final fromName =
                      req['fromName'] as String? ??
                      req['fromEmail'] as String? ??
                      'Unknown';
                  final fromUid = req['fromUid'] as String?;
                  return Card(
                    child: ListTile(
                      title: Text(fromName, style: textTheme.bodyLarge),
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

  Future<void> _shareFriendLink(AppLocalizations loc) async {
    final link =
        "gymtracker://addfriend/${FirebaseAuth.instance.currentUser?.uid}";

    // ignore: deprecated_member_use
    await Share.share(
      loc.shareFriendText(link),
      subject: loc.shareFriendSubject,
    );
  }

  void _onSearchChanged(String query) {
    setState(() {});
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.trim().isEmpty) {
        if (mounted) setState(() => _searchResults.clear());
        return;
      }

      setState(() => _isSearching = true);

      try {
        final results = await _firestore.searchUsersLive(query);
        if (mounted) {
          setState(() {
            _searchResults = results;
          });
        }
      } catch (e) {
        // Ignore silent error
      } finally {
        if (mounted) {
          setState(() => _isSearching = false);
        }
      }
    });
  }

  Future<void> _sendRequestToUser(UserModel user, AppLocalizations loc) async {
    final textTheme = Theme.of(context).textTheme;

    FocusScope.of(context).unfocus();
    try {
      if (user.id!.isEmpty) return;
      await _firestore.sendFriendRequest(user.id!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.requestSentTo(user.email), style: textTheme.bodyMedium),
            backgroundColor: Colors.green,
          ),
        );
        _searchController.clear();
        setState(() => _searchResults.clear());
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e", style: textTheme.bodyMedium),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _performSearch(AppLocalizations loc) async {
    final textTheme = Theme.of(context).textTheme;
    String query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return;

    FocusScope.of(context).unfocus();
    setState(() => _isSearching = true);

    try {
      UserModel? user;

      if (query.contains('@') && query.indexOf('@') > 0) {
        user = await _firestore.findUserByEmail(query);
      } else {
        if (query.startsWith('@')) {
          query = query.substring(1);
        }
        user = await _firestore.findUserByEmail(query);
      }

      final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

      if (!mounted) return;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.userNotFound, style: textTheme.bodyMedium),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        final userId = user.id;

        if (userId == currentUserUid) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc.cannotAddSelf, style: textTheme.bodyMedium),
              backgroundColor: Colors.orange,
            ),
          );
        } else {
          await _firestore.sendFriendRequest(userId!);
          _searchController.clear();
          setState(() => _searchResults.clear());

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(loc.requestSentSuccess, style: textTheme.bodyMedium),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e", style: textTheme.bodyMedium),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }
}
