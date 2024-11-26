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
    return MaterialApp(
      title: 'Friendly Reminder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        textTheme: const TextTheme(
            //   displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            //   displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            //   displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            //   headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            //   headlineMedium: TextStyle(fontSize: 20),
            //   headlineSmall: TextStyle(fontSize: 18),
            //   titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //   titleMedium: TextStyle(fontSize: 14),
            //   titleSmall: TextStyle(fontSize: 12),
            //   bodyLarge: TextStyle(fontSize: 16),
            //   bodyMedium: TextStyle(fontSize: 14),
            //   bodySmall: TextStyle(fontSize: 12),
            //   labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            //   labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            //   labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NavigationBarApp(),
    );
  }
}
