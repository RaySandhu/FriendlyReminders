import 'package:sqflite/sqflite.dart';
import 'package:friendlyreminder/services/DatabaseClient.dart';

class DatabaseInitializer {
  final Database database;

  DatabaseInitializer(this.database);

  Future<void> initializeDatabase() async {
    final Batch batch = database.batch();

    var dbClient = DatabaseClient();

    // Contact
    batch.insert(dbClient.contactTblName, {
      dbClient.contactIdColName: 1,
      dbClient.contactNameColName: 'Bob',
      dbClient.contactPhoneColName: '(123)-456-7890',
      dbClient.contactEmailColName: 'bob@gmail.com',
      dbClient.contactNotesColName: 'Hello',
    });
    batch.insert(dbClient.contactTblName, {
      dbClient.contactIdColName: 2,
      dbClient.contactNameColName: 'Alice',
      dbClient.contactPhoneColName: '(987)-654-3210',
      dbClient.contactEmailColName: 'alice@gmail.com',
      dbClient.contactNotesColName: 'Hi there',
    });
    batch.insert(dbClient.contactTblName, {
      dbClient.contactIdColName: 3,
      dbClient.contactNameColName: 'Charlie',
      dbClient.contactPhoneColName: '(555)-123-4567',
      dbClient.contactEmailColName: 'charlie@gmail.com',
      dbClient.contactNotesColName: 'Nice to meet you',
    });

    batch.insert(dbClient.interestTblName, {
      dbClient.interestIdColName: 1,
      dbClient.interestNameColName: '📷 Photography',
    });
    batch.insert(dbClient.interestTblName, {
      dbClient.interestIdColName: 2,
      dbClient.interestNameColName: '🎨 Art',
    });
    batch.insert(dbClient.interestTblName, {
      dbClient.interestIdColName: 3,
      dbClient.interestNameColName: '💃 Dancing',
    });
    batch.insert(dbClient.interestTblName, {
      dbClient.interestIdColName: 4,
      dbClient.interestNameColName: '🎤 Singing',
    });
    batch.insert(dbClient.interestTblName, {
      dbClient.interestIdColName: 5,
      dbClient.interestNameColName: '📝 Writing',
    });
    batch.insert(dbClient.interestTblName, {
      dbClient.interestIdColName: 6,
      dbClient.interestNameColName: '🍰 Baking',
    });
    batch.insert(dbClient.interestTblName, {
      dbClient.interestIdColName: 7,
      dbClient.interestNameColName: '🎲 Board games',
    });
    batch.insert(dbClient.interestTblName, {
      dbClient.interestIdColName: 8,
      dbClient.interestNameColName: '🍳 Cooking',
    });
    batch.insert(dbClient.interestTblName, {
      dbClient.interestIdColName: 9,
      dbClient.interestNameColName: '🎮 Video games',
    });

    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 1,
      dbClient.interestIdColName: 1,
    });
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 2,
      dbClient.interestIdColName: 1,
    });
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 3,
      dbClient.interestIdColName: 2,
    });
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 2,
      dbClient.interestIdColName: 2,
    });

    // Commit the batch
    await batch.commit(noResult: true);
  }
}
