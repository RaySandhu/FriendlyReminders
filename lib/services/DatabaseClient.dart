import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:friendlyreminder/services/DatabaseInitializer.dart';

class DatabaseClient {
  static final DatabaseClient _instance =
      DatabaseClient._internal(); // Singleton
  static Database? _db;

  final String contactTblName = "Contact";
  final String contactIdColName = "ContactId";
  final String contactNameColName = "ContactName";
  final String contactPhoneColName = "ContactPhone";
  final String contactEmailColName = "ContactEmail";
  final String contactNotesColName = "ContactNotes";

  final String interestTblName = 'Interest';
  final String interestIdColName = 'InterestId';
  final String interestNameColName = 'InterestName';

  final String interestTagTblName = 'InterestTag';
  final String tagIdColName = 'TagId';

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
        CREATE TABLE $contactTblName (
          $contactIdColName INTEGER PRIMARY KEY AUTOINCREMENT,
          $contactNameColName TEXT NOT NULL,
          $contactPhoneColName TEXT,
          $contactEmailColName TEXT,
          $contactNotesColName TEXT
        )        
        ''');
        database.execute('''
        CREATE TABLE $interestTblName (
          $interestIdColName INTEGER PRIMARY KEY AUTOINCREMENT,
          $interestNameColName TEXT NOT NULL
        )    
        ''');
        database.execute('''
        CREATE TABLE $interestTagTblName (
          $tagIdColName INTEGER PRIMARY KEY AUTOINCREMENT,
          $contactIdColName INTEGER NOT NULL,
          $interestIdColName INTEGER NOT NULL,
          FOREIGN KEY ($contactIdColName) REFERENCES $contactTblName($contactIdColName),
          FOREIGN KEY ($interestIdColName) REFERENCES $interestTblName($interestIdColName)
        )    
        ''');

        // Initialize data after creating tables
        DatabaseInitializer(database).initializeDatabase();
      },
    );

    return database;
  }
}
