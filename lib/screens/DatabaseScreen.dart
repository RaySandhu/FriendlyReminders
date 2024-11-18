import 'package:flutter/material.dart';
import 'package:friendlyreminder/models/ContactModel.dart';
import 'package:friendlyreminder/services/ContactService.dart';

class DatabaseScreen extends StatefulWidget {
  const DatabaseScreen({super.key});

  @override
  State<DatabaseScreen> createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> {
  final ContactService contactService = ContactService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            Text("Database", style: Theme.of(context).textTheme.headlineSmall),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Text("Contacts CRUD", style: Theme.of(context).textTheme.bodyLarge),
            FilledButton(
              onPressed: () {
                ContactModel newContact = ContactModel(
                    name: "Alice",
                    phone: "(123)-456-7890",
                    email: "alice@gmail.com",
                    notes: "Hello");
                contactService.createContact(newContact);
              },
              child: Text("Create"),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.blue), // Background color
              ),
            ),
            FilledButton(
              onPressed: () async {
                print(await contactService.getAllContacts());
              },
              child: Text("Get"),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.red), // Background color
              ),
            ),
            FilledButton(
              onPressed: () {
                ContactModel newContact = ContactModel(
                    id: 1,
                    name: "Bob",
                    phone: "(123)-456-7890",
                    email: "alice@gmail.com",
                    notes: "Hello");
                contactService.updateContact(newContact);
              },
              child: Text("Update"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Colors.purple), // Background color
              ),
            ),
            FilledButton(
              onPressed: () {
                contactService.deleteContact(1);
              },
              child: Text("Delete"),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.green), // Background color
              ),
            ),
          ],
        ),
      )),
    );
  }
}
