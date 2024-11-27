import 'package:flutter/material.dart';
import 'package:friendlyreminder/models/ContactWithGroupsModel.dart';
import 'package:friendlyreminder/widgets/ContactInfoListTile.dart';

class ContactViewDetailScreen extends StatelessWidget {
  final ContactWithGroupsModel contactWithGroups;

  const ContactViewDetailScreen({Key? key, required this.contactWithGroups})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _noteController =
        TextEditingController(text: contactWithGroups.contact.notes);

    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          onPressed: () => (),
          icon: const Icon(Icons.edit),
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
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: Image.network(
                              "https://picsum.photos/id/89/1800/500?blur=10",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 85),
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
                                  const SizedBox(height: 5),
                                  Text(contactWithGroups.contact.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge),
                                ],
                              ),
                            if (contactWithGroups.contact.phone.isNotEmpty)
                              ContactInfoListTile(
                                prefixIcon: Icons.phone,
                                title: "PHONE",
                                content: contactWithGroups.contact.phone,
                                onTap: () => (),
                              ),
                            if (contactWithGroups.contact.email.isNotEmpty)
                              ContactInfoListTile(
                                prefixIcon: Icons.email,
                                title: "EMAIL",
                                content: contactWithGroups.contact.email,
                                onTap: () => (),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (contactWithGroups.groups.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(height: 3),
                        Card(
                            child: Container(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "GROUPS",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Wrap(
                                  spacing: 8.0, // gap between adjacent chips
                                  runSpacing: 4.0, // gap between lines
                                  children:
                                      contactWithGroups.groups.map((group) {
                                    return ActionChip(
                                      label: Text(group.name),
                                      onPressed: () {
                                        print("Group: ${group.name}");
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  const SizedBox(height: 3),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "NOTES",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          // Text(contactWithGroups.contact.notes),
                          TextField(
                            controller: _noteController,
                            maxLines: null, // Allows for multi-line input
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter your note...',
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            onChanged: (text) {
                              // Handle changes if needed
                              print('Current note: $text');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
