import 'package:flutter/material.dart';
import 'package:friendlyreminder/models/AIPromptModel.dart';
import 'package:friendlyreminder/services/AIPromptService.dart';


class AIPromptViewModel extends ChangeNotifier {
  final AIPromptService _aiPromptService = AIPromptService();

  List<AIPromptModel> _prompts = [];

  bool _isLoading = false;
  String? _error;

  List<AIPromptModel> get prompts => _prompts; 

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPrompts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final prompts = await _aiPromptService.getAllPrompts();
      _prompts = prompts;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}