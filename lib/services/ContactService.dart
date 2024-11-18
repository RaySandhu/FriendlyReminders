import 'package:sqflite/sqflite.dart';
import 'package:friendlyreminder/models/ContactModel.dart';
import 'package:friendlyreminder/services/DatabaseClient.dart';

class ContactService {
  final DatabaseClient _dbClient = DatabaseClient();

  Future<List<ContactModel>> getAllContacts() async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps = await db.query(
        _dbClient.contactTblName,
        orderBy: '${_dbClient.contactNameColName} ASC');
    return List.generate(maps.length, (i) {
      return ContactModel.fromMap(maps[i]);
    });
  }

  Future<ContactModel> getContact(int contactId) async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _dbClient.contactTblName,
      where: '${_dbClient.contactIdColName} = ?',
      whereArgs: [contactId],
    );
    if (maps.isNotEmpty) {
      return ContactModel.fromMap(maps.first);
    }
    throw Exception('ContactService - Contact not found');
  }

  Future<int> createContact(ContactModel contact) async {
    final db = await _dbClient.database;
    int contactId = await db.insert(
      _dbClient.contactTblName,
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return contactId;
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

  Future<void> deleteContact(int contactId) async {
    final db = await _dbClient.database;
    await db.delete(
      _dbClient.contactTblName,
      where: '${_dbClient.contactIdColName} = ?',
      whereArgs: [contactId],
    );
  }
}
