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

  final String contactTblName = "Contact";
  final String contactIdColName = "ContactId";
  final String contactNameColName = "ContactName";
  final String contactPhoneColName = "ContactPhone";
  final String contactEmailColName = "ContactEmail";
  final String contactNotesColName = "ContactNotes";

  final String groupTblName = '[Group]';
  final String groupIdColName = 'GroupId';
  final String groupNameColName = 'GroupName';

  final String contactGroupTblName = 'ContactGroup';

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
        CREATE TABLE $contactTblName (
          $contactIdColName INTEGER PRIMARY KEY AUTOINCREMENT,
          $contactNameColName TEXT NOT NULL,
          $contactPhoneColName TEXT,
          $contactEmailColName TEXT,
          $contactNotesColName TEXT
        )        
        ''');
          database.execute('''
        CREATE TABLE $groupTblName (
          $groupIdColName INTEGER PRIMARY KEY AUTOINCREMENT,
          $groupNameColName TEXT NOT NULL
        )    
        ''');
          database.execute('''
        CREATE TABLE $contactGroupTblName (
          $contactIdColName INTEGER NOT NULL,
          $groupIdColName INTEGER NOT NULL,
          PRIMARY KEY ($contactIdColName, $groupIdColName),
          FOREIGN KEY ($contactIdColName) REFERENCES $contactTblName($contactIdColName),
          FOREIGN KEY ($groupIdColName) REFERENCES $groupTblName($groupIdColName)
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
