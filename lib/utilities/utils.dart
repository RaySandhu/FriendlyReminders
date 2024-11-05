class utils {
  static bool isAlpha(String str) {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(str);
  }
}
