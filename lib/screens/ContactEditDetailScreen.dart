import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:friendlyreminder/models/ContactWithGroupsModel.dart';
import 'package:friendlyreminder/models/ReminderModel.dart';
import 'package:friendlyreminder/viewmodels/ReminderViewModel.dart';
import 'package:friendlyreminder/widgets/ReminderDialog.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/viewmodels/ContactViewModel.dart';
import 'package:friendlyreminder/models/GroupModel.dart';
import 'package:friendlyreminder/models/ContactModel.dart';
import 'package:friendlyreminder/widgets/StyledTextField.dart';
import 'package:friendlyreminder/widgets/SuggestionTextField.dart';
import 'package:friendlyreminder/utilities/PhoneNumberFormatter.dart';

class ContactEditDetailScreen extends StatefulWidget {
  final ContactWithGroupsModel? contactWithGroups;
  const ContactEditDetailScreen({super.key, this.contactWithGroups});

  @override
  State<ContactEditDetailScreen> createState() =>
      _ContactEditDetailScreenState();
}

class _ContactEditDetailScreenState extends State<ContactEditDetailScreen> {
  late ContactWithGroupsModel? _contactWithGroups;

  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _phoneController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();
  late TextEditingController _noteController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _groupFocusNode = FocusNode();

  late List<GroupModel> _selectedGroups = [];
  final List<ReminderModel> _newReminders = [];

  @override
  void initState() {
    super.initState();
    _contactWithGroups = widget.contactWithGroups;
    if (_contactWithGroups != null) {
      _nameController =
          TextEditingController(text: _contactWithGroups!.contact.name);
      _phoneController =
          TextEditingController(text: _contactWithGroups!.contact.phone);
      _emailController =
          TextEditingController(text: _contactWithGroups!.contact.email);
      _noteController =
          TextEditingController(text: _contactWithGroups!.contact.notes);
      _selectedGroups = _contactWithGroups!.groups;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contactVM = Provider.of<ContactsViewModel>(context, listen: false);
    final reminderVM = Provider.of<ReminderViewModel>(context, listen: false);
    reminderVM.reminders.clear();

    // Ensure reminders are loaded after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_contactWithGroups != null &&
          _contactWithGroups!.contact.id != null) {
        reminderVM.loadRemindersByContact(_contactWithGroups!.contact.id!);
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            _contactWithGroups == null ? "Create New Contact" : "Edit Contact",
            style: Theme.of(context).textTheme.headlineSmall),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty) {
                  int contactId;
                  if (_contactWithGroups == null) {
                    ContactModel newContact = ContactModel(
                        name: _nameController.text,
                        phone: _phoneController.text,
                        email: _emailController.text,
                        notes: _noteController.text);

                    contactId = await Provider.of<ContactsViewModel>(context,
                            listen: false)
                        .createContact(newContact, _selectedGroups);
                  } else {
                    ContactModel newContact = _contactWithGroups!.contact
                        .update(
                            name: _nameController.text,
                            phone: _phoneController.text,
                            email: _emailController.text,
                            notes: _noteController.text);
                    _contactWithGroups = _contactWithGroups!
                        .update(contact: newContact, groups: _selectedGroups);
                    contactVM.updateContact(newContact, _selectedGroups);
                    contactId = newContact.id!;
                  }
                  if (_newReminders.isNotEmpty && contactId != -1) {
                    for (var reminder in _newReminders) {
                      // only create new reminders for newly added reminders
                      reminderVM.addReminder(reminder, contactId);
                    }
                  }
                  _nameController.clear();
                  _phoneController.clear();
                  _emailController.clear();
                  _noteController.clear();
                  _newReminders.clear();
                  reminderVM.reminders.clear();

                  if (_contactWithGroups == null) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context, _contactWithGroups);
                  }
                }
              },
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                minimumSize: const Size(0, 0),
              ),
              child: const Text("Done"),
            ),
          )
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    StyledTextField(
                      controller: _nameController,
                      hintText: "Name",
                      prefixIcon: Icons.person,
                      focusNode: _nameFocusNode,
                      nextFocusNode: _phoneFocusNode,
                      textCapitalization: TextCapitalization.words,
                    ),
                    StyledTextField(
                      controller: _phoneController,
                      hintText: "Phone",
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      focusNode: _phoneFocusNode,
                      nextFocusNode: _emailFocusNode,
                      inputFormatters: [PhoneNumberFormatter()],
                    ),
                    StyledTextField(
                      controller: _emailController,
                      hintText: "Email",
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      focusNode: _emailFocusNode,
                      nextFocusNode: _groupFocusNode,
                    ),
                    SuggestionTextField(
                      controller: _groupController,
                      hintText: "Groups",
                      prefixIcon: Icons.people,
                      focusNode: _groupFocusNode,
                      allSuggestions:
                          contactVM.groups.map((group) => group.name).toList(),
                      excludedSuggestions:
                          _selectedGroups.map((group) => group.name).toList(),
                      newText: "group",
                      onSelect: (text) {
                        setState(() {
                          _selectedGroups.add(GroupModel(name: text));
                        });
                      },
                    ),
                    if (_selectedGroups.isNotEmpty)
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            spacing: 8.0, // gap between adjacent chips
                            runSpacing: 4.0, // gap between lines
                            children: () {
                              _selectedGroups
                                  .sort((a, b) => a.name.compareTo(b.name));
                              return _selectedGroups.map((group) {
                                return Chip(
                                  label: Text(group.name),
                                  deleteIcon: Icon(Icons.close),
                                  onDeleted: () {
                                    setState(() {
                                      _selectedGroups.remove(group);
                                    });
                                  },
                                );
                              }).toList();
                            }(),
                          ),
                        ),
                      ),
                    StyledTextField(
                        controller: _noteController,
                        hintText: "Notes",
                        prefixIcon: Icons.description,
                        maxLines: null),
                    Consumer<ReminderViewModel>(
                      builder: (context, reminderVM, child) {
                        final combinedReminders = [
                          ...reminderVM.reminders,
                          ..._newReminders,
                        ];

                        void handleReminderSet(
                            DateTime? date, String? frequency) {
                          setState(() {
                            _newReminders.add(
                                ReminderModel(date: date!, freq: frequency!));
                          });
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => showReminderModal(
                                  context: context,
                                  onReminderSet: handleReminderSet),
                              child: Container(
                                padding: const EdgeInsets.only(left: 16.0),
                                margin: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey, // Grey underline
                                      width: 1.0, // Thickness of the underline
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.schedule,
                                            color: Colors.grey),
                                        SizedBox(width: 8),
                                        Text(
                                          "Reminders",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle,
                                          color: Colors.blue),
                                      onPressed: () => showReminderModal(
                                          context: context,
                                          onReminderSet: handleReminderSet),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (reminderVM.isLoading)
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              )
                            else if (reminderVM.error != null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "Failed to load reminders: ${reminderVM.error}",
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              )
                            else if (combinedReminders.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    spacing: 8.0, // Gap between chips
                                    runSpacing: 4.0, // Gap between rows
                                    children: combinedReminders.map((reminder) {
                                      return Chip(
                                        label: Text(
                                          "${reminder.freq == "Once" ? "Single" : reminder.freq} reminder ${reminder.freq == "Once" ? "on" : "starting"} ${reminder.date.toString().split(" ")[0]}",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        deleteIcon: const Icon(Icons.close),
                                        onDeleted: () async {
                                          if (reminder.id != null) {
                                            await reminderVM.deleteReminder(
                                              reminder.id!,
                                              _contactWithGroups!.contact.id!,
                                            );
                                          } else {
                                            _newReminders.remove(reminder);
                                          }
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                            else
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "No reminders added yet.",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            if (_contactWithGroups != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton.icon(
                  onPressed: () {
                    contactVM
                        .deleteContact(_contactWithGroups!.contact.id ?? -1);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  label: const Text("Delete Contact"),
                  icon: const Icon(Icons.delete),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Adjust this value to change the radius
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
