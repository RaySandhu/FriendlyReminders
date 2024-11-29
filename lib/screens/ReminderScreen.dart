import 'package:flutter/material.dart';
import 'package:friendlyreminder/widgets/ReminderCard.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Reminders",
              style: Theme.of(context).textTheme.headlineSmall),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SafeArea(
          child: Center(
              child: Column(
            children: [
              ReminderCard(
                  name: "Alice",
                  onTap: () => print("Reminder Card"),
                  onAccept: () => print("Accept"),
                  onDismiss: () => print("Dismiss"),
                  onReject: () => print("Reject"))
            ],
          )),
        ));
  }
}
