import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GroupCard extends StatelessWidget {
  const GroupCard(
      {super.key,
      required this.name,
      required this.numMembers,
      required this.onTap});
  final String name;
  final int numMembers;
  final VoidCallback onTap;

  bool isAlpha(String str) {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(str);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        child: isAlpha(name[0])
            ? Text('${name[0].toUpperCase()}')
            : Icon(Icons.group),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(name),
            flex: 6,
          ),
          Spacer(),
          Expanded(
            child: Text("${numMembers}"),
            flex: 1,
          ),
          Icon(Icons.person),
        ],
      ),
      onTap: onTap,
    );
  }
}
