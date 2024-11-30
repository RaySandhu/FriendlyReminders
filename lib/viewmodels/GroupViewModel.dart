import 'package:flutter/foundation.dart';
import 'package:friendlyreminder/models/GroupModel.dart';
import 'package:friendlyreminder/services/GroupService.dart';

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
}
