import 'package:flutter/material.dart';
import 'package:friendlyreminder/models/ReminderModel.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/viewmodels/ContactViewModel.dart';
import 'package:friendlyreminder/models/GroupModel.dart';
import 'package:friendlyreminder/models/ContactModel.dart';
import 'package:friendlyreminder/widgets/StyledTextField.dart';
import 'package:friendlyreminder/widgets/SuggestionTextField.dart';
import 'package:friendlyreminder/utilities/PhoneNumberFormatter.dart';
import '../widgets/ReminderDialog.dart';

class CreateContactScreen extends StatefulWidget {
  CreateContactScreen({super.key});

  @override
  State<CreateContactScreen> createState() => _CreateContactScreenState();
}

class _CreateContactScreenState extends State<CreateContactScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _reminderController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _tagFocusNode = FocusNode();

  final List<GroupModel> _selectedGroups = [];
  final List<ReminderModel> _reminders = [];

  void _handleReminderSet(DateTime? date, String? frequency) {
    _reminders.add(ReminderModel(date: date!, freq: frequency!));
    print("Reminder Set: Date=$date, Frequency=$frequency");
    print("Reminders list: $_reminders");
  }

  @override
  Widget build(BuildContext context) {
    final contactVM = Provider.of<ContactsViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Create New Contact",
            style: Theme.of(context).textTheme.headlineSmall),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  ContactModel newContact = ContactModel(
                      name: _nameController.text,
                      phone: _phoneController.text,
                      email: _emailController.text,
                      notes: _noteController.text);
                  contactVM.createContact(newContact, _selectedGroups);
                  _nameController.clear();
                  _phoneController.clear();
                  _emailController.clear();
                  _noteController.clear();
                  Navigator.pop(context);
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
                nextFocusNode: _tagFocusNode,
              ),
              SuggestionTextField(
                controller: _tagController,
                hintText: "Groups",
                prefixIcon: Icons.people,
                focusNode: _tagFocusNode,
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
                      children: _selectedGroups.map((group) {
                        return Chip(
                          label: Text(group.name),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              _selectedGroups.remove(group);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              GestureDetector(
                onTap: () => showReminderModal(
                  context: context,
                  reminderController: _reminderController,
                  onReminderSet: _handleReminderSet,
                ),
                child: AbsorbPointer(
                  child: StyledTextField(
                    controller: _reminderController,
                    hintText: "Reminders",
                    prefixIcon: Icons.schedule,
                  ),
                ),
              ),
              StyledTextField(
                  controller: _noteController,
                  hintText: "Notes",
                  prefixIcon: Icons.description,
                  maxLines: null),
            ],
          ),
        ),
      ),
    );
  }
}
