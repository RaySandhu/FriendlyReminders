import 'package:sqflite/sqflite.dart';
import 'package:friendlyreminder/services/DatabaseClient.dart';

class DatabaseInitializer {
  final Database database;

  DatabaseInitializer(this.database);

  Future<void> initializeDatabase() async {
    final Batch batch = database.batch();

    var dbClient = DatabaseClient();

    // Contact
    batch.insert(dbClient.contactTbl, {
      dbClient.contactId: 1,
      dbClient.contactName: 'Bob',
      dbClient.contactPhone: '(123) 456-7890',
      dbClient.contactEmail: 'bob@gmail.com',
      dbClient.contactNotes: 'Hello',
    });
    batch.insert(dbClient.contactTbl, {
      dbClient.contactId: 2,
      dbClient.contactName: 'Alice',
      dbClient.contactPhone: '(987) 654-3210',
      dbClient.contactEmail: 'alice@gmail.com',
      dbClient.contactNotes: 'Hi there',
      dbClient.latestContactDate: '2024-12-06 00:00:00.000'
    });
    batch.insert(dbClient.contactTbl, {
      dbClient.contactId: 3,
      dbClient.contactName: 'Charlie',
      dbClient.contactPhone: '(555) 123-4567',
      dbClient.contactEmail: 'charlie@gmail.com',
      dbClient.contactNotes: 'Nice to meet you',
      dbClient.latestContactDate: '2024-11-19 00:00:00.000'
    });
    batch.insert(dbClient.contactTbl, {
      dbClient.contactId: 4,
      dbClient.contactName: 'David',
      dbClient.contactPhone: '(111) 222-3333',
      dbClient.contactEmail: 'david@gmail.com',
      dbClient.contactNotes: 'Call me anytime',
    });
    batch.insert(dbClient.contactTbl, {
      dbClient.contactId: 5,
      dbClient.contactName: 'Eva',
      dbClient.contactPhone: '(444) 555-6666',
      dbClient.contactEmail: 'eva@gmail.com',
      dbClient.contactNotes: 'Work colleague',
    });
    batch.insert(dbClient.contactTbl, {
      dbClient.contactId: 6,
      dbClient.contactName: 'Frank',
      dbClient.contactPhone: '(777) 888-9999',
      dbClient.contactEmail: 'frank@gmail.com',
      dbClient.contactNotes: 'Old friend',
    });
    batch.insert(dbClient.contactTbl, {
      dbClient.contactId: 7,
      dbClient.contactName: 'Grace',
      dbClient.contactPhone: '(222) 333-4444',
      dbClient.contactEmail: 'grace@gmail.com',
      dbClient.contactNotes: 'Birthday on May 15',
    });
    batch.insert(dbClient.contactTbl, {
      dbClient.contactId: 8,
      dbClient.contactName: 'Henry',
      dbClient.contactPhone: '(666) 777-8888',
      dbClient.contactEmail: 'henry@gmail.com',
      dbClient.contactNotes: 'Tennis partner',
    });
    batch.insert(dbClient.contactTbl, {
      dbClient.contactId: 9,
      dbClient.contactName: 'Ivy',
      dbClient.contactPhone: '(999) 000-1111',
      dbClient.contactEmail: 'ivy@gmail.com',
      dbClient.contactNotes: 'Book club member',
    });
    batch.insert(dbClient.contactTbl, {
      dbClient.contactId: 10,
      dbClient.contactName: 'Jack',
      dbClient.contactPhone: '(333) 444-5555',
      dbClient.contactEmail: 'jack@gmail.com',
      dbClient.contactNotes: 'Neighbor',
    });
    batch.insert(dbClient.contactTbl, {
      dbClient.contactId: 11,
      dbClient.contactName: 'Karen',
      dbClient.contactPhone: '(888) 999-0000',
      dbClient.contactEmail: 'karen@gmail.com',
      dbClient.contactNotes: 'Yoga instructor',
    });
    batch.insert(dbClient.contactTbl, {
      dbClient.contactId: 12,
      dbClient.contactName: 'Liam',
      dbClient.contactPhone: '(555) 666-7777',
      dbClient.contactEmail: 'liam@gmail.com',
      dbClient.contactNotes: 'College roommate',
    });
    batch.insert(dbClient.contactTbl, {
      dbClient.contactId: 13,
      dbClient.contactName: 'Mia',
      dbClient.contactPhone: '(000) 111-2222',
      dbClient.contactEmail: 'mia@gmail.com',
      dbClient.contactNotes: 'Dentist',
    });
    batch.insert(dbClient.contactTbl, {
      dbClient.contactId: 14,
      dbClient.contactName: 'Noah',
      dbClient.contactPhone: '(444) 333-2222',
      dbClient.contactEmail: 'noah@gmail.com',
      dbClient.contactNotes: 'Gym buddy',
    });
    batch.insert(dbClient.contactTbl, {
      dbClient.contactId: 15,
      dbClient.contactName: 'Olivia',
      dbClient.contactPhone: '(777) 666-5555',
      dbClient.contactEmail: 'olivia@gmail.com',
      dbClient.contactNotes: 'Cousin',
    });

    batch.insert(dbClient.groupTbl, {
      dbClient.groupId: 1,
      dbClient.groupSize: 3,
      dbClient.groupName: 'Photography 📷',
    });
    batch.insert(dbClient.groupTbl, {
      dbClient.groupId: 2,
      dbClient.groupSize: 3,
      dbClient.groupName: 'Art 🎨',
    });
    batch.insert(dbClient.groupTbl, {
      dbClient.groupId: 3,
      dbClient.groupSize: 3,
      dbClient.groupName: 'Dancing 💃',
    });
    batch.insert(dbClient.groupTbl, {
      dbClient.groupId: 4,
      dbClient.groupSize: 3,
      dbClient.groupName: 'Singing 🎤',
    });
    batch.insert(dbClient.groupTbl, {
      dbClient.groupId: 5,
      dbClient.groupSize: 3,
      dbClient.groupName: 'Writing 📝',
    });
    batch.insert(dbClient.groupTbl, {
      dbClient.groupId: 6,
      dbClient.groupSize: 3,
      dbClient.groupName: 'Baking 🍰',
    });
    batch.insert(dbClient.groupTbl, {
      dbClient.groupId: 7,
      dbClient.groupSize: 3,
      dbClient.groupName: 'Board games 🎲',
    });
    batch.insert(dbClient.groupTbl, {
      dbClient.groupId: 8,
      dbClient.groupSize: 3,
      dbClient.groupName: 'Cooking 🍳',
    });
    batch.insert(dbClient.groupTbl, {
      dbClient.groupId: 9,
      dbClient.groupSize: 3,
      dbClient.groupName: 'Video games 🎮',
    });

// Alice
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 2,
      dbClient.groupId: 2, // Art
    });
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 2,
      dbClient.groupId: 6, // Baking
    });
// Bob
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 1,
      dbClient.groupId: 1, // Photography
    });
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 1,
      dbClient.groupId: 7, // Board games
    });

// Charlie
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 3,
      dbClient.groupId: 3, // Dancing
    });
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 3,
      dbClient.groupId: 4, // Singing
    });

// David
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 4,
      dbClient.groupId: 9, // Video games
    });

// Eva
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 5,
      dbClient.groupId: 5, // Writing
    });
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 5,
      dbClient.groupId: 8, // Cooking
    });

// Frank
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 6,
      dbClient.groupId: 1, // Photography
    });

// Grace
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 7,
      dbClient.groupId: 6, // Baking
    });
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 7,
      dbClient.groupId: 8, // Cooking
    });

// Henry
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 8,
      dbClient.groupId: 7, // Board games
    });
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 8,
      dbClient.groupId: 9, // Video games
    });

// Ivy
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 9,
      dbClient.groupId: 2, // Art
    });
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 9,
      dbClient.groupId: 5, // Writing
    });

// Jack
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 10,
      dbClient.groupId: 3, // Dancing
    });

// Karen
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 11,
      dbClient.groupId: 3, // Dancing
    });
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 11,
      dbClient.groupId: 6, // Baking
    });

// Liam
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 12,
      dbClient.groupId: 4, // Singing
    });
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 12,
      dbClient.groupId: 9, // Video games
    });

// Mia
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 13,
      dbClient.groupId: 1, // Photography
    });
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 13,
      dbClient.groupId: 2, // Art
    });

// Noah
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 14,
      dbClient.groupId: 7, // Board games
    });
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 14,
      dbClient.groupId: 8, // Cooking
    });

// Olivia
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 15,
      dbClient.groupId: 4, // Singing
    });
    batch.insert(dbClient.contactGroupTbl, {
      dbClient.contactId: 15,
      dbClient.groupId: 5, // Writing
    });

// Reminders
    batch.insert(dbClient.reminderTbl, {
      dbClient.contactId: 2,
      dbClient.reminderDate: "2024-12-09 00:00:00.000",
      dbClient.reminderFreq: "Once"
    });
    batch.insert(dbClient.reminderTbl, {
      dbClient.contactId: 8,
      dbClient.reminderDate: "2024-12-09 00:00:00.000",
      dbClient.reminderFreq: "Yearly"
    });
    batch.insert(dbClient.reminderTbl, {
      dbClient.contactId: 6,
      dbClient.reminderDate: "2024-12-09 00:00:00.000",
      dbClient.reminderFreq: "Monthly"
    });
    batch.insert(dbClient.reminderTbl, {
      dbClient.contactId: 2,
      dbClient.reminderDate: "2024-12-01 00:00:00.000",
      dbClient.reminderFreq: "Once"
    });

    batch.insert(dbClient.reminderTbl, {
      dbClient.contactId: 3,
      dbClient.reminderDate: "2024-12-01 00:00:00.000",
      dbClient.reminderFreq: "Daily"
    });

    batch.insert(dbClient.reminderTbl, {
      dbClient.contactId: 4,
      dbClient.reminderDate: "2024-11-22 00:00:00.000",
      dbClient.reminderFreq: "Weekly"
    });
    
    batch.insert(dbClient.reminderTbl, {
      dbClient.contactId: 3,
      dbClient.reminderDate: "2024-12-07 00:00:00.000",
      dbClient.reminderFreq: "Weekly"
    });
    
    batch.insert(dbClient.reminderTbl, {
      dbClient.contactId: 7,
      dbClient.reminderDate: "2024-12-07 00:00:00.000",
      dbClient.reminderFreq: "Weekly"
    });
// AI Prompts
    batch.insert(dbClient.aiPromptsTbl, {
      dbClient.promptId: 1,
      dbClient.promptText: 'How are you doing today?',
    });

    batch.insert(dbClient.aiPromptsTbl, {
      dbClient.promptId: 2,
      dbClient.promptText: 'What are you up to this weekend?',
    });

    batch.insert(dbClient.aiPromptsTbl, {
      dbClient.promptId: 3,
      dbClient.promptText: 'What are you reading these days?',
    });

    batch.insert(dbClient.aiPromptsTbl, {
      dbClient.promptId: 4,
      dbClient.promptText: 'What are you watching on TV?',
    });

    batch.insert(dbClient.aiPromptsTbl, {
      dbClient.promptId: 5,
      dbClient.promptText: 'What are you listening to right now?',
    });

    batch.insert(dbClient.aiPromptsTbl, {
      dbClient.promptId: 6,
      dbClient.promptText: 'What are you doing for the holidays?',
    });

    batch.insert(dbClient.aiPromptsTbl, {
      dbClient.promptId: 7,
      dbClient.promptText: 'What are you doing for your birthday?',
    });

    batch.insert(dbClient.aiPromptsTbl, {
      dbClient.promptId: 8,
      dbClient.promptText: 'What are you doing for the summer?',
    });

    batch.insert(dbClient.aiPromptsTbl, {
      dbClient.promptId: 9,
      dbClient.promptText: 'What are you doing for the winter?',
    });

    batch.insert(dbClient.aiPromptsTbl, {
      dbClient.promptId: 10,
      dbClient.promptText: 'What are you doing for the spring?',
    });

    batch.insert(dbClient.aiPromptsTbl, {
      dbClient.promptId: 11,
      dbClient.promptText: 'What are you doing for the fall?',
    });

    batch.insert(dbClient.aiPromptsTbl, {
      dbClient.promptId: 12,
      dbClient.promptText: 'What are you doing for the new year?',
    });

    // Commit the batch
    await batch.commit(noResult: true);
  }
}
