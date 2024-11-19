import 'package:flutter/material.dart';
import 'package:friendlyreminder/models/ContactModel.dart';
import 'package:friendlyreminder/models/InterestModel.dart';
import 'package:friendlyreminder/models/ContactWithInterestsModel.dart';
import 'package:friendlyreminder/services/ContactService.dart';
import 'package:friendlyreminder/services/InterestService.dart';

class ContactsViewModel extends ChangeNotifier {
  final ContactService _contactService = ContactService();
  final InterestService _interestService = InterestService();

  List<ContactWithInterestsModel> _contacts = [];
  List<ContactWithInterestsModel> _filteredContacts = [];
  bool _isLoading = false;
  bool _isFiltered = false;
  String? _error;

  String _searchQuery = '';
  List<String> _selectedInterests = [];

  List<ContactWithInterestsModel> get contacts =>
      _isFiltered ? _filteredContacts : _contacts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get selectedInterests => _selectedInterests..sort();

  Future<void> loadContacts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final contacts = await _contactService.getAllContacts();
      final List<ContactWithInterestsModel> contactsWithInterests = [];
      for (var contact in contacts) {
        final interests =
            await _interestService.getInterestsForContact(contact.id!);
        contactsWithInterests.add(
            ContactWithInterestsModel(contact: contact, interests: interests));
      }
      _contacts = contactsWithInterests;
      _filteredContacts = []; // Reset filtered contacts
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<String> getAllUniqueInterests(List<ContactWithInterestsModel> contacts) {
    Set<String> uniqueInterests = {};

    for (var contact in contacts) {
      for (var interest in contact.interests) {
        uniqueInterests.addAll({interest.name});
      }
    }

    return uniqueInterests.toList()..sort();
  }

  Future<void> createContact(
      ContactModel contact, List<InterestModel> interests) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final contactId = await _contactService.createContact(contact);
      for (var interest in interests) {
        final interestId = await _interestService.getOrCreateInterest(interest);
        await _interestService.addInterestToContact(contactId, interestId);
      }
      await loadContacts(); // Refresh the contacts list after creating a new contact
    } catch (e) {
      _error = "Failed to create contact: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateContact(
      ContactModel contact, List<InterestModel> interests) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      // Update contact
      await _contactService.updateContact(contact);
      final currentInterests =
          await _interestService.getInterestsForContact(contact.id!);

      // Remove interests
      for (var currentInterest in currentInterests) {
        if (!interests.contains(currentInterest)) {
          await _interestService.removeInterestFromContact(contact.id!);
        }
      }

      // Add new interests
      for (var interest in interests) {
        if (!currentInterests.contains(interest)) {
          final interestId =
              await _interestService.getOrCreateInterest(interest);
          await _interestService.addInterestToContact(contact.id!, interestId);
        }
      }

      await loadContacts(); // Refresh the contacts list after updating
    } catch (e) {
      _error = "Failed to update contact: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteContact(int contactId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _interestService.removeInterestFromContact(contactId);
      await _contactService.deleteContact(contactId);
      await loadContacts(); // Refresh the contacts list after deleting
    } catch (e) {
      _error = "Failed to delete contact: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterContacts({String? query, List<String>? interests}) {
    _searchQuery = query ?? _searchQuery;
    _selectedInterests = interests ?? _selectedInterests;

    _isFiltered = _searchQuery.isNotEmpty || _selectedInterests.isNotEmpty;

    if (!_isFiltered) {
      _filteredContacts.clear();
    } else {
      _filteredContacts = _contacts.where((contactWithInterests) {
        bool matchesQuery = _searchQuery.isEmpty ||
            contactWithInterests.contact.name
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());

        bool matchesInterests = _selectedInterests.isEmpty ||
            _selectedInterests.every((interest) => contactWithInterests
                .interests
                .map((i) => i.name.toLowerCase())
                .contains(interest.toLowerCase()));

        return matchesQuery && matchesInterests;
      }).toList();
    }
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedInterests.clear();
    filterContacts();
  }

  void toggleInterestFilter(String interest) {
    if (_selectedInterests.contains(interest)) {
      _selectedInterests.remove(interest);
    } else {
      _selectedInterests.add(interest);
    }
    filterContacts();
  }

  void removeFilter(String interest) {
    _selectedInterests.remove(interest);
    filterContacts();
  }

  void onContactTap(ContactWithInterestsModel contactWithInterests) {
    print(
        "Clicked ${contactWithInterests.contact.name} with interests: ${contactWithInterests.interests..join(', ')}");
  }
}
