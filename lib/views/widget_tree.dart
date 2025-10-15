import 'package:flutter/material.dart';
import 'package:gym_tracker_app/data/notiers.dart';
import 'package:gym_tracker_app/views/pages/home_calendar_page.dart';
import 'package:gym_tracker_app/features/profile/pages/profile_page.dart';
import 'widgets/navbar_widget.dart';

String? title = 'Gym Tracker';
List<Widget> pages = [HomeCalendarPage(), ProfileGrafPage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title!), centerTitle: true),
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
