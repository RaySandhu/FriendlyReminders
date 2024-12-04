//add ppl to group --> brings up contacts page + multisect

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/models/GroupModel.dart';
import 'package:friendlyreminder/models/ContactGroupModel.dart';
import 'package:friendlyreminder/widgets/ContactCard.dart';
import 'package:friendlyreminder/screens/GroupViewDetailScreen.dart';
import 'package:friendlyreminder/viewmodels/GroupViewModel.dart';
import 'package:friendlyreminder/models/ContactModel.dart';
import 'package:friendlyreminder/viewmodels/ContactViewModel.dart';

class GroupAddContactScreen extends StatefulWidget {
  final ContactModel groupContact;

  const GroupAddContactScreen({
    Key? key,
    required this.groupContact,
  }) : super(key: key);

  @override
  State<GroupAddContactScreen> createState() => _GroupAddContactScreenState();
}

class _GroupAddContactScreenState extends State<GroupAddContactScreen> {
  final List<ContactModel> _selectedContacts = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectedContacts.add(widget.groupContact);
  }

  Future<void> _saveContacts() async {
    //this will add the contacts to the group
  }

  @override
  Widget build(BuildContext context) {
    final contactVM = Provider.of<ContactsViewModel>(context, listen: false);
    final filteredContacts = _searchQuery.isEmpty
        ? contactVM.contacts
        : contactVM.contacts
            .where((contact) => contact.contact.name
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search Contacts',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  ),
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : Text("Add Contacts"),
        actions: _isSearching
            ? []
            : [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
                TextButton(
                  onPressed: () {
                    // Return the contacts -- add implementation
                  },
                  child: const Text(
                    "Done",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilledButton(
                      onPressed: _saveContacts,
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        minimumSize: const Size(0, 0),
                      ),
                      child: const Text("Done"),
                    ))
              ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: contactVM.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : contactVM.error != null
                      ? Center(child: Text('Error: ${contactVM.error}'))
                      : filteredContacts.isEmpty
                          ? const Center(child: Text('No contacts found'))
                          : ListView.builder(
                              itemCount: filteredContacts.length,
                              itemBuilder: (context, index) {
                                final contact = filteredContacts[index];
                                final isSelected =
                                    _selectedContacts.contains(contact.contact);

                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text(
                                        contact.contact.name[0].toUpperCase()),
                                  ),
                                  title: Text(contact.contact.name),
                                  trailing: Checkbox(
                                    value: isSelected,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          _selectedContacts
                                              .add(contact.contact);
                                        } else {
                                          _selectedContacts
                                              .remove(contact.contact);
                                        }
                                      });
                                      print(_selectedContacts);
                                    },
                                  ),
                                  onTap: () {
                                    // Toggle selection on tap
                                    setState(() {
                                      if (isSelected) {
                                        _selectedContacts
                                            .remove(contact.contact);
                                      } else {
                                        _selectedContacts.add(contact.contact);
                                      }
                                    });
                                  },
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
