import 'package:friendlyreminder/services/DatabaseClient.dart';
import 'package:friendlyreminder/models/InterestModel.dart';

class InterestService {
  final DatabaseClient _dbClient = DatabaseClient();

  Future<int> getOrCreateInterest(InterestModel interest) async {
    final db = await _dbClient.database;

    var result = await db.query(
      _dbClient.interestTblName,
      where: '${_dbClient.interestNameColName} = ?',
      whereArgs: [interest.name],
    );

    // Check if interest already exists
    if (result.isNotEmpty) {
      // Interest already exists
      return result.first[_dbClient.interestIdColName] as int;
    }

    // Interest does not exist
    int interestId = await db.insert(
      _dbClient.interestTblName,
      interest.toMap(),
    );
    return interestId;
  }

  // REM
  Future<void> deleteContactInterest(int id) async {
    final db = await _dbClient.database;
    await db.delete(
      _dbClient.interestTblName,
      where: 'InterestId = ?',
      whereArgs: [id],
    );
  }
}
