import 'package:flutter/material.dart';
import 'package:gym_tracker_app/widget/layout/navigation_state.dart';
import 'package:gym_tracker_app/features/home/pages/home_page.dart';
import 'package:gym_tracker_app/features/profile/pages/profile_page.dart';
import '../layout/navbar_widget.dart';

String? title = 'Gym Tracker';
List<Widget> pages = [HomeCalendarPage(), ProfileGrafPage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (BuildContext context, dynamic selectedPage, Widget? child) {
          return pages.elementAt(selectedPage);
        },
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
