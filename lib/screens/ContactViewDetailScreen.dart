import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:friendlyreminder/screens/GroupViewDetailScreen.dart';
import 'package:friendlyreminder/viewmodels/ReminderViewModel.dart';
import 'package:friendlyreminder/widgets/ContactInfoListTile.dart';
import 'package:friendlyreminder/models/AIPromptModel.dart';
import 'package:friendlyreminder/widgets/IconButtonWithTextRow.dart';
import 'package:friendlyreminder/screens/ContactEditDetailScreen.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/viewmodels/ContactViewModel.dart';
import 'package:friendlyreminder/models/ContactWithGroupsModel.dart';
import 'package:friendlyreminder/widgets/ContactReminderCard.dart';
import 'package:friendlyreminder/widgets/AIPromptPopup.dart';
import 'package:friendlyreminder/viewmodels/AIPromptViewModel.dart';
import 'package:friendlyreminder/models/ReminderModel.dart';

class ContactViewDetailScreen extends StatefulWidget {
  final ContactWithGroupsModel contactWithGroups;
  final List<AIPromptModel> aiPrompts;

  const ContactViewDetailScreen(
      {Key? key, required this.contactWithGroups, required this.aiPrompts})
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
          icon: const Icon(
            Icons.edit,
          ),
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
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: 3,
                                sigmaY: 3,
                              ),
                              child: Image.asset(
                                "assets/images/grass.jpg",
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
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
                                    if (_contactWithGroups
                                            .contact.latestContactDate !=
                                        null)
                                      Text(
                                        "Last reached out on ${_contactWithGroups.contact.latestContactDate.toString().split(' ')[0]}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Colors
                                                  .grey, // Set the text color to grey
                                            ),
                                      )
                                    else
                                      Text(
                                        "You haven't reached out to this person yet!",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Colors
                                                  .grey, // Set the text color to grey
                                            ),
                                      ),
                                    if (reminderCardState == 0)
                                      Card(child: Consumer<ReminderViewModel>(
                                        builder: (context, reminderVM, child) {
                                          if (reminderVM.isLoading) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }

                                          if (reminderVM.error != null) {
                                            return Center(
                                              child: Text(
                                                "Failed to load reminders: ${reminderVM.error}",
                                                style: const TextStyle(
                                                    color: Colors.red),
                                              ),
                                            );
                                          }

                                          final reminders =
                                              reminderVM.reminders;

                                          return (reminders.isNotEmpty
                                              ? ContactReminderCard(
                                                  onAccept: () {
                                                    contactVM.updateContactDate(
                                                        _contactWithGroups);

                                                    for (var reminder
                                                        in reminders) {
                                                      reminderVM
                                                          .incrementReminder(
                                                              reminder,
                                                              reminder.id!,
                                                              _contactWithGroups
                                                                  .contact.id!);
                                                    }

                                                    setState(() {
                                                      reminderCardState = 1;
                                                    });
                                                  },
                                                  onDismiss: () {
                                                    for (var reminder
                                                        in reminders) {
                                                      reminderVM
                                                          .incrementReminder(
                                                              reminder,
                                                              reminder.id!,
                                                              _contactWithGroups
                                                                  .contact.id!);
                                                    }

                                                    reminderVM.addReminder(
                                                      ReminderModel(
                                                        date:
                                                            DateTime.now().add(
                                                          const Duration(
                                                              days: 1),
                                                        ),
                                                        freq: "Once",
                                                      ),
                                                      _contactWithGroups
                                                          .contact.id!,
                                                    );

                                                    setState(() {
                                                      reminderCardState = 2;
                                                    });
                                                  },
                                                  onReject: () {
                                                    for (var reminder
                                                        in reminders) {
                                                      reminderVM
                                                          .incrementReminder(
                                                              reminder,
                                                              reminder.id!,
                                                              _contactWithGroups
                                                                  .contact.id!);
                                                    }

                                                    setState(() {
                                                      reminderCardState = 3;
                                                    });
                                                  },
                                                )
                                              : Container());
                                        },
                                      )),
                                    if (reminderCardState == 2)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0), // Add bottom padding for spacing
                                        child: Text(
                                          'Reminder Snoozed',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 3.0, // Blur the shadow
                                                    color: Colors.amber.withOpacity(0.4), // Subtle shadow color
                                                  ),
                                                ],
                                                                                    ),
                                              
                                        ),
                                      ),
                                    if (reminderCardState == 3)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0), // Add bottom padding for spacing
                                        child: Text(
                                          'Reminder Rejected',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 3.0, // Blur the shadow
                                                    color: Colors.red.withOpacity(0.4), // Subtle shadow color
                                                  ),
                                                ],
                                              ),
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
                            padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 8.0),
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                GroupViewDetailScreen(
                                                    group: group),
                                          ),
                                        );
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

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
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
                                      //horizontal: 8.0,
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
                          ),
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
                          Row(children: [
                            Text(
                              "NOTES",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const Spacer(),
                            IconButtonWithTextRow(
                                icon: const Icon(Icons.smart_toy, color: Colors.white,),
                                text: 'Generate Icebreaker',
                                onPressed: () {
                                  print("Generated Icebreaker");
                                  var rng = Random();
                                  showDialog(
                                    context: context,
                                    builder: (context) => AIPromptPopup(
                                        prompt: aiPromptVM
                                            .prompts[rng.nextInt(
                                                aiPromptVM.prompts.length)]
                                            .promptText),
                                  );
                                },
                                buttonColour: const Color.fromARGB(255, 255, 193, 7))
                          ]),
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
