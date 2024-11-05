import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key, required this.fname, required this.lname});
  final String fname;
  final String lname;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        child: Text('${fname[0]}${lname[0]}'),
      ),
      title: Text('${fname} ${lname}'),
      onTap: () => print("Clicked"),
    );
  }
}
