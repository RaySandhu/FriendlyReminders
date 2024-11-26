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

  final String groupTbl = '[Group]';
  final String groupId = 'GroupId';
  final String groupName = 'GroupName';

  final String contactGroupTbl = 'ContactGroup';

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
          $contactNotes TEXT
        )        
        ''');
          database.execute('''
        CREATE TABLE $groupTbl (
          $groupId INTEGER PRIMARY KEY AUTOINCREMENT,
          $groupName TEXT NOT NULL
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

          // Initialize data after creating tables
          DatabaseInitializer(database).initializeDatabase();
        },
      ),
    );

    return database;
  }
}
