import 'package:flutter/material.dart';
import 'package:friendlyreminder/models/ContactWithGroupsModel.dart';
import 'package:friendlyreminder/utilities/Utils.dart';

class ContactViewDetailScreen extends StatelessWidget {
  final ContactWithGroupsModel contactWithGroups;

  const ContactViewDetailScreen({Key? key, required this.contactWithGroups})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          onPressed: () => (),
          icon: Icon(Icons.edit),
        )
      ]),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CircleAvatar(
                //   radius: 80,
                //   backgroundColor:
                //       Theme.of(context).colorScheme.secondaryContainer,
                //   child: utils.isAlpha(contactWithGroups.contact.name[0])
                //       ? Text(
                //           '${contactWithGroups.contact.name[0].toUpperCase()}')
                //       : Icon(Icons.person),
                // ),
                Text('Name: ${contactWithGroups.contact.name}',
                    style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 10),
                Text(
                    'Phone: ${contactWithGroups.contact.phone.isNotEmpty ? contactWithGroups.contact.phone : "N/A"}'),
                SizedBox(height: 10),
                Text(
                    'Email: ${contactWithGroups.contact.email.isNotEmpty ? contactWithGroups.contact.email : "N/A"}'),
                SizedBox(height: 10),
                Text('Groups:', style: TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8.0, // gap between adjacent chips
                  runSpacing: 4.0, // gap between lines
                  children: contactWithGroups.groups.map((group) {
                    return Chip(
                      label: Text(group.name),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(contactWithGroups.contact.notes),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
