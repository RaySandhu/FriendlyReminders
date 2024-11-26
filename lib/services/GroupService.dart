import 'package:friendlyreminder/services/DatabaseClient.dart';
import 'package:friendlyreminder/models/GroupModel.dart';

class GroupService {
  final DatabaseClient _dbClient = DatabaseClient();

  Future<List<GroupModel>> getAllGroups() async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps = await db.query(_dbClient.groupTbl,
        orderBy: '${_dbClient.groupName} ASC');
    return List.generate(maps.length, (i) {
      return GroupModel.fromMap(maps[i]);
    });
  }

  Future<int> getOrCreateGroup(GroupModel group) async {
    final db = await _dbClient.database;

    var result = await db.query(
      _dbClient.groupTbl,
      where: '${_dbClient.groupName} = ?',
      whereArgs: [group.name],
    );

    // Check if group already exists
    int groupId;
    if (result.isNotEmpty) {
      // Group already exists
      groupId = result.first[_dbClient.groupId] as int;
    } else {
      // Group does not exist
      groupId = await db.insert(_dbClient.groupTbl, group.toMap());
    }
    return groupId;
  }

  Future<List<GroupModel>> getGroupsFromContacts(int contactId) async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT G.*
    FROM ${_dbClient.groupTbl} G
    JOIN ${_dbClient.contactGroupTbl} CG ON (CG.${_dbClient.groupId} = G.${_dbClient.groupId})
    WHERE CG.${_dbClient.contactId} = $contactId
    ''');
    return List.generate(maps.length, (i) {
      return GroupModel.fromMap(maps[i]);
    });
  }

  Future<void> addGroupToContact(int contactId, int groupId) async {
    final db = await _dbClient.database;
    await db.insert(_dbClient.contactGroupTbl, {
      _dbClient.contactId: contactId,
      _dbClient.groupId: groupId,
    });
  }

  Future<void> removeGroupFromContact(int contactId) async {
    final db = await _dbClient.database;
    await db.delete(
      _dbClient.contactGroupTbl,
      where: '${_dbClient.contactId} = ?',
      whereArgs: [contactId],
    );
  }

  Future<void> updateGroup(GroupModel group) async {
    final db = await _dbClient.database;
    await db.update(
      _dbClient.groupTbl,
      group.toMap(),
      where: '${_dbClient.groupId} = ?',
      whereArgs: [group.id],
    );
  }

  Future<void> deleteGroup(int groupId) async {
    final db = await _dbClient.database;
    await db.delete(
      _dbClient.groupTbl,
      where: '${_dbClient.groupId} = ?',
      whereArgs: [groupId],
    );
  }
}
