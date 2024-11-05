import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseClient {
  static final DatabaseClient _instance =
      DatabaseClient._internal(); // Singleton
  static Database? _db;

  final String contactsTblName = "contacts";
  final String _contactsIdColName = "id";
  final String _contactsNameColName = "name";
  final String _contactsPhoneColName = "phone";
  final String _contactsEmailColName = "email";
  final String _contactsNotesColName = "notes";

  // final String _groupsTblName = "groups";
  // final String _remindersTblName = "reminders";

  factory DatabaseClient() {
    return _instance;
  }
  DatabaseClient._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final String dbDirPath = await getDatabasesPath();
    final String dbPath = join(dbDirPath, "friendly_reminder_database.db");
    await deleteDatabase(dbPath); // REM
    final Database database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (database, version) {
        database.execute('''
        CREATE TABLE $contactsTblName (
          $_contactsIdColName INTEGER PRIMARY KEY AUTOINCREMENT,
          $_contactsNameColName TEXT NOT NULL,
          $_contactsPhoneColName TEXT,
          $_contactsEmailColName TEXT,
          $_contactsNotesColName TEXT
        )
        ''');
      },
    );

    // REM
    final Batch batch = database.batch();

    batch.insert('contacts', {
      'name': 'Bob',
      'phone': '(123)-456-7890',
      'email': 'bob@gmail.com',
      'notes': 'Hello'
    });

    batch.insert('contacts', {
      'name': 'Alice',
      'phone': '(987)-654-3210',
      'email': 'alice@gmail.com',
      'notes': 'Hi there'
    });

    batch.insert('contacts', {
      'name': 'Charlie',
      'phone': '(555)-123-4567',
      'email': 'charlie@gmail.com',
      'notes': 'Nice to meet you'
    });

    // Commit the batch
    await batch.commit(noResult: true);

    return database;
  }
}
