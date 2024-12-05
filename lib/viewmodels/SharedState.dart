import 'package:flutter/foundation.dart';

class SharedState extends ChangeNotifier {
  void updateContacts() {
    notifyListeners();
  }

  void updateGroups() {
    notifyListeners();
  }
}
