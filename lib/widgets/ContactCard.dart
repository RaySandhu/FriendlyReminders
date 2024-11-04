import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: const Text('JD'),
      ),
      title: Text('John Doe'),
      onTap: () => print("Clicked"),
    );
  }
}
