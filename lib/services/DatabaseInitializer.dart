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

    batch.insert(dbClient.groupTblName, {
      dbClient.groupIdColName: 1,
      dbClient.groupNameColName: 'Photography 📷',
    });
    batch.insert(dbClient.groupTblName, {
      dbClient.groupIdColName: 2,
      dbClient.groupNameColName: 'Art 🎨',
    });
    batch.insert(dbClient.groupTblName, {
      dbClient.groupIdColName: 3,
      dbClient.groupNameColName: 'Dancing 💃',
    });
    batch.insert(dbClient.groupTblName, {
      dbClient.groupIdColName: 4,
      dbClient.groupNameColName: 'Singing 🎤',
    });
    batch.insert(dbClient.groupTblName, {
      dbClient.groupIdColName: 5,
      dbClient.groupNameColName: 'Writing 📝',
    });
    batch.insert(dbClient.groupTblName, {
      dbClient.groupIdColName: 6,
      dbClient.groupNameColName: 'Baking 🍰',
    });
    batch.insert(dbClient.groupTblName, {
      dbClient.groupIdColName: 7,
      dbClient.groupNameColName: 'Board games 🎲',
    });
    batch.insert(dbClient.groupTblName, {
      dbClient.groupIdColName: 8,
      dbClient.groupNameColName: 'Cooking 🍳',
    });
    batch.insert(dbClient.groupTblName, {
      dbClient.groupIdColName: 9,
      dbClient.groupNameColName: 'Video games 🎮',
    });

// Alice
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 2,
      dbClient.groupIdColName: 2, // Art
    });
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 2,
      dbClient.groupIdColName: 6, // Baking
    });
// Bob
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 1,
      dbClient.groupIdColName: 1, // Photography
    });
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 1,
      dbClient.groupIdColName: 7, // Board games
    });

// Charlie
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 3,
      dbClient.groupIdColName: 3, // Dancing
    });
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 3,
      dbClient.groupIdColName: 4, // Singing
    });

// David
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 4,
      dbClient.groupIdColName: 9, // Video games
    });

// Eva
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 5,
      dbClient.groupIdColName: 5, // Writing
    });
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 5,
      dbClient.groupIdColName: 8, // Cooking
    });

// Frank
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 6,
      dbClient.groupIdColName: 1, // Photography
    });

// Grace
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 7,
      dbClient.groupIdColName: 6, // Baking
    });
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 7,
      dbClient.groupIdColName: 8, // Cooking
    });

// Henry
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 8,
      dbClient.groupIdColName: 7, // Board games
    });
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 8,
      dbClient.groupIdColName: 9, // Video games
    });

// Ivy
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 9,
      dbClient.groupIdColName: 2, // Art
    });
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 9,
      dbClient.groupIdColName: 5, // Writing
    });

// Jack
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 10,
      dbClient.groupIdColName: 3, // Dancing
    });

// Karen
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 11,
      dbClient.groupIdColName: 3, // Dancing
    });
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 11,
      dbClient.groupIdColName: 6, // Baking
    });

// Liam
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 12,
      dbClient.groupIdColName: 4, // Singing
    });
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 12,
      dbClient.groupIdColName: 9, // Video games
    });

// Mia
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 13,
      dbClient.groupIdColName: 1, // Photography
    });
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 13,
      dbClient.groupIdColName: 2, // Art
    });

// Noah
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 14,
      dbClient.groupIdColName: 7, // Board games
    });
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 14,
      dbClient.groupIdColName: 8, // Cooking
    });

// Olivia
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 15,
      dbClient.groupIdColName: 4, // Singing
    });
    batch.insert(dbClient.contactGroupTblName, {
      dbClient.contactIdColName: 15,
      dbClient.groupIdColName: 5, // Writing
    });

    // Commit the batch
    await batch.commit(noResult: true);
  }
}
