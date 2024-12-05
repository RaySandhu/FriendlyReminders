import 'package:flutter/foundation.dart';

class SharedState extends ChangeNotifier {
  void triggerReload() {
    notifyListeners();
  }
}
