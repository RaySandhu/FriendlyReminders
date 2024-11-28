import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AIPromptPopup extends StatelessWidget{
  final String promptText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('AI Generated Icebreaker'),
      content: Text('This is an AI Prompt'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}