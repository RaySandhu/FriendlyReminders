import 'package:flutter/material.dart';
import 'package:friendlyreminder/screens/ContactEditDetailScreen.dart';
import 'package:friendlyreminder/viewmodels/ContactViewModel.dart';

class ContactsAppBar extends StatefulWidget {
  final ContactsViewModel contactVM;

  const ContactsAppBar({Key? key, required this.contactVM}) : super(key: key);

  @override
  _ContactsAppBarState createState() => _ContactsAppBarState();
}

class _ContactsAppBarState extends State<ContactsAppBar> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _isSearching
            ? Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    hintText: 'Search...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    widget.contactVM.filterContacts(query: value);
                  },
                ),
              )
            : const Text(
                "Contacts",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                _isSearching ? Icons.close : Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  if (_isSearching) {
                    _searchController.clear();
                    widget.contactVM.filterContacts(query: '');
                  }
                  _isSearching = !_isSearching;
                });
              },
            ),
            if (!_isSearching)
              IconButton(
                icon: const Icon(
                  Icons.filter_list_alt,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    if (_isSearching) {
                      _searchController.clear();
                      widget.contactVM.filterContacts(query: '');
                    }
                    _isSearching = !_isSearching;
                  });
                },
              ),
            if (!_isSearching)
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactEditDetailScreen(),
                    ),
                  );
                },
              ),
          ],
        ),
      ],
    );
  }
}
