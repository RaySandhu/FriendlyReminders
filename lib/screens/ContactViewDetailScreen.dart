import 'dart:math';

import 'package:flutter/material.dart';
import 'package:friendlyreminder/viewmodels/ReminderViewModel.dart';
import 'package:friendlyreminder/widgets/ContactInfoListTile.dart';
import 'package:friendlyreminder/models/AIPromptModel.dart';
import 'package:friendlyreminder/widgets/IconButtonWithTextRow.dart';
import 'package:friendlyreminder/screens/ContactEditDetailScreen.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/viewmodels/ContactViewModel.dart';
import 'package:friendlyreminder/models/ContactWithGroupsModel.dart';
import 'package:friendlyreminder/widgets/ContactInfoListTile.dart';
import 'package:friendlyreminder/widgets/ContactReminderCard.dart';
import 'package:friendlyreminder/widgets/AIPromptPopup.dart';
import 'package:friendlyreminder/viewmodels/AIPromptViewModel.dart';

class ContactViewDetailScreen extends StatefulWidget {
  final ContactWithGroupsModel contactWithGroups;
  final List<AIPromptModel> aiPrompts;

  const ContactViewDetailScreen({
      Key? key, 
      required this.contactWithGroups, 
      required this.aiPrompts
    })
      : super(key: key);

  @override
  State<ContactViewDetailScreen> createState() =>
      _ContactViewDetailScreenState();
}

class _ContactViewDetailScreenState extends State<ContactViewDetailScreen> {
  late ContactWithGroupsModel _contactWithGroups;
  late TextEditingController _noteController;
  late bool isEmpty;
  late int reminderCardState = 0;
  bool _hasNotesChanged = false;

  @override
  void initState() {
    super.initState();
    _contactWithGroups = widget.contactWithGroups;
    _noteController =
        TextEditingController(text: _contactWithGroups.contact.notes);
    isEmpty = _noteController.text.isEmpty;

    _noteController.addListener(() {
      setState(() {
        isEmpty = _noteController.text.isEmpty;
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

  Future<void> navigateToContactEditDetail() async {
    final updatedContactWithGroups = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactEditDetailScreen(
          contactWithGroups: _contactWithGroups,
        ),
      ),
    );

    if (updatedContactWithGroups != null) {
      setState(() {
        _contactWithGroups = updatedContactWithGroups;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactVM = Provider.of<ContactsViewModel>(context, listen: false);
    final aiPromptVM = Provider.of<AIPromptViewModel>(context, listen: false);
    final reminderVM = Provider.of<ReminderViewModel>(context, listen: false);

    // Ensure reminders are loaded after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_contactWithGroups.contact.id != null) {
        reminderVM.loadRemindersByContact(_contactWithGroups.contact.id!);
      }
    });

    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            navigateToContactEditDetail();
          },
        )
      ]),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  // Contact Card Section
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
                        Center(
                          child: Column(
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
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge),
                                    if(reminderCardState == 0)
                                      ContactReminderCard(
                                        onAccept: () {
                                          setState(() {
                                            reminderCardState = 1;
                                          });
                                          print('Reminder accepted!');
                                        },
                                        onDismiss: () {
                                          setState(() {
                                            reminderCardState = 2;
                                          });
                                          print('Reminder dismissed!');
                                        },
                                        onReject: () {
                                          setState(() {
                                            reminderCardState = 3;
                                          });
                                          print('Reminder rejected!');
                                        },
                                      ),

                                    if(reminderCardState == 2)
                                      Text('Reminder Snoozed',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    if(reminderCardState == 3)
                                      Text('Reminder Dismissed',
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8.0, // gap between adjacent chips
                                  runSpacing: 4.0, // gap between lines
                                  children:
                                      _contactWithGroups.groups.map((group) {
                                    return ActionChip(
                                      label: Text(group.name),
                                      onPressed: () {
                                        // TODO: Click leads to clicked group screen
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
                  // Reminders Section
                  const SizedBox(height: 10),
                  Card(
                    child: Consumer<ReminderViewModel>(
                      builder: (context, reminderVM, child) {
                        if (reminderVM.isLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (reminderVM.error != null) {
                          return Center(
                            child: Text(
                              "Failed to load reminders: ${reminderVM.error}",
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        final reminders = reminderVM.reminders;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(left: 16.0),
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  const Icon(Icons.schedule,
                                      color: Colors.grey),
                                  const SizedBox(
                                    width: 8,
                                    height: 40,
                                  ),
                                  Text(
                                    "REMINDERS",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  if (reminders.isEmpty)
                                    const Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        "No reminders",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (reminders.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0), // Add spacing
                                child: Wrap(
                                  spacing: 8.0, // Gap between chips
                                  runSpacing: 4.0, // Gap between rows
                                  children: reminders.map((reminder) {
                                    return Chip(
                                      label: Text(
                                        "${reminder.freq == "Once" ? "Single" : reminder.freq} reminder on ${reminder.date.toString().split(" ")[0]}",
                                        overflow: TextOverflow
                                            .ellipsis, // Handle long labels
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "NOTES",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const Spacer(),
                              IconButtonWithTextRow(
                                icon: const Icon(Icons.factory), 
                                text: 'Generate Icebreaker', 
                                onPressed: () {
                                  print("Generated Icebreaker");
                                  var rng = Random();
                                  showDialog(
                                    context: context, 
                                    builder: (context) => AIPromptPopup(prompt: aiPromptVM.prompts[rng.nextInt(aiPromptVM.prompts.length)].promptText),
                                    );
                                }, 
                                buttonColour: Colors.blue)
                            ]
                          ),
                          const SizedBox(height: 8),
                          Stack(
                            children: [
                              TextField(
                                controller: _noteController,
                                maxLines: null, // Allows for multi-line input
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  suffixIcon: const IconButton(
                                    icon: Icon(Icons.close,
                                        color: Colors.transparent),
                                    onPressed: null,
                                  ),
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
                                    if (_contactWithGroups.contact.notes !=
                                        text) {
                                      _hasNotesChanged = true;
                                    }
                                  });
                                },
                              ),
                              Row(
                                children: [
                                  const Spacer(),
                                  IconButton(
                                    icon: Icon(Icons.close,
                                        color: !isEmpty
                                            ? Colors.grey
                                            : Colors.transparent),
                                    onPressed: !isEmpty
                                        ? () => _noteController.clear()
                                        : null,
                                  ),
                                ],
                              ),
                            ],
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
