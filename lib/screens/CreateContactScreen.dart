import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/viewmodels/ContactViewModel.dart';
import 'package:friendlyreminder/models/ContactModel.dart';

class CreateContactScreen extends StatefulWidget {
  const CreateContactScreen({super.key});

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
                  contactVM.createContact(newContact);
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
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _nameController,
                      onChanged: (text) => setState(() {
                        _nameController.text.isEmpty;
                      }),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.people),
                        suffixIcon: _nameController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _nameController.clear();
                                  });
                                },
                              ),
                        hintText: "Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _phoneController,
                      onChanged: (text) => setState(() {
                        _phoneController.text.isEmpty;
                      }),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        suffixIcon: _phoneController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _phoneController.clear();
                                  });
                                },
                              ),
                        hintText: "Phone",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _emailController,
                      onChanged: (text) => setState(() {
                        _emailController.text.isEmpty;
                      }),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        suffixIcon: _emailController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _emailController.clear();
                                  });
                                },
                              ),
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _tagController,
                      onChanged: (text) => setState(() {
                        _tagController.text.isEmpty;
                      }),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.label),
                        suffixIcon: _tagController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _tagController.clear();
                                  });
                                },
                              ),
                        hintText: "Tags",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _reminderController,
                      onChanged: (text) => setState(() {
                        _reminderController.text.isEmpty;
                      }),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.schedule),
                        suffixIcon: _reminderController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _reminderController.clear();
                                  });
                                },
                              ),
                        hintText: "Reminders",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _noteController,
                      onChanged: (text) => setState(() {
                        _noteController.text.isEmpty;
                      }),
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.description),
                        suffixIcon: _noteController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _noteController.clear();
                                  });
                                },
                              ),
                        hintText: "Notes",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
