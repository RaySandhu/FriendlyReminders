import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:friendlyreminder/models/ContactWithGroupsModel.dart';
import 'package:friendlyreminder/models/ReminderModel.dart';
import 'package:friendlyreminder/viewmodels/ReminderViewModel.dart';
import 'package:friendlyreminder/widgets/PopupDelete.dart';
import 'package:friendlyreminder/widgets/PopupMessage.dart';
import 'package:friendlyreminder/widgets/ReminderDialog.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/viewmodels/ContactViewModel.dart';
import 'package:friendlyreminder/models/GroupModel.dart';
import 'package:friendlyreminder/models/ContactModel.dart';
import 'package:friendlyreminder/widgets/StyledTextField.dart';
import 'package:friendlyreminder/utilities/PhoneNumberFormatter.dart';
import 'package:friendlyreminder/widgets/PopupDiscardChanges.dart';

class ContactEditDetailScreen extends StatefulWidget {
  final ContactWithGroupsModel? contactWithGroups;
  const ContactEditDetailScreen({super.key, this.contactWithGroups});

  @override
  State<ContactEditDetailScreen> createState() =>
      _ContactEditDetailScreenState();
}

class _ContactEditDetailScreenState extends State<ContactEditDetailScreen> {
  late ContactWithGroupsModel? _originalContactWithGroups;
  late ContactWithGroupsModel? _updatedContactWithGroups;

  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _phoneController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _groupController = TextEditingController();
  late TextEditingController _noteController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _groupFocusNode = FocusNode();

  late List<GroupModel> _selectedGroups = [];
  final List<ReminderModel> _newReminders = [];

  bool _hasChanges = false; // Track changes

  @override
  void initState() {
    super.initState();
    _originalContactWithGroups = widget.contactWithGroups;
    _updatedContactWithGroups = widget.contactWithGroups;
    if (_originalContactWithGroups != null) {
      _nameController =
          TextEditingController(text: _originalContactWithGroups!.contact.name);
      _phoneController = TextEditingController(
          text: _originalContactWithGroups!.contact.phone);
      _emailController = TextEditingController(
          text: _originalContactWithGroups!.contact.email);
      _noteController = TextEditingController(
          text: _originalContactWithGroups!.contact.notes);
      _selectedGroups = _originalContactWithGroups!.groups;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reminderVM = Provider.of<ReminderViewModel>(context, listen: false);
    reminderVM.reminders.clear();

    // Ensure reminders are loaded after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_originalContactWithGroups != null &&
          _originalContactWithGroups!.contact.id != null) {
        reminderVM
            .loadRemindersByContact(_originalContactWithGroups!.contact.id!);
      }
    });

    void updateContactWithGroups() {
      ContactModel newContact = ContactModel(
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        notes: _noteController.text,
      );

      _updatedContactWithGroups = ContactWithGroupsModel(
        contact: newContact,
        groups: _selectedGroups,
      );
    }

    return Consumer<ContactsViewModel>(builder: (context, contactVM, child) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize:
              const Size.fromHeight(kToolbarHeight), // Standard AppBar height
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Theme.of(context).colorScheme.inversePrimary,
                  Theme.of(context).colorScheme.primary,
                ],
                center: Alignment.center,
                radius: 5.0, // Adjust the radius for the spread
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // Title on the left
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            if (_originalContactWithGroups !=
                                _updatedContactWithGroups) {
                              popupDiscardChanges(context);
                            } else {
                              Navigator.pop(context);
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            _originalContactWithGroups == null
                                ? "Create New Contact"
                                : "Edit Contact",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Save button on the right
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilledButton(
                        onPressed: () async {
                          if (_nameController.text.isEmpty) {
                            popupMessage(
                              context: context,
                              title: "Missing name",
                              message: "Please enter a name for the contact.",
                            );
                          } else {
                            int contactId;
                            if (_originalContactWithGroups == null) {
                              ContactModel newContact = ContactModel(
                                name: _nameController.text,
                                phone: _phoneController.text,
                                email: _emailController.text,
                                notes: _noteController.text,
                              );

                              contactId = await contactVM.createContact(
                                  newContact, _selectedGroups);
                            } else {
                              ContactModel newContact =
                                  _originalContactWithGroups!.contact.update(
                                name: _nameController.text,
                                phone: _phoneController.text,
                                email: _emailController.text,
                                notes: _noteController.text,
                              );
                              _originalContactWithGroups =
                                  _originalContactWithGroups!.update(
                                      contact: newContact,
                                      groups: _selectedGroups);
                              contactVM.updateContact(
                                  newContact, _selectedGroups);
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

                            if (_originalContactWithGroups == null) {
                              Navigator.pop(context);
                            } else {
                              Navigator.pop(
                                  context, _originalContactWithGroups);
                            }
                          }
                        },
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          minimumSize: const Size(0, 0),
                        ),
                        child: const Text("Save"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                        onChanged: (_) => updateContactWithGroups(),
                      ),
                      StyledTextField(
                        controller: _phoneController,
                        hintText: "Phone",
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        focusNode: _phoneFocusNode,
                        nextFocusNode: _emailFocusNode,
                        inputFormatters: [PhoneNumberFormatter()],
                        onChanged: (_) => updateContactWithGroups(),
                      ),
                      StyledTextField(
                        controller: _emailController,
                        hintText: "Email",
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _emailFocusNode,
                        nextFocusNode: _groupFocusNode,
                        onChanged: (_) => updateContactWithGroups(),
                      ),
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          List<String> excludedGroups = _selectedGroups
                              .map((group) => group.name)
                              .toList();

                          var filteredGroups = contactVM
                              .getAllUniqueGroups(contactVM.contacts)
                              .where((String interest) {
                            return interest.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase()) &&
                                !excludedGroups.contains(
                                  interest,
                                );
                          }).followedBy([""]);
                          if (textEditingValue.text == '' &&
                              _selectedGroups.isNotEmpty) {
                            return const Iterable<String>.empty();
                          }
                          return filteredGroups;
                        },
                        onSelected: (String selection) {
                          setState(() {
                            _selectedGroups.add(GroupModel(name: selection));
                          });
                          updateContactWithGroups();
                          _groupController.clear();
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          _groupController = textEditingController;
                          return StyledTextField(
                            controller: textEditingController,
                            hintText: "Groups",
                            prefixIcon: Icons.group,
                            focusNode: focusNode,
                          );
                        },
                        optionsViewBuilder: (BuildContext context,
                            AutocompleteOnSelected<String> onSelected,
                            Iterable<String> options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              child: Column(children: [
                                ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: options.length - 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final option = options.elementAt(index);
                                    return ListTile(
                                      title: Text(option),
                                      onTap: () {
                                        onSelected(option);
                                      },
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.add,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  title: Text(
                                    _groupController.text.isEmpty
                                        ? "Create new group"
                                        : "Create \"${_groupController.text}\" group",
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    onSelected(_groupController.text);
                                  },
                                ),
                              ]),
                            ),
                          );
                        },
                      ),
                      if (_selectedGroups.isNotEmpty)
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              spacing: 8.0, // gap between adjacent chips
                              runSpacing: 4.0, // gap between lines
                              children: () {
                                _selectedGroups.sort();
                                return _selectedGroups.map((group) {
                                  return Chip(
                                    label: Text(group.name),
                                    deleteIcon: Icon(Icons.close),
                                    onDeleted: () {
                                      setState(() {
                                        _selectedGroups.remove(group);
                                      });
                                      updateContactWithGroups();
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
                                        width:
                                            1.0, // Thickness of the underline
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
                                            color: Colors.deepPurple),
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
                                  child: Center(
                                      child: CircularProgressIndicator()),
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
                                      children:
                                          combinedReminders.map((reminder) {
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
                                                _originalContactWithGroups!
                                                    .contact.id!,
                                              );
                                            } else {
                                              setState(() {
                                                _newReminders.remove(reminder);
                                              });
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
              if (_originalContactWithGroups != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton.icon(
                    onPressed: () {
                      popupDelete(
                          context: context,
                          title: "Delete contact",
                          message:
                              "Are you sure you want to delete this contact?",
                          onDeleted: () {
                            contactVM.deleteContact(
                                _originalContactWithGroups!.contact,
                                _originalContactWithGroups!.groups);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
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
    });
  }
}
