import 'package:flutter/material.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/widget/layout/navigation_state.dart';

class NavbarWidget extends StatefulWidget {
  const NavbarWidget({super.key});

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (BuildContext context, dynamic selectedPage, Widget? child) {
        return NavigationBar(
          selectedIndex: selectedPage >= 4 ? 0 : selectedPage, // Захист
          onDestinationSelected: (int value) {
            selectedPageNotifier.value = value;
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.today),
              selectedIcon: const Icon(Icons.today_outlined),
              label: loc.navJournal, // "Щоденник"
            ),
            NavigationDestination(
              icon: const Icon(Icons.calendar_month_outlined),
              selectedIcon: const Icon(Icons.calendar_month),
              label: loc.navHistory, // "Історія"
            ),
            NavigationDestination(
              icon: const Icon(Icons.bar_chart),
              label: loc.navStats, // "Статистика"
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: loc.navProfile, // "Профіль"
            ),
          ],
          // onDestinationSelected: (int value) {
          //   selectedPageNotifier.value = value;
          // },
          // selectedIndex: selectedPage,
        );
      },
    );
  }
}
