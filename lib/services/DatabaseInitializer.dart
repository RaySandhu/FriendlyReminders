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
    batch.insert(dbClient.contactTblName, {
      dbClient.contactIdColName: 4,
      dbClient.contactNameColName: 'David',
      dbClient.contactPhoneColName: '(111)-222-3333',
      dbClient.contactEmailColName: 'david@gmail.com',
      dbClient.contactNotesColName: 'Call me anytime',
    });
    batch.insert(dbClient.contactTblName, {
      dbClient.contactIdColName: 5,
      dbClient.contactNameColName: 'Eva',
      dbClient.contactPhoneColName: '(444)-555-6666',
      dbClient.contactEmailColName: 'eva@gmail.com',
      dbClient.contactNotesColName: 'Work colleague',
    });
    batch.insert(dbClient.contactTblName, {
      dbClient.contactIdColName: 6,
      dbClient.contactNameColName: 'Frank',
      dbClient.contactPhoneColName: '(777)-888-9999',
      dbClient.contactEmailColName: 'frank@gmail.com',
      dbClient.contactNotesColName: 'Old friend',
    });
    batch.insert(dbClient.contactTblName, {
      dbClient.contactIdColName: 7,
      dbClient.contactNameColName: 'Grace',
      dbClient.contactPhoneColName: '(222)-333-4444',
      dbClient.contactEmailColName: 'grace@gmail.com',
      dbClient.contactNotesColName: 'Birthday on May 15',
    });
    batch.insert(dbClient.contactTblName, {
      dbClient.contactIdColName: 8,
      dbClient.contactNameColName: 'Henry',
      dbClient.contactPhoneColName: '(666)-777-8888',
      dbClient.contactEmailColName: 'henry@gmail.com',
      dbClient.contactNotesColName: 'Tennis partner',
    });
    batch.insert(dbClient.contactTblName, {
      dbClient.contactIdColName: 9,
      dbClient.contactNameColName: 'Ivy',
      dbClient.contactPhoneColName: '(999)-000-1111',
      dbClient.contactEmailColName: 'ivy@gmail.com',
      dbClient.contactNotesColName: 'Book club member',
    });
    batch.insert(dbClient.contactTblName, {
      dbClient.contactIdColName: 10,
      dbClient.contactNameColName: 'Jack',
      dbClient.contactPhoneColName: '(333)-444-5555',
      dbClient.contactEmailColName: 'jack@gmail.com',
      dbClient.contactNotesColName: 'Neighbor',
    });
    batch.insert(dbClient.contactTblName, {
      dbClient.contactIdColName: 11,
      dbClient.contactNameColName: 'Karen',
      dbClient.contactPhoneColName: '(888)-999-0000',
      dbClient.contactEmailColName: 'karen@gmail.com',
      dbClient.contactNotesColName: 'Yoga instructor',
    });
    batch.insert(dbClient.contactTblName, {
      dbClient.contactIdColName: 12,
      dbClient.contactNameColName: 'Liam',
      dbClient.contactPhoneColName: '(555)-666-7777',
      dbClient.contactEmailColName: 'liam@gmail.com',
      dbClient.contactNotesColName: 'College roommate',
    });
    batch.insert(dbClient.contactTblName, {
      dbClient.contactIdColName: 13,
      dbClient.contactNameColName: 'Mia',
      dbClient.contactPhoneColName: '(000)-111-2222',
      dbClient.contactEmailColName: 'mia@gmail.com',
      dbClient.contactNotesColName: 'Dentist',
    });
    batch.insert(dbClient.contactTblName, {
      dbClient.contactIdColName: 14,
      dbClient.contactNameColName: 'Noah',
      dbClient.contactPhoneColName: '(444)-333-2222',
      dbClient.contactEmailColName: 'noah@gmail.com',
      dbClient.contactNotesColName: 'Gym buddy',
    });
    batch.insert(dbClient.contactTblName, {
      dbClient.contactIdColName: 15,
      dbClient.contactNameColName: 'Olivia',
      dbClient.contactPhoneColName: '(777)-666-5555',
      dbClient.contactEmailColName: 'olivia@gmail.com',
      dbClient.contactNotesColName: 'Cousin',
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

// Bob
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 1,
      dbClient.interestIdColName: 1, // Photography
    });
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 1,
      dbClient.interestIdColName: 7, // Board games
    });

// Alice
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 2,
      dbClient.interestIdColName: 2, // Art
    });
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 2,
      dbClient.interestIdColName: 6, // Baking
    });

// Charlie
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 3,
      dbClient.interestIdColName: 3, // Dancing
    });
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 3,
      dbClient.interestIdColName: 4, // Singing
    });

// David
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 4,
      dbClient.interestIdColName: 9, // Video games
    });

// Eva
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 5,
      dbClient.interestIdColName: 5, // Writing
    });
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 5,
      dbClient.interestIdColName: 8, // Cooking
    });

// Frank
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 6,
      dbClient.interestIdColName: 1, // Photography
    });

// Grace
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 7,
      dbClient.interestIdColName: 6, // Baking
    });
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 7,
      dbClient.interestIdColName: 8, // Cooking
    });

// Henry
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 8,
      dbClient.interestIdColName: 7, // Board games
    });
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 8,
      dbClient.interestIdColName: 9, // Video games
    });

// Ivy
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 9,
      dbClient.interestIdColName: 2, // Art
    });
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 9,
      dbClient.interestIdColName: 5, // Writing
    });

// Jack
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 10,
      dbClient.interestIdColName: 3, // Dancing
    });

// Karen
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 11,
      dbClient.interestIdColName: 3, // Dancing
    });
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 11,
      dbClient.interestIdColName: 6, // Baking
    });

// Liam
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 12,
      dbClient.interestIdColName: 4, // Singing
    });
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 12,
      dbClient.interestIdColName: 9, // Video games
    });

// Mia
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 13,
      dbClient.interestIdColName: 1, // Photography
    });
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 13,
      dbClient.interestIdColName: 2, // Art
    });

// Noah
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 14,
      dbClient.interestIdColName: 7, // Board games
    });
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 14,
      dbClient.interestIdColName: 8, // Cooking
    });

// Olivia
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 15,
      dbClient.interestIdColName: 4, // Singing
    });
    batch.insert(dbClient.contactInterestTblName, {
      dbClient.contactIdColName: 15,
      dbClient.interestIdColName: 5, // Writing
    });

    // Commit the batch
    await batch.commit(noResult: true);
  }
}
