import 'package:flutter/material.dart';
import 'widgets/NavBar.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/viewmodels/ContactViewModel.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ContactsViewModel()..loadContacts(),
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
    );

    return MaterialApp(
      title: 'Friendly Reminder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        textTheme: TextTheme(
          //   displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          //   displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          //   displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          //   headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          //   headlineMedium: TextStyle(fontSize: 20),
          //   headlineSmall: TextStyle(fontSize: 18),
          //   titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 16, color: colorScheme.primary),
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
