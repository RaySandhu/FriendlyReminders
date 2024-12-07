import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/models/GroupModel.dart';
import 'package:friendlyreminder/widgets/ContactCard.dart';
import 'package:friendlyreminder/viewmodels/GroupViewModel.dart';
import 'package:friendlyreminder/viewmodels/ContactViewModel.dart';

class GroupAddContactScreen extends StatefulWidget {
  final GroupModel? group;
  const GroupAddContactScreen({
    Key? key,
    this.group,
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
          appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(kToolbarHeight), // Standard AppBar height
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Theme.of(context).colorScheme.inversePrimary,
                    Theme.of(context).colorScheme.primary,
                  ],
                  center: Alignment.center,
                  radius: 5.0, // Adjust the radius for the spread
                ),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    // Title or Search bar on the left
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: _isSearching
                            ? SizedBox(
                                height: 40.0,
                                child: TextField(
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
                                      },
                                    ),
                                    contentPadding: const EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    Provider.of<ContactsViewModel>(context,
                                            listen: false)
                                        .filterContacts(query: value);
                                  },
                                ),
                              )
                            : Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back,
                                        color: Colors.white),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Text(
                                    "Add Contacts",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    // Search icon on the right
                    if (!_isSearching)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: IconButton(
                            icon: const Icon(Icons.search, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _isSearching = !_isSearching;
                              });
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
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
                                    final contactWithGroups =
                                        contactVM.contacts[index];
                                    final isSelected = groupVM.contactInGroup
                                        .contains(contactWithGroups.contact);
                                    return ContactCard(
                                      name: contactWithGroups.contact.name,
                                      onTap: () {
                                        if (isSelected) {
                                          groupVM.removeContactFromGroup(
                                              contactWithGroups.contact);
                                        } else {
                                          groupVM.addContactToGroup(
                                              contactWithGroups.contact);
                                        }
                                      },
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Adjust this value to change the radius
                        ),
                      ),
                    ),
                    child: const Text("Done"),
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
