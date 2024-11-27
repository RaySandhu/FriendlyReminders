import 'package:flutter/material.dart';
import 'package:friendlyreminder/models/ContactWithGroupsModel.dart';
import 'package:friendlyreminder/utilities/Utils.dart';
import 'package:friendlyreminder/widgets/ContactInfoListTile.dart';
import 'package:friendlyreminder/widgets/StyledTextField.dart';

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
            child: Center(
              child: Column(
                children: [
                  Card(
                    child: Stack(
                      children: [
                        Container(
                          height: 130,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: Image.network(
                              "https://picsum.photos/id/89/1800/500?blur=10",
                              // "https://picsum.photos/id/261/1500/500?blur=10",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              SizedBox(height: 85),
                              CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  child: const Icon(
                                    Icons.person,
                                    size: 50,
                                  ),
                                ),
                              ),
                              if (contactWithGroups.contact.name.isNotEmpty)
                                Column(
                                  children: [
                                    SizedBox(height: 5),
                                    Text('${contactWithGroups.contact.name}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge),
                                  ],
                                ),
                              if (contactWithGroups.contact.phone.isNotEmpty)
                                ContactInfoListTile(
                                  prefixIcon: Icons.phone,
                                  title: contactWithGroups.contact.phone,
                                  onTap: () => (),
                                ),
                              if (contactWithGroups.contact.email.isNotEmpty)
                                ContactInfoListTile(
                                  prefixIcon: Icons.email,
                                  title: contactWithGroups.contact.email,
                                  onTap: () => (),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Groups:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
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
      ),
    );
  }
}
