import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:friendlyreminder/services/DatabaseInitializer.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class DatabaseClient {
  static final DatabaseClient _instance =
      DatabaseClient._internal(); // Singleton
  static Database? _db;

  final String contactTbl = "Contact";
  final String contactId = "ContactId";
  final String contactName = "ContactName";
  final String contactPhone = "ContactPhone";
  final String contactEmail = "ContactEmail";
  final String contactNotes = "ContactNotes";
  final String contactReminders = "ContactReminders";

  final String reminderTbl = "Reminder";
  final String reminderId = "ReminderId";
  final String reminderDate = "ReminderDate";
  final String reminderFreq = "ReminderFreq";

  final String groupTbl = '[Group]'; // Group is reserved word in SQL
  final String groupId = 'GroupId';
  final String groupName = 'GroupName';
  final String groupSize = 'GroupSize';

  final String contactGroupTbl = 'ContactGroup';

  final String aiPromptsTbl = 'AIPrompts';
  final String promptId = 'PromptId';
  final String promptText = 'PromptText';

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
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else {
      if (Platform.isWindows || Platform.isLinux) {
        // Init ffi loader if needed.
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
      // Default initialization is for mobile platforms (Android and iOS)
    }

    final String dbDirPath = await getDatabasesPath();

    final String dbPath = join(dbDirPath, "friendly_reminder_database.db");
    await deleteDatabase(dbPath); // REM
    final Database database = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (database, version) {
          database.execute('''
        CREATE TABLE $contactTbl (
          $contactId INTEGER PRIMARY KEY AUTOINCREMENT,
          $contactName TEXT NOT NULL,
          $contactPhone TEXT,
          $contactEmail TEXT,
          $contactNotes TEXT,
          $contactReminders TEXT
        )        
        ''');
          database.execute('''
        CREATE TABLE $reminderTbl (
          $reminderId INTEGER PRIMARY KEY AUTOINCREMENT,
          $contactId INTEGER NOT NULL,
          $reminderDate TEXT NOT NULL,
          $reminderFreq TEXT NOT NULL,
          FOREIGN KEY ($contactId) REFERENCES $contactTbl($contactId) ON DELETE CASCADE
        )
        ''');
          database.execute('''
        CREATE TABLE $groupTbl (
          $groupId INTEGER PRIMARY KEY AUTOINCREMENT,
          $groupName TEXT NOT NULL,
          $groupSize INTEGER DEFAULT 0
        )    
        ''');
          database.execute('''
        CREATE TABLE $contactGroupTbl (
          $contactId INTEGER NOT NULL,
          $groupId INTEGER NOT NULL,
          PRIMARY KEY ($contactId, $groupId),
          FOREIGN KEY ($contactId) REFERENCES $contactTbl($contactId),
          FOREIGN KEY ($groupId) REFERENCES $groupTbl($groupId)
        )    
        ''');
        database.execute('''
        CREATE TABLE $aiPromptsTbl (
          $promptId INTEGER PRIMARY KEY AUTOINCREMENT,
          $promptText TEXT NOT NULL
        )
         
        ''');
          // Initialize data after creating tables
          DatabaseInitializer(database).initializeDatabase();
        },
      ),
    );

    return database;
  }
}
