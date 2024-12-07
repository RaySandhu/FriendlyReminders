import 'package:flutter/material.dart';
import 'package:friendlyreminder/screens/ContactScreen.dart';
import 'package:friendlyreminder/screens/DatabaseScreen.dart';
import 'package:friendlyreminder/screens/GroupScreen.dart';
import 'package:friendlyreminder/screens/ReminderScreen.dart';
import 'package:friendlyreminder/screens/ColorPaletteScreen.dart';
import 'package:friendlyreminder/screens/TextThemeScreen.dart';

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
          indicatorColor: Theme.of(context).colorScheme.tertiary,
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
            // NavigationDestination(
            //   icon: Icon(Icons.storage),
            //   label: 'Database',
            // ),
            // NavigationDestination(
            //   icon: Icon(Icons.palette),
            //   label: 'Color',
            // ),
            // NavigationDestination(
            //   icon: Icon(Icons.text_fields),
            //   label: 'Text',
            // ),
          ],
        ),
        body: [
          ContactsScreen(),
          ReminderScreen(),
          GroupScreen(),
          // DatabaseScreen(),
          // ColorPaletteScreen(),
          // TextThemePage(),
        ][currentPageIndex]);
  }
}
