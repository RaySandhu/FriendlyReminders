import 'package:friendlyreminder/models/ContactModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:friendlyreminder/services/DatabaseClient.dart';

class ContactService {
  final DatabaseClient _dbClient = DatabaseClient();

  Future<void> createContact(ContactModel contact) async {
    final db = await _dbClient.database;
    await db.insert(
      _dbClient.contactTblName,
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ContactModel>> getContacts() async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps = await db.query(
        _dbClient.contactTblName,
        orderBy: '${_dbClient.contactNameColName} ASC');
    return List.generate(maps.length, (i) {
      return ContactModel.fromMap(maps[i]);
    });
  }

  Future<void> updateContact(ContactModel contact) async {
    final db = await _dbClient.database;
    await db.update(
      _dbClient.contactTblName,
      contact.toMap(),
      where: '${_dbClient.contactIdColName} = ?',
      whereArgs: [contact.id],
    );
  }

  Future<void> deleteContact(int id) async {
    final db = await _dbClient.database;
    await db.delete(
      _dbClient.contactTblName,
      where: '${_dbClient.contactIdColName} = ?',
      whereArgs: [id],
    );
  }
}
