import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key, required this.name, required this.onTap});
  final String name;
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
            : Icon(Icons.person),
      ),
      title: Text(name),
      onTap: onTap,
    );
  }
}
