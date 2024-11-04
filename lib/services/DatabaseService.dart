import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:friendlyreminder/models/post.dart';

Future<List<Post>> loadPosts() async {
  final String jsonString =
      await rootBundle.loadString('lib/assets/mock_db.json');
  final List<dynamic> jsonData = json.decode(jsonString);
  return jsonData.map((data) => Post.fromJson(data)).toList();
}
