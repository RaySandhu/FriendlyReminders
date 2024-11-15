import 'package:flutter/material.dart';

class CreateContactScreen extends StatefulWidget {
  const CreateContactScreen({super.key});

  @override
  State<CreateContactScreen> createState() => _CreateContactScreenState();
}

class _CreateContactScreenState extends State<CreateContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Create New Contact",
            style: Theme.of(context).textTheme.headlineSmall),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Text("Create Contact"),
      ),
    );
  }
}
