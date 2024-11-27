import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/viewmodels/ContactViewModel.dart';
import 'package:friendlyreminder/models/ContactWithGroupsModel.dart';
import 'package:friendlyreminder/widgets/ContactInfoListTile.dart';

class ContactViewDetailScreen extends StatefulWidget {
  final ContactWithGroupsModel contactWithGroups;

  const ContactViewDetailScreen({Key? key, required this.contactWithGroups})
      : super(key: key);

  @override
  State<ContactViewDetailScreen> createState() =>
      _ContactViewDetailScreenState();
}

class _ContactViewDetailScreenState extends State<ContactViewDetailScreen> {
  late ContactWithGroupsModel _contactWithGroups;
  late TextEditingController _noteController;
  bool _hasNotesChanged = false;

  @override
  void initState() {
    super.initState();
    _contactWithGroups = widget.contactWithGroups;
    _noteController =
        TextEditingController(text: _contactWithGroups.contact.notes);
    _noteController.addListener(() {
      setState(() {
        _hasNotesChanged =
            _noteController.text != _contactWithGroups.contact.notes;
      });
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contactVM = Provider.of<ContactsViewModel>(context, listen: false);

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
                            if (_contactWithGroups.contact.name.isNotEmpty)
                              Column(
                                children: [
                                  const SizedBox(height: 5),
                                  Text(_contactWithGroups.contact.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge),
                                ],
                              ),
                            if (_contactWithGroups.contact.phone.isNotEmpty)
                              ContactInfoListTile(
                                prefixIcon: Icons.phone,
                                title: "PHONE",
                                content: _contactWithGroups.contact.phone,
                                onTap: () => (),
                              ),
                            if (_contactWithGroups.contact.email.isNotEmpty)
                              ContactInfoListTile(
                                prefixIcon: Icons.email,
                                title: "EMAIL",
                                content: _contactWithGroups.contact.email,
                                onTap: () => (),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (_contactWithGroups.groups.isNotEmpty)
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
                                      _contactWithGroups.groups.map((group) {
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
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              contentPadding: EdgeInsets.all(10),
                              hintText: 'Create a note...',
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            onChanged: (text) {
                              setState(() {
                                if (_contactWithGroups.contact.notes != text) {
                                  _hasNotesChanged = true;
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: FilledButton(
                                  onPressed: _hasNotesChanged
                                      ? () {
                                          setState(() {
                                            _contactWithGroups =
                                                _contactWithGroups.update(
                                                    contact: _contactWithGroups
                                                        .contact
                                                        .update(
                                                            notes:
                                                                _noteController
                                                                    .text));
                                            contactVM.saveNotes(
                                                _contactWithGroups.contact);
                                            _hasNotesChanged = false;
                                          });
                                        }
                                      : null,
                                  style: FilledButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text("Save"),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _hasNotesChanged
                                      ? () {
                                          _noteController.text =
                                              _contactWithGroups.contact.notes;
                                        }
                                      : null,
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    side: BorderSide(
                                        color: _hasNotesChanged
                                            ? Colors.red
                                            : Colors.grey),
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text("Cancel"),
                                ),
                              ),
                            ],
                          )
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
