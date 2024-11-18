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
  bool _isFilterOpen = false;
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    FilledButton.icon(
                      onPressed: () {
                        setState(() {
                          _isFilterOpen = !_isFilterOpen;
                        });
                      },
                      icon: Icon(Icons.arrow_drop_down),
                      label: Text("FILTER"),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        minimumSize: Size(0, 0),
                      ),
                    ),
                  ]),
                ),
                if (_isFilterOpen)
                  Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: contactVM
                        .getAllUniqueInterests(contactVM.contacts)
                        .map((interest) {
                      return FilterChip(
                        label: Text(interest),
                        // selected: contactVM.selectedInterests.contains(interest),
                        onSelected: (bool selected) {
                          // contactVM.toggleInterestSelection(interest);
                        },
                        selectedColor: Theme.of(context).colorScheme.secondary,
                        checkmarkColor:
                            Theme.of(context).colorScheme.onSecondary,
                      );
                    }).toList(),
                  ),
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
                                    final contactWithInterests =
                                        contactVM.contacts[index];
                                    return ContactCard(
                                      name: contactWithInterests.contact.name,
                                      onTap: () => contactVM
                                          .onContactTap(contactWithInterests),
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
