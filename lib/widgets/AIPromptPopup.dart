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
        Text(
          'AI Generated Icebreaker', 
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
          ),
        const SizedBox(width: 16),
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