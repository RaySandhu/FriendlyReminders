import 'package:flutter/material.dart';
import 'package:friendlyreminder/widgets/GroupCard.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            Text("Contacts", style: Theme.of(context).textTheme.headlineSmall),
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
