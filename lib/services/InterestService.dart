import 'package:friendlyreminder/services/DatabaseClient.dart';
import 'package:friendlyreminder/models/GroupModel.dart';

class InterestService {
  final DatabaseClient _dbClient = DatabaseClient();

  Future<List<GroupModel>> getAllInterests() async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps = await db.query(
        _dbClient.groupTblName,
        orderBy: '${_dbClient.groupNameColName} ASC');
    return List.generate(maps.length, (i) {
      return GroupModel.fromMap(maps[i]);
    });
  }

  Future<int> getOrCreateInterest(GroupModel interest) async {
    final db = await _dbClient.database;

    var result = await db.query(
      _dbClient.groupTblName,
      where: '${_dbClient.groupNameColName} = ?',
      whereArgs: [interest.name],
    );

    // Check if interest already exists
    int interestId;
    if (result.isNotEmpty) {
      // Interest already exists
      interestId = result.first[_dbClient.groupIdColName] as int;
    } else {
      // Interest does not exist
      interestId = await db.insert(_dbClient.groupTblName, interest.toMap());
    }
    return interestId;
  }

  Future<List<GroupModel>> getInterestsForContact(int contactId) async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT I.*
    FROM ${_dbClient.groupTblName} I
    JOIN ${_dbClient.contactGroupTblName} CI ON (CI.${_dbClient.groupIdColName} = I.${_dbClient.groupIdColName})
    WHERE CI.${_dbClient.contactIdColName} = $contactId
    ''');
    return List.generate(maps.length, (i) {
      return GroupModel.fromMap(maps[i]);
    });
  }

  // Future<List<String>> getInterestsForContact(int contactId) async {
  //   final db = await _dbClient.database;
  //   final List<Map<String, dynamic>> result = await db.rawQuery('''
  //   SELECT I.${_dbClient.interestNameColName}
  //   FROM ${_dbClient.interestTblName} I
  //   JOIN ${_dbClient.contactInterestTblName} CI ON (CI.${_dbClient.interestIdColName} = I.${_dbClient.interestIdColName})
  //   WHERE CI.${_dbClient.contactIdColName} = $contactId
  //   ''');
  //   return result.map((map) {
  //     return map[_dbClient.interestNameColName] as String;
  //   }).toList();
  // }

  Future<void> addInterestToContact(int contactId, int interestId) async {
    final db = await _dbClient.database;
    await db.insert(_dbClient.contactGroupTblName, {
      _dbClient.contactIdColName: contactId,
      _dbClient.groupIdColName: interestId,
    });
  }

  Future<void> removeInterestFromContact(int contactId) async {
    final db = await _dbClient.database;
    await db.delete(
      _dbClient.contactGroupTblName,
      where: '${_dbClient.contactIdColName} = ?',
      whereArgs: [contactId],
    );
  }

  Future<void> updateInterest(GroupModel interest) async {
    final db = await _dbClient.database;
    await db.update(
      _dbClient.groupTblName,
      interest.toMap(),
      where: '${_dbClient.groupIdColName} = ?',
      whereArgs: [interest.id],
    );
  }

  Future<void> deleteInterest(int interestId) async {
    final db = await _dbClient.database;
    await db.delete(
      _dbClient.groupTblName,
      where: '${_dbClient.groupIdColName} = ?',
      whereArgs: [interestId],
    );
  }
}
