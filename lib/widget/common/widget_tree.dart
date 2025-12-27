import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/analytics/pages/graf_page.dart';
import 'package:gym_tracker_app/features/workout/pages/journal_page.dart';
import 'package:gym_tracker_app/widget/layout/navigation_state.dart';
import 'package:gym_tracker_app/features/home/pages/home_page.dart';
import 'package:gym_tracker_app/features/profile/pages/profile_page.dart';
import '../layout/navbar_widget.dart';

String? title = 'Gym Tracker';
List<Widget> pages = [JournalPage(), HomePage(), GrafPage(), ProfilePage()];

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  void initState() {
    super.initState();
    selectedPageNotifier.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (BuildContext context, dynamic selectedPage, Widget? child) {
          if (selectedPage >= pages.length) return pages[0];
          return pages.elementAt(selectedPage);
        },
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
