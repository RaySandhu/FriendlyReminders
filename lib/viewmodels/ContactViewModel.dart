import 'package:flutter/material.dart';
import 'package:friendlyreminder/models/ContactModel.dart';
import 'package:friendlyreminder/models/GroupModel.dart';
import 'package:friendlyreminder/models/ContactWithGroupsModel.dart';
import 'package:friendlyreminder/services/ContactService.dart';
import 'package:friendlyreminder/services/GroupService.dart';
import 'package:friendlyreminder/viewmodels/SharedState.dart';

class ContactsViewModel extends ChangeNotifier {
  final SharedState _sharedState;

  ContactsViewModel(this._sharedState) {
    _sharedState.addListener(reload);
  }

  void reload() {
    print("RELOAD");
    loadContacts();
  }

  @override
  void dispose() {
    _sharedState.removeListener(reload);
    super.dispose();
  }

  final ContactService _contactService = ContactService();
  final GroupService _groupService = GroupService();

  List<ContactWithGroupsModel> _contacts = [];
  List<ContactWithGroupsModel> _filteredContacts = [];
  List<GroupModel> _groups = [];

  bool _isLoading = false;
  bool _isFiltered = false;
  String? _error;

  String _searchQuery = '';
  List<String> _selectedGroups = [];

  List<ContactWithGroupsModel> get contacts =>
      _isFiltered ? _filteredContacts : _contacts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get selectedGroups => _selectedGroups..sort();
  List<GroupModel> get groups => _groups;

  ContactWithGroupsModel? getContactById(int contactId) {
    return (_contacts.where((contact) => contact.contact.id! == contactId))
        .firstOrNull;
  }

  Future<void> loadContacts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final contacts = await _contactService.getAllContacts();
      _groups = await _groupService.getAllGroups();
      final List<ContactWithGroupsModel> contactsWithGroups = [];
      for (var contact in contacts) {
        final groups = await _groupService.getGroupsFromContacts(contact.id!);
        contactsWithGroups
            .add(ContactWithGroupsModel(contact: contact, groups: groups));
      }
      _contacts = contactsWithGroups;
      _filteredContacts = []; // Reset filtered contacts
    } catch (e) {
      _error = "Failed to load contacts: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<String> getAllUniqueGroups(List<ContactWithGroupsModel> contacts) {
    Set<String> uniqueGroups = {};

    for (var contact in contacts) {
      for (var group in contact.groups) {
        uniqueGroups.addAll({group.name});
      }
    }

    return uniqueGroups.toList()..sort();
  }

  Future<void> saveNotes(ContactModel contact) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _contactService.updateContact(contact.update(notes: contact.notes));
      await loadContacts(); // Refresh the contacts list after creating a new contact
    } catch (e) {
      _error = "Failed to save notes: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int> createContact(
      ContactModel contact, List<GroupModel> groups) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    int contactId = -1;
    try {
      contactId = await _contactService.createContact(contact);
      for (var group in groups) {
        final groupId = await _groupService.getOrCreateGroup(group);
        await _groupService.addGroupToContact(contactId, groupId);
      }
      await loadContacts(); // Refresh the contacts list after creating a new contact
    } catch (e) {
      _error = "Failed to create contact: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return contactId;
  }

  Future<void> updateContact(
      ContactModel contact, List<GroupModel> groups) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      // Update contact
      await _contactService.updateContact(contact);
      final currentGroups =
          await _groupService.getGroupsFromContacts(contact.id!);

      // Remove groups
      for (var currentGroup in currentGroups) {
        if (!groups.contains(currentGroup)) {
          await _groupService.removeGroupFromContact(contactId: contact.id!);
        }
      }

      // Add new groups
      for (var group in groups) {
        if (!currentGroups.contains(group)) {
          final groupId = await _groupService.getOrCreateGroup(group);
          await _groupService.addGroupToContact(contact.id!, groupId);
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

  Future<void> updateContactDate(ContactWithGroupsModel contactInfo) async {
    final tmp = contactInfo.contact.update(latestContactDate: DateTime.now());
    updateContact(tmp, contactInfo.groups);
  }

  Future<void> deleteContact(int contactId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _groupService.removeGroupFromContact(contactId: contactId);
      await _contactService.deleteContact(contactId);
      await loadContacts(); // Refresh the contacts list after deleting
    } catch (e) {
      _error = "Failed to delete contact: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterContacts({String? query, List<String>? groups}) {
    _searchQuery = query ?? _searchQuery;
    _selectedGroups = groups ?? _selectedGroups;

    _isFiltered = _searchQuery.isNotEmpty || _selectedGroups.isNotEmpty;

    if (!_isFiltered) {
      _filteredContacts.clear();
    } else {
      _filteredContacts = _contacts.where((contactWithGroups) {
        bool matchesQuery = _searchQuery.isEmpty ||
            contactWithGroups.contact.name
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());

        bool matchesGroups = _selectedGroups.isEmpty ||
            _selectedGroups.every((group) => contactWithGroups.groups
                .map((i) => i.name.toLowerCase())
                .contains(group.toLowerCase()));

        return matchesQuery && matchesGroups;
      }).toList();
    }
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedGroups.clear();
    filterContacts();
  }

  void toggleGroupFilter(String group) {
    if (_selectedGroups.contains(group)) {
      _selectedGroups.remove(group);
    } else {
      _selectedGroups.add(group);
    }
    filterContacts();
  }

  void removeFilter(String group) {
    _selectedGroups.remove(group);
    filterContacts();
  }
}
