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
      dbClient.contactNameColName: 'Bob',
      dbClient.contactPhoneColName: '(123)-456-7890',
      dbClient.contactEmailColName: 'bob@gmail.com',
      dbClient.contactNotesColName: 'Hello',
    });
    batch.insert(dbClient.contactTblName, {
      dbClient.contactNameColName: 'Alice',
      dbClient.contactPhoneColName: '(987)-654-3210',
      dbClient.contactEmailColName: 'alice@gmail.com',
      dbClient.contactNotesColName: 'Hi there',
    });
    batch.insert(dbClient.contactTblName, {
      dbClient.contactNameColName: 'Charlie',
      dbClient.contactPhoneColName: '(555)-123-4567',
      dbClient.contactEmailColName: 'charlie@gmail.com',
      dbClient.contactNotesColName: 'Nice to meet you',
    });

    // Interest Category
    batch.insert(dbClient.interestCategoryTblName, {
      dbClient.categoryIdColName: 1,
      dbClient.categoryNameColName: 'Creativity',
    });
    batch.insert(dbClient.interestCategoryTblName, {
      dbClient.categoryIdColName: 2,
      dbClient.categoryNameColName: 'Going out',
    });
    batch.insert(dbClient.interestCategoryTblName, {
      dbClient.categoryIdColName: 3,
      dbClient.categoryNameColName: 'Staying in',
    });

    // Interest Badge
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 1,
      dbClient.badgeNameColName: '📷 Photography',
      dbClient.categoryIdColName: 1,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 2,
      dbClient.badgeNameColName: '🎨 Art',
      dbClient.categoryIdColName: 1,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 3,
      dbClient.badgeNameColName: '🧷 Crafts',
      dbClient.categoryIdColName: 1,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 4,
      dbClient.badgeNameColName: '💃 Dancing',
      dbClient.categoryIdColName: 1,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 5,
      dbClient.badgeNameColName: '✏️ Design',
      dbClient.categoryIdColName: 1,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 6,
      dbClient.badgeNameColName: '💄 Make-up',
      dbClient.categoryIdColName: 1,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 7,
      dbClient.badgeNameColName: '🎞️ Making videos',
      dbClient.categoryIdColName: 1,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 8,
      dbClient.badgeNameColName: '🎤 Singing',
      dbClient.categoryIdColName: 1,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 9,
      dbClient.badgeNameColName: '📝 Writing',
      dbClient.categoryIdColName: 1,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 10,
      dbClient.badgeNameColName: '🍻 Bar',
      dbClient.categoryIdColName: 2,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 11,
      dbClient.badgeNameColName: '☕ Cafe-hopping',
      dbClient.categoryIdColName: 2,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 12,
      dbClient.badgeNameColName: '🕺 Clubs',
      dbClient.categoryIdColName: 2,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 13,
      dbClient.badgeNameColName: '🎟️ Concerts',
      dbClient.categoryIdColName: 2,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 14,
      dbClient.badgeNameColName: '🎊 Festivals',
      dbClient.categoryIdColName: 2,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 15,
      dbClient.badgeNameColName: '🎤 Karaoke',
      dbClient.categoryIdColName: 2,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 16,
      dbClient.badgeNameColName: '🏛️ Museums & galleries',
      dbClient.categoryIdColName: 2,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 17,
      dbClient.badgeNameColName: '🎙️ Stand up',
      dbClient.categoryIdColName: 2,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 18,
      dbClient.badgeNameColName: '🎭 Theater',
      dbClient.categoryIdColName: 2,
    });

    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 19,
      dbClient.badgeNameColName: '🍰 Baking',
      dbClient.categoryIdColName: 3,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 20,
      dbClient.badgeNameColName: '🎲 Board games',
      dbClient.categoryIdColName: 3,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 21,
      dbClient.badgeNameColName: '🍳 Cooking',
      dbClient.categoryIdColName: 3,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 22,
      dbClient.badgeNameColName: '🌱 Gardening',
      dbClient.categoryIdColName: 3,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 23,
      dbClient.badgeNameColName: '🥡 Takeout',
      dbClient.categoryIdColName: 3,
    });
    batch.insert(dbClient.interestBadgeTblName, {
      dbClient.badgeIdColName: 24,
      dbClient.badgeNameColName: '🎮 Video games',
      dbClient.categoryIdColName: 3,
    });
    // Commit the batch
    await batch.commit(noResult: true);
  }
}
