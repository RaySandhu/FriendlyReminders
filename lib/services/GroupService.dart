import 'package:friendlyreminder/services/DatabaseClient.dart';
import 'package:friendlyreminder/models/GroupModel.dart';

class GroupService {
  final DatabaseClient _dbClient = DatabaseClient();

  Future<List<GroupModel>> getAllGroups() async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps = await db.query(
        _dbClient.groupTblName,
        orderBy: '${_dbClient.groupNameColName} ASC');
    return List.generate(maps.length, (i) {
      return GroupModel.fromMap(maps[i]);
    });
  }

  Future<int> getOrCreateGroup(GroupModel group) async {
    final db = await _dbClient.database;

    var result = await db.query(
      _dbClient.groupTblName,
      where: '${_dbClient.groupNameColName} = ?',
      whereArgs: [group.name],
    );

    // Check if group already exists
    int groupId;
    if (result.isNotEmpty) {
      // Group already exists
      groupId = result.first[_dbClient.groupIdColName] as int;
    } else {
      // Group does not exist
      groupId = await db.insert(_dbClient.groupTblName, group.toMap());
    }
    return groupId;
  }

  Future<List<GroupModel>> getGroupsFromContacts(int contactId) async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT G.*
    FROM ${_dbClient.groupTblName} G
    JOIN ${_dbClient.contactGroupTblName} CG ON (CG.${_dbClient.groupIdColName} = G.${_dbClient.groupIdColName})
    WHERE CG.${_dbClient.contactIdColName} = $contactId
    ''');
    return List.generate(maps.length, (i) {
      return GroupModel.fromMap(maps[i]);
    });
  }

  Future<void> addGroupToContact(int contactId, int groupId) async {
    final db = await _dbClient.database;
    await db.insert(_dbClient.contactGroupTblName, {
      _dbClient.contactIdColName: contactId,
      _dbClient.groupIdColName: groupId,
    });
  }

  Future<void> removeGroupFromContact(int contactId) async {
    final db = await _dbClient.database;
    await db.delete(
      _dbClient.contactGroupTblName,
      where: '${_dbClient.contactIdColName} = ?',
      whereArgs: [contactId],
    );
  }

  Future<void> updateGroup(GroupModel group) async {
    final db = await _dbClient.database;
    await db.update(
      _dbClient.groupTblName,
      group.toMap(),
      where: '${_dbClient.groupIdColName} = ?',
      whereArgs: [group.id],
    );
  }

  Future<void> deleteGroup(int groupId) async {
    final db = await _dbClient.database;
    await db.delete(
      _dbClient.groupTblName,
      where: '${_dbClient.groupIdColName} = ?',
      whereArgs: [groupId],
    );
  }
}
