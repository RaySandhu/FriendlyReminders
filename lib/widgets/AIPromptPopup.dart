import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AIPromptPopup extends StatelessWidget{
final String prompt;

  const AIPromptPopup({
    super.key,
    required this.prompt,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(children: [
        const Text('AI Generated Icebreaker', style: TextStyle(fontWeight: FontWeight.bold),),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: prompt));
          },
        ),
      ],),
      content: Text(prompt),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}