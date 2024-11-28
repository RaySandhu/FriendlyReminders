import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AIPromptPopup extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(children: [
        const Text('AI Generated Icebreaker', style: TextStyle(fontWeight: FontWeight.bold),),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            Clipboard.setData(const ClipboardData(text: 'AI Prompt goes here'));
          },
        ),
      ],),
      content: const Text('AI Prompt goes here'),
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