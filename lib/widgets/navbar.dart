import 'package:flutter/material.dart';
import 'package:friendlyreminder/screens/counter_screen.dart';

class NavigationBarApp extends StatefulWidget {
  const NavigationBarApp({super.key});

  @override
  State<NavigationBarApp> createState() => _NavigationBarAppState();
}

class _NavigationBarAppState extends State<NavigationBarApp> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.blueAccent, // RET: Use theme color
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.person),
              label: 'Contacts',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications),
              label: 'Reminders',
            ),
            NavigationDestination(
              icon: Icon(Icons.group),
              label: 'Groups',
            ),
            NavigationDestination(
              icon: Icon(Icons.bug_report),
              label: 'Groups',
            ),
          ],
        ),
        body: [
          CounterScreen(),
          CounterScreen(),
          CounterScreen(),
          CounterScreen()
        ][currentPageIndex]);
  }
}
