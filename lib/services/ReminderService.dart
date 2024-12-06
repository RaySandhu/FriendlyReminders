import 'package:sqflite/sqflite.dart';
import 'package:friendlyreminder/models/ReminderModel.dart';
import 'package:friendlyreminder/services/DatabaseClient.dart';

class ReminderService {
  final DatabaseClient _dbClient = DatabaseClient();

  Future<List<ReminderModel>> getAllReminders() async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps =
        await db.query(_dbClient.reminderTbl);
    return List.generate(maps.length, (i) {
      // print("Reminder rows: ${maps[i].entries}");
      return ReminderModel.fromMap(maps[i]);
    });
  }

  /// Get all reminders for a specific contact
  Future<List<ReminderModel>> getRemindersByContactId(int contactId) async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _dbClient.reminderTbl,
      where: '${_dbClient.contactId} = ?',
      whereArgs: [contactId],
    );
    return List.generate(maps.length, (i) {
      return ReminderModel.fromMap(maps[i]);
    });
  }

  /// Get a specific reminder by its ID
  Future<ReminderModel> getReminder(int reminderId) async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _dbClient.reminderTbl,
      where: '${_dbClient.reminderId} = ?',
      whereArgs: [reminderId],
    );
    if (maps.isNotEmpty) {
      return ReminderModel.fromMap(maps.first);
    }
    throw Exception('ReminderService - Reminder not found');
  }

  /// Create a new reminder
  Future<int> createReminder(ReminderModel reminder, int contactId) async {
    final db = await _dbClient.database;
    int reminderId = await db.insert(
      _dbClient.reminderTbl,
      {
        'contactId': contactId,
        'reminderDate': reminder.date.toIso8601String(),
        'reminderFreq': reminder.freq,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return reminderId;
  }

  /// Update an existing reminder
  Future<void> updateReminder(ReminderModel reminder, int reminderId) async {
    final db = await _dbClient.database;
    await db.update(
      _dbClient.reminderTbl,
      reminder.toMap(),
      where: '${_dbClient.reminderId} = ?',
      whereArgs: [reminderId],
    );
  }

  /// Delete a specific reminder
  Future<void> deleteReminder({int? reminderId, int? contactId}) async {
    final db = await _dbClient.database;

    if (contactId != null && reminderId == null) {
      await db.delete(
        _dbClient.reminderTbl,
        where: '${_dbClient.contactId} = ?',
        whereArgs: [contactId],
      );
    } else if (reminderId != null && contactId == null) {
      await db.delete(
        _dbClient.reminderTbl,
        where: '${_dbClient.reminderId} = ?',
        whereArgs: [reminderId],
      );
    } else {
      throw ArgumentError(
          'Either ${_dbClient.contactId} or ${_dbClient.reminderId} must be provided');
    }
  }

  /// Delete all reminders for a specific contact
  Future<void> deleteRemindersByContactId(int contactId) async {
    final db = await _dbClient.database;
    await db.delete(
      _dbClient.reminderTbl,
      where: '${_dbClient.contactId} = ?',
      whereArgs: [contactId],
    );
  }
}
