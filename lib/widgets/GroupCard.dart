import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:friendlyreminder/utilities/Utils.dart';

class GroupCard extends StatelessWidget {
  final String name;
  final int numMembers;
  final VoidCallback onTap;

  const GroupCard(
      {super.key,
      required this.name,
      required this.numMembers,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        child: utils.isAlpha(name[0])
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
