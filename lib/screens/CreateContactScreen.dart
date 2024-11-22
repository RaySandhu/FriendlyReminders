import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/viewmodels/ContactViewModel.dart';
import 'package:friendlyreminder/models/InterestModel.dart';
import 'package:friendlyreminder/models/ContactModel.dart';
import 'package:friendlyreminder/widgets/StyledTextField.dart';
import 'package:friendlyreminder/widgets/SuggestionTextField.dart';
import 'package:friendlyreminder/utilities/PhoneNumberFormatter.dart';

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

  final List<InterestModel> _selectedInterests = [];

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
              child: Text("Done"),
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  ContactModel newContact = ContactModel(
                      name: _nameController.text,
                      phone: _phoneController.text,
                      email: _emailController.text,
                      notes: _noteController.text);
                  contactVM.createContact(newContact, _selectedInterests);
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
            StyledTextField(
              controller: _nameController,
              hintText: "Name",
              prefixIcon: Icons.people,
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
            ),
            SuggestionTextField(
              controller: _tagController,
              hintText: "Tags",
              prefixIcon: Icons.label,
              allSuggestions:
                  contactVM.getAllUniqueInterests(contactVM.contacts),
              excludedSuggestions:
                  _selectedInterests.map((interest) => interest.name).toList(),
              onSelect: (text) {
                setState(() {
                  _selectedInterests.add(InterestModel(name: text));
                });
              },
            ),
            if (_selectedInterests.isNotEmpty)
              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: _selectedInterests.map((interest) {
                      return Chip(
                        label: Text(interest.name),
                        deleteIcon: Icon(Icons.close),
                        onDeleted: () {
                          setState(() {
                            _selectedInterests.remove(interest);
                          });
                        },
                      );
                    }).toList(),
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
    );
  }
}
