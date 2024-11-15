import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/widgets/ContactCard.dart';
import 'package:friendlyreminder/viewmodels/ContactViewModel.dart';
import 'package:friendlyreminder/screens/CreateContactScreen.dart';

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
    return Consumer<ContactsViewModel>(
      builder: (context, contactVM, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
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
                : Text("Contacts",
                    style: Theme.of(context).textTheme.headlineSmall),
            actions: _isSearching
                ? []
                : [
                    IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            _isSearching = !_isSearching;
                          });
                        }),
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateContactScreen()));
                        })
                  ],
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: contactVM.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : contactVM.error != null
                          ? Center(child: Text('Error: ${contactVM.error}'))
                          : contactVM.contacts.isEmpty
                              ? const Center(child: Text('No contacts found'))
                              : ListView.builder(
                                  itemCount: contactVM.contacts.length,
                                  itemBuilder: (context, index) {
                                    final contact = contactVM.contacts[index];
                                    return ContactCard(
                                      name: contact.name,
                                      onTap: () =>
                                          contactVM.onContactTap(contact),
                                    );
                                  },
                                ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
