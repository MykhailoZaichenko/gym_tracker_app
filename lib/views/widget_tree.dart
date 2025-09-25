import 'package:flutter/material.dart';
// import 'package:gym_tracker_app/data/constants.dart';
import 'package:gym_tracker_app/data/notiers.dart';
import 'package:gym_tracker_app/views/pages/home_calendar_page.dart';
import 'package:gym_tracker_app/views/pages/profile_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/navbar_widget.dart';

String? title = 'Gym Tracker';
List<Widget> pages = [HomeCalendarPage(), ProfileGrafPage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
        centerTitle: true,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 5.0),
        //     child: IconButton(
        //       onPressed: () async {
        //         isDarkModeNotifier.value = !isDarkModeNotifier.value;
        //         final SharedPreferences prefs =
        //             await SharedPreferences.getInstance();
        //         await prefs.setBool(
        //           KCOnstats.themeModeKey,
        //           isDarkModeNotifier.value,
        //         );
        //       },
        //       icon: ValueListenableBuilder(
        //         valueListenable: isDarkModeNotifier,
        //         builder:
        //             (BuildContext context, dynamic isDarkMode, Widget? child) {
        //               return Icon(
        //                 isDarkMode ? Icons.light_mode : Icons.dark_mode,
        //               );
        //             },
        //       ),
        //     ),
        //   ),
        // ],
      ),
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
