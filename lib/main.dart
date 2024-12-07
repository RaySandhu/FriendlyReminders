import 'package:flutter/material.dart';
import 'widgets/NavBar.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/viewmodels/ContactViewModel.dart';
import 'package:friendlyreminder/viewmodels/GroupViewModel.dart';
import 'package:friendlyreminder/viewmodels/ReminderViewModel.dart';
import 'package:friendlyreminder/viewmodels/AIPromptViewModel.dart';
import 'package:friendlyreminder/viewmodels/SharedState.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SharedState()),
        ChangeNotifierProxyProvider<SharedState, ContactsViewModel>(
          create: (context) =>
              ContactsViewModel(context.read<SharedState>())..loadContacts(),
          update: (context, sharedState, previous) =>
              previous ?? ContactsViewModel(sharedState)
                ..loadContacts(),
        ),
        ChangeNotifierProxyProvider<SharedState, GroupViewModel>(
          create: (context) =>
              GroupViewModel(context.read<SharedState>())..loadGroups(),
          update: (context, sharedState, previous) =>
              previous ?? GroupViewModel(sharedState)
                ..loadGroups(),
        ),
        ChangeNotifierProvider(
          create: (context) => AIPromptViewModel()..loadPrompts(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ReminderViewModel()..renderCurrentPastReminders(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      tertiary: Colors.deepPurple.shade300,
    );

    return MaterialApp(
      title: 'Friendly Reminder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        fontFamily: 'Rubik',
        textTheme: TextTheme(
          //   displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          //   displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          //   displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          //   headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          //   headlineMedium: TextStyle(fontSize: 20),
          //   headlineSmall: TextStyle(fontSize: 18),
          //   titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),        fontFamily: 'Montserrat',
          titleMedium: TextStyle(fontSize: 16, color: Colors.deepPurple),
          //   titleSmall: TextStyle(fontSize: 12),
          //   bodyLarge: TextStyle(fontSize: 16),
          //   bodyMedium: TextStyle(fontSize: 14),
          //   bodySmall: TextStyle(fontSize: 12),
          //   labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          //   labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          //   labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        colorScheme: colorScheme,
        useMaterial3: true,
      ),
      home: const NavigationBarApp(),
    );
  }
}
