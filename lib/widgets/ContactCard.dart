import 'package:flutter/material.dart';
import 'package:friendlyreminder/utilities/Utils.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key, required this.name, required this.onTap});
  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        child: utils.isAlpha(name[0])
            ? Text('${name[0].toUpperCase()}')
            : Icon(Icons.person),
      ),
      title: Text(name),
      onTap: onTap,
    );
  }
}
