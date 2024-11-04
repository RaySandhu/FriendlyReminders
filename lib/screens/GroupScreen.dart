import 'package:flutter/material.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Contacts", style: Theme.of(context).textTheme.headlineMedium),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Center(
            child: Text("Content",
                style: Theme.of(context).textTheme.headlineMedium)),
      ),
    );
  }
}
