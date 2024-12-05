import 'package:flutter/foundation.dart';
import 'package:friendlyreminder/models/GroupModel.dart';
import 'package:friendlyreminder/models/ContactModel.dart';
import 'package:friendlyreminder/services/GroupService.dart';
import 'package:flutter/material.dart';
import 'package:friendlyreminder/viewmodels/SharedState.dart';

class GroupViewModel extends ChangeNotifier {
  final SharedState _sharedState;

  GroupViewModel(this._sharedState) {
    _sharedState.addListener(reload);
  }

  void reloadContacts() {
    _sharedState.updateContacts();
  }

  void reload() {
    loadGroups();
  }

  @override
  void dispose() {
    _sharedState.removeListener(reload);
    super.dispose();
  }

  final GroupService _groupService = GroupService();
  List<GroupModel> _groups = [];
  List<ContactModel> _contactInGroup = [];
  bool _isLoading = false;
  String? _error;

  List<GroupModel> get groups => _groups;
  List<ContactModel> get contactInGroup => _contactInGroup..sort();
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadGroups() async {
    _isLoading = true;
    notifyListeners();

    try {
      _groups = await _groupService.getAllGroups();
    } catch (e) {
      _error = "Failed to load groups: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteGroup(int groupId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _groupService.removeGroupFromContact(groupId: groupId);
      await _groupService.deleteGroup(groupId);
      await loadGroups();
      reloadContacts();
    } catch (e) {
      _error = "Failed to delete group: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int> createGroup(GroupModel group, List<ContactModel> contacts) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    int groupId = -1;
    try {
      groupId = await _groupService.getOrCreateGroup(group);

      for (var contact in contacts) {
        await _groupService.addGroupToContact(contact.id!, group.id!);
      }

      await loadGroups();
    } catch (e) {
      _error = "Failed to create group: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return groupId;
  }

  Future<void> getContactsFromGroup(GroupModel? group) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      if (group != null) {
        _contactInGroup = await _groupService.getContactsFromGroup(group.id!);
      } else {
        _contactInGroup = [];
      }
    } catch (e) {
      _error = "Failed to get group: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addContactToGroup(ContactModel contact) {
    _contactInGroup.add(contact);
    notifyListeners();
  }

  void removeContactFromGroup(ContactModel contact) {
    _contactInGroup.remove(contact);
    notifyListeners();
  }

  Future<void> updateGroup(
      GroupModel group, List<ContactModel> contacts) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      // Update group
      await _groupService.updateGroup(group);

      final currentContacts =
          await _groupService.getContactsFromGroup(group.id!);

      // Remove contacts
      for (var currentContact in currentContacts) {
        if (!contacts.contains(currentContact)) {
          await _groupService.removeGroupFromContact(
              contactId: currentContact.id!);
        }
      }

      // Add new contacts
      for (var contact in contacts) {
        if (!currentContacts.contains(contact)) {
          await _groupService.addGroupToContact(contact.id!, group.id!);
        }
      }

      await loadGroups();
      reloadContacts();
    } catch (e) {
      _error = "Failed to update group: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
