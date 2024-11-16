import 'package:sqflite/sqflite.dart';
import 'package:friendlyreminder/services/DatabaseClient.dart';
import 'package:friendlyreminder/models/TagModel.dart';
import 'package:friendlyreminder/models/InterestModel.dart';

class TagService {
  final DatabaseClient _dbClient = DatabaseClient();

  Future<void> createTag(TagModel tag) async {
    final db = await _dbClient.database;
    await db.insert(
      _dbClient.interestTagTblName,
      tag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteContact(int id) async {
    final db = await _dbClient.database;
    await db.delete(
      _dbClient.interestTagTblName,
      where: 'TagId = ?',
      whereArgs: [id],
    );
  }

  Future<List<InterestModel>> getTags() async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT I.${_dbClient.interestNameColName}
    FROM ${_dbClient.interestTagTblName} AS T
    JOIN ${_dbClient.interestTblName} AS I ON (I.${_dbClient.interestIdColName} = T.${_dbClient.interestIdColName})
    ''');
    return List.generate(maps.length, (i) {
      return InterestModel.fromMap(maps[i]);
    });
  }
}
