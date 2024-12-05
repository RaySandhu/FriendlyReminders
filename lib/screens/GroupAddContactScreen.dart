//add ppl to group --> brings up contacts page + multisect

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/models/GroupModel.dart';
import 'package:friendlyreminder/models/ContactGroupModel.dart';
import 'package:friendlyreminder/widgets/ContactCard.dart';
import 'package:friendlyreminder/screens/GroupEditDetailScreen.dart';
import 'package:friendlyreminder/viewmodels/GroupViewModel.dart';
import 'package:friendlyreminder/models/ContactModel.dart';
import 'package:friendlyreminder/viewmodels/ContactViewModel.dart';

class GroupAddContactScreen extends StatefulWidget {
  final GroupModel group;
  const GroupAddContactScreen({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  State<GroupAddContactScreen> createState() => _GroupAddContactScreenState();
}

class _GroupAddContactScreenState extends State<GroupAddContactScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ContactsViewModel, GroupViewModel>(
      builder: (context, contactVM, groupVM, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search',
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _isSearching = !_isSearching;
                              _searchController.clear();
                              contactVM.filterContacts(query: '');
                            });
                          }),
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onChanged: (value) {
                      Provider.of<ContactsViewModel>(context, listen: false)
                          .filterContacts(query: value);
                    },
                  )
                : Text("Add Contacts",
                    style: Theme.of(context).textTheme.headlineSmall),
            automaticallyImplyLeading: false,
            leading: _isSearching
                ? null
                : IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
            actions: _isSearching
                ? []
                : [
                    IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            _isSearching = !_isSearching;
                          });
                        }),
                  ],
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 8.0, // gap between adjacent chips
                      runSpacing: 4.0, // gap between lines
                      children: contactVM.selectedGroups.map((group) {
                        return Chip(
                          label: Text(group),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () => contactVM.removeFilter(group),
                        );
                      }).toList(),
                    ),
                  ),
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
                                    final contactWithGroups =
                                        contactVM.contacts[index];
                                    final isSelected = groupVM.contactInGroup
                                        .contains(contactWithGroups.contact);
                                    return ContactCard(
                                      name: contactWithGroups.contact.name,
                                      onTap: () => (),
                                      isSelected: isSelected,
                                      onCheck: (value) {
                                        if (isSelected) {
                                          groupVM.removeContactFromGroup(
                                              contactWithGroups.contact);
                                        } else {
                                          groupVM.addContactToGroup(
                                              contactWithGroups.contact);
                                        }
                                      },
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
