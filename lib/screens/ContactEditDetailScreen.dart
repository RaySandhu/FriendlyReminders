import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:friendlyreminder/models/ContactWithGroupsModel.dart';
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
  final TextEditingController _reminderController = TextEditingController();
  late TextEditingController _noteController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _groupFocusNode = FocusNode();

  late List<GroupModel> _selectedGroups = [];

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
              child: const Text("Done"),
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  if (_contactWithGroups == null) {
                    ContactModel newContact = ContactModel(
                        name: _nameController.text,
                        phone: _phoneController.text,
                        email: _emailController.text,
                        notes: _noteController.text);

                    contactVM.createContact(newContact, _selectedGroups);
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
                  }
                  _nameController.clear();
                  _phoneController.clear();
                  _emailController.clear();
                  _noteController.clear();
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
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                minimumSize: Size(0, 0),
              ),
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
                        controller: _reminderController,
                        hintText: "Reminders",
                        prefixIcon: Icons.schedule),
                    StyledTextField(
                        controller: _noteController,
                        hintText: "Notes",
                        prefixIcon: Icons.description,
                        maxLines: null),
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
