import 'package:friendlyreminder/services/DatabaseClient.dart';
import 'package:friendlyreminder/models/ContactModel.dart';
import 'package:friendlyreminder/models/InterestModel.dart';
import 'package:friendlyreminder/models/ContactWithInterestsModel.dart';
import 'package:friendlyreminder/services/InterestService.dart';

class ContactInterestService {
  final DatabaseClient _dbClient = DatabaseClient();
  final InterestService _interestService = InterestService();

  Future<List<ContactWithInterestsModel>> getContactWithInterests() async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> contactMaps = await db.query(
        _dbClient.contactTblName,
        orderBy: '${_dbClient.contactNameColName} ASC');

    List<ContactWithInterestsModel> contacts = [];

    for (var contactMap in contactMaps) {
      ContactModel contact = ContactModel.fromMap(contactMap);
      List<String> interests = await _getInterestsForContact(contact.id!);
      print(interests);
      contacts.add(
          ContactWithInterestsModel(contact: contact, interests: interests));
    }

    return contacts;
  }

  Future<List<String>> _getInterestsForContact(int contactId) async {
    final db = await _dbClient.database;

    List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT I.${_dbClient.interestNameColName}
    FROM ${_dbClient.interestTblName} I
    JOIN ${_dbClient.contactInterestTblName} CI ON (CI.${_dbClient.interestIdColName} = I.${_dbClient.interestIdColName})
    WHERE CI.${_dbClient.contactIdColName} = $contactId
    ''');
    return result.map((map) {
      return map[_dbClient.interestNameColName] as String;
    }).toList();
  }

  Future<int> createContact(
      ContactModel contact, List<InterestModel> interests) async {
    final db = await _dbClient.database;
    int contactId = await db.insert(_dbClient.contactTblName, contact.toMap());

    for (var interest in interests) {
      int interestId = await _getOrCreateInterestId(interest.name);
      await db.insert(_dbClient.contactInterestTblName, {
        _dbClient.contactIdColName: contactId,
        _dbClient.interestIdColName: interestId,
      });
    }

    return contactId;
  }

  Future<int> _getOrCreateInterestId(String interestName) async {
    final db = await _dbClient.database;
    var result = await db.query(
      _dbClient.interestTblName,
      where: '${_dbClient.interestNameColName} = ?',
      whereArgs: [interestName],
    );

    if (result.isNotEmpty) {
      return result.first[_dbClient.interestIdColName] as int;
    } else {
      return await db.insert(_dbClient.interestTblName,
          {_dbClient.interestNameColName: interestName});
    }
  }

  Future<void> deleteContact(int contactId) async {
    final db = await _dbClient.database;

    await db.delete(
      _dbClient.contactInterestTblName,
      where: '${_dbClient.contactIdColName} = ?',
      whereArgs: [contactId],
    );

    await db.delete(
      _dbClient.contactTblName,
      where: '${_dbClient.contactIdColName} = ?',
      whereArgs: [contactId],
    );
  }

  Future<void> updateContact(
      ContactModel contact, List<InterestModel> interests) async {
    final db = await _dbClient.database;

    // Update contact
    await db.update(
      _dbClient.contactTblName,
      contact.toMap(),
      where: '${_dbClient.contactIdColName} = ?',
      whereArgs: [contact.id],
    );

    await db.delete(
      _dbClient.contactInterestTblName,
      where: '${_dbClient.contactIdColName} = ?',
      whereArgs: [contact.id],
    );

    for (var interest in interests) {
      int interestId = await _interestService.getOrCreateInterest(interest);
      await db.insert(_dbClient.contactInterestTblName, {
        _dbClient.contactIdColName: contact.id,
        _dbClient.interestIdColName: interestId,
      });
    }
  }
}
