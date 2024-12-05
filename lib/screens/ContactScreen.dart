import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:friendlyreminder/screens/ContactViewDetailScreen.dart';
import 'package:friendlyreminder/viewmodels/AIPromptViewModel.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/widgets/ContactCard.dart';
import 'package:friendlyreminder/viewmodels/ContactViewModel.dart';
import 'package:friendlyreminder/screens/ContactEditDetailScreen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  bool _isSearching = false;
  bool _isFilterOpen = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset > 0 && _isFilterOpen) {
      setState(() {
        _isFilterOpen = false;
      });
    }
  }

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
                              builder: (context) => ContactEditDetailScreen(),
                            ),
                          );
                        })
                  ],
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      FilledButton.icon(
                        onPressed: () {
                          setState(() {
                            _isFilterOpen = !_isFilterOpen;
                          });
                        },
                        icon: Icon(_isFilterOpen
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down),
                        label: Text("FILTER"),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          minimumSize: Size(0, 32),
                        ),
                      ),
                      const SizedBox(width: 5),
                      OutlinedButton(
                        onPressed: () {
                          contactVM.clearFilters();
                          setState(() {
                            _isSearching = false;
                            _searchController.clear();
                          });
                        },
                        child: Text("CLEAR"),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          minimumSize: Size(0, 32),
                        ),
                      ),
                    ]),
                  ),
                ),
                if (_isFilterOpen)
                  Container(
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 8.0, // gap between adjacent chips
                        runSpacing: 4.0, // gap between lines
                        children: contactVM
                            .getAllUniqueGroups(contactVM.contacts)
                            .map((group) {
                          return FilterChip(
                            label: Text(group),
                            side: BorderSide.none, // This removes the outline
                            showCheckmark: false,
                            selected: contactVM.selectedGroups.contains(group),
                            onSelected: (bool selected) {
                              contactVM.toggleGroupFilter(group);
                            },
                            selectedColor:
                                Colors.blue.shade100, // Custom selected color
                            // backgroundColor: Colors.grey.shade200,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
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
                                  controller: _scrollController,
                                  itemCount: contactVM.contacts.length,
                                  itemBuilder: (context, index) {
                                    final contactWithGroups =
                                        contactVM.contacts[index];
                                    final aiPromptsList =
                                        Provider.of<AIPromptViewModel>(context)
                                            .prompts;
                                    return ContactCard(
                                        name: contactWithGroups.contact.name,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ContactViewDetailScreen(
                                                contactWithGroups:
                                                    contactWithGroups,
                                                aiPrompts: aiPromptsList,
                                              ),
                                            ),
                                          );
                                        });
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
