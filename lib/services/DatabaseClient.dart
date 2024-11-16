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

  final String interestCategoryTblName = 'InterestCategory';
  final String categoryIdColName = 'CategoryId';
  final String categoryNameColName = 'CategoryName';

  final String interestBadgeTblName = 'InterestBadge';
  final String badgeIdColName = 'BadgeId';
  final String badgeNameColName = 'BadgeName';

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
        CREATE TABLE $interestCategoryTblName (
          $categoryIdColName INTEGER PRIMARY KEY AUTOINCREMENT,
          $categoryNameColName TEXT NOT NULL
        )       
        ''');
        database.execute('''
        CREATE TABLE $interestBadgeTblName (
          $badgeIdColName INTEGER PRIMARY KEY AUTOINCREMENT,
          $badgeNameColName TEXT NOT NULL,
          $categoryIdColName INTEGER NOT NULL,
          FOREIGN KEY ($categoryIdColName) REFERENCES $interestCategoryTblName($categoryIdColName)
        )    
        ''');

        // Initialize data after creating tables
        DatabaseInitializer(database).initializeDatabase();
      },
    );

    return database;
  }
}
