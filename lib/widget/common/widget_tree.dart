import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/analytics/pages/graf_page.dart';
import 'package:gym_tracker_app/features/workout/pages/journal_page.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';
import 'package:gym_tracker_app/widget/layout/navbar_widget.dart';
import 'package:gym_tracker_app/widget/layout/navigation_state.dart';
import 'package:gym_tracker_app/features/home/pages/home_page.dart';
import 'package:gym_tracker_app/features/profile/pages/profile_page.dart';
import 'package:gym_tracker_app/features/auth/pages/create_username_page.dart';

String? title = 'Gym Tracker';

List<Widget> pages = [JournalPage(), HomePage(), GrafPage(), ProfilePage()];

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  bool _isLoading = true;
  bool _needsUsername = false;
  final FirestoreService _firestore = FirestoreService();

  @override
  void initState() {
    super.initState();
    selectedPageNotifier.value = 0;
    _checkUserData();
  }

  Future<void> _checkUserData() async {
    try {
      final user = await _firestore.getUser().timeout(
        const Duration(seconds: 4),
      );

      if (mounted) {
        setState(() {
          if (user == null || user.name.isEmpty) {
            _needsUsername = true;
          } else if (user.name == 'User' || user.name.contains(' ')) {
            _needsUsername = true;
          } else {
            _needsUsername = false;
          }
        });
      }
    } catch (e) {
      debugPrint('Помилка завантаження профілю у WidgetTree: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_needsUsername) {
      return CreateUsernamePage(
        onUsernameCreated: () {
          setState(() {
            _needsUsername = false;
          });
        },
      );
    }

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (BuildContext context, dynamic selectedPage, Widget? child) {
          if (selectedPage >= pages.length) return pages[0];
          return pages.elementAt(selectedPage);
        },
      ),
      bottomNavigationBar: const NavbarWidget(),
    );
  }
}
