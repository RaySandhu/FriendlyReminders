import 'package:flutter/material.dart';
import 'package:friendlyreminder/widgets/GroupCard.dart';

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
          child: Column(
        children: [
          GroupCard(name: "Art", numMembers: 10, onTap: () => print("Hello")),
          GroupCard(
              name: "(Test)", numMembers: 100, onTap: () => print("Hello")),
          GroupCard(
              name: "Billy Sutton",
              numMembers: 100,
              onTap: () => print("Hello")),
        ],
      )),
    );
  }
}
