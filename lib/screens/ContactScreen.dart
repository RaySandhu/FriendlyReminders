import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/widgets/ContactCard.dart';
import 'package:friendlyreminder/viewmodels/ContactViewModel.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContactsViewModel()..loadContacts(),
      child: Consumer<ContactsViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: _isSearching
                  ? TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        suffixIcon: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _isSearching = !_isSearching;
                                _searchController.clear();
                                Provider.of<ContactsViewModel>(context,
                                        listen: false)
                                    .filterContacts(''); // Reset filter
                              });
                            }),
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onChanged: (value) {
                        Provider.of<ContactsViewModel>(context, listen: false)
                            .filterContacts(value);
                      },
                    )
                  : Row(
                      children: [
                        Text("Contacts",
                            style: Theme.of(context).textTheme.headlineMedium),
                        Spacer(),
                        IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              setState(() {
                                _isSearching = !_isSearching;
                              });
                            }),
                        IconButton(icon: Icon(Icons.add), onPressed: () => ())
                      ],
                    ),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              // actions: [
              //   IconButton(
              //     icon: Icon(_isSearching ? Icons.close : Icons.search),
              //     onPressed: () {

              //     },
              //   ),
              //   IconButton(icon: Icon(Icons.add), onPressed: () => ())
              // ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: viewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : viewModel.error != null
                            ? Center(child: Text('Error: ${viewModel.error}'))
                            : viewModel.contacts.isEmpty
                                ? const Center(child: Text('No contacts found'))
                                : ListView.builder(
                                    itemCount: viewModel.contacts.length,
                                    itemBuilder: (context, index) {
                                      final contact = viewModel.contacts[index];
                                      return ContactCard(
                                        name: contact.name,
                                        onTap: () =>
                                            viewModel.onContactTap(contact),
                                      );
                                    },
                                  ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
