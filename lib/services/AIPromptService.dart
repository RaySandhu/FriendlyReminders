import 'package:friendlyreminder/models/AIPromptModel.dart';
import 'package:friendlyreminder/services/DatabaseClient.dart';

class AIPromptService {
  final DatabaseClient _dbClient = DatabaseClient();

  Future<List<AIPromptModel>> getAllPrompts() async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps = await db.query(_dbClient.aiPromptsTbl,
        orderBy: '${_dbClient.promptId} ASC');
    return List.generate(maps.length, (i) {
      return AIPromptModel.fromMap(maps[i]);
    });
  }

  Future<AIPromptModel> getPrompt(int promptId) async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _dbClient.aiPromptsTbl,
      where: '${_dbClient.promptId} = ?',
      whereArgs: [promptId],
    );
    if (maps.isNotEmpty) {
      return AIPromptModel.fromMap(maps.first);
    }
    throw Exception('AIPromptService - Prompt not found');
  }

  Future<AIPromptModel> getRandomPrompt() async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _dbClient.aiPromptsTbl,
      orderBy: 'RANDOM()',
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return AIPromptModel.fromMap(maps.first);
    }
    throw Exception('AIPromptService - No prompts found');
  }
}
