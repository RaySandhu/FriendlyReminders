import 'package:flutter/material.dart';
import 'package:friendlyreminder/models/ContactModel.dart';
import 'package:friendlyreminder/services/ContactService.dart';

class ContactsViewModel extends ChangeNotifier {
  final ContactService _contactService = ContactService();
  List<ContactModel> _contacts = [];
  List<ContactModel> _filteredContacts = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String? _error;

  List<ContactModel> get contacts =>
      _isSearching ? _filteredContacts : _contacts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadContacts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _contacts = await _contactService.getContacts();
      _filteredContacts = []; // Reset filtered contacts
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterContacts(String query) {
    if (query.isEmpty) {
      _isSearching = false;
      _filteredContacts.clear();
    } else {
      _isSearching = true;
      _filteredContacts = _contacts
          .where((contact) =>
              contact.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void onContactTap(ContactModel contact) {
    print("Clicked ${contact.name}");
  }
}
