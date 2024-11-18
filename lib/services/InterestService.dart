import 'package:friendlyreminder/services/DatabaseClient.dart';
import 'package:friendlyreminder/models/InterestModel.dart';

class InterestService {
  final DatabaseClient _dbClient = DatabaseClient();

  Future<List<InterestModel>> getAllInterests() async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps = await db.query(
        _dbClient.interestTblName,
        orderBy: '${_dbClient.interestNameColName} ASC');
    return List.generate(maps.length, (i) {
      return InterestModel.fromMap(maps[i]);
    });
  }

  Future<int> getOrCreateInterest(InterestModel interest) async {
    final db = await _dbClient.database;

    var result = await db.query(
      _dbClient.interestTblName,
      where: '${_dbClient.interestNameColName} = ?',
      whereArgs: [interest.name],
    );

    // Check if interest already exists
    int interestId;
    if (result.isNotEmpty) {
      // Interest already exists
      interestId = result.first[_dbClient.interestIdColName] as int;
    } else {
      // Interest does not exist
      interestId = await db.insert(_dbClient.interestTblName, interest.toMap());
    }
    return interestId;
  }

  Future<List<InterestModel>> getInterestsForContact(int contactId) async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT I.*
    FROM ${_dbClient.interestTblName} I
    JOIN ${_dbClient.contactInterestTblName} CI ON (CI.${_dbClient.interestIdColName} = I.${_dbClient.interestIdColName})
    WHERE CI.${_dbClient.contactIdColName} = $contactId
    ''');
    return List.generate(maps.length, (i) {
      return InterestModel.fromMap(maps[i]);
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
    await db.insert(_dbClient.contactInterestTblName, {
      _dbClient.contactIdColName: contactId,
      _dbClient.interestIdColName: interestId,
    });
  }

  Future<void> removeInterestFromContact(int contactId) async {
    final db = await _dbClient.database;
    await db.delete(
      _dbClient.contactInterestTblName,
      where: '${_dbClient.contactIdColName} = ?',
      whereArgs: [contactId],
    );
  }

  Future<void> updateInterest(InterestModel interest) async {
    final db = await _dbClient.database;
    await db.update(
      _dbClient.interestTblName,
      interest.toMap(),
      where: '${_dbClient.interestIdColName} = ?',
      whereArgs: [interest.id],
    );
  }

  Future<void> deleteInterest(int interestId) async {
    final db = await _dbClient.database;
    await db.delete(
      _dbClient.interestTblName,
      where: '${_dbClient.interestIdColName} = ?',
      whereArgs: [interestId],
    );
  }
}
