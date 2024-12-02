import 'package:flutter/foundation.dart';
import 'package:friendlyreminder/models/GroupModel.dart';
import 'package:friendlyreminder/services/GroupService.dart';
import 'package:flutter/material.dart';
import 'package:friendlyreminder/screens/GroupScreen.dart';

class GroupViewModel extends ChangeNotifier {
  final GroupService _groupService = GroupService();
  List<GroupModel> _groups = [];
  bool _isLoading = false;
  String? _error;

  List<GroupModel> get groups => _groups;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadGroups() async {
    _isLoading = true;
    notifyListeners();

    try {
      _groups = await _groupService.getAllGroups();
      print("HERE: $_groups");
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
      await _groupService.removeGroupFromContact(groupId);
      await _groupService.deleteGroup(groupId);
      await loadGroups();
    } catch (e) {
      _error = "Failed to delete group: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    MaterialPageRoute(
        builder: (context) => GroupScreen() //I can't figure out how to reroute it after the group gets deleted
      );
  }

    Future<int> createGroup(GroupModel group) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    int groupId = -1;
    try {
      groupId = await _groupService.getOrCreateGroup(group);
      await loadGroups();
    } catch (e) {
      _error = "Failed to create group: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return groupId;
  }
}
