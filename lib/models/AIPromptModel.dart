class AIPromptModel{
  final int promptId;
  final String promptText;

  const AIPromptModel({
    required this.promptId,
    required this.promptText,
  });

  factory AIPromptModel.fromMap(Map<String, dynamic> map) {
    return AIPromptModel(
      promptId: map['PromptId'] as int,
      promptText: map['PromptText'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'PromptId': promptId,
      'PromptText': promptText,
    };
  }

  @override
  String toString() {
    return '{$promptText}';
  }
}