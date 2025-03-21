import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:friendlyreminder/utilities/Utils.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard(
      {super.key,
      required this.name,
      required this.onTap,
      required this.onAccept,
      required this.onDismiss,
      required this.onReject,
      this.backgroundColor});

  final String name;
  final VoidCallback onTap;
  final VoidCallback onAccept;
  final VoidCallback onDismiss;
  final VoidCallback onReject;
  final Color? backgroundColor;

 @override
Widget build(BuildContext context) {
  return ListTile(
    tileColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
    leading: CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      child: utils.isAlpha(name[0])
          ? Text('${name[0].toUpperCase()}')
          : Icon(Icons.person),
    ),
    title: Row(
      children: [
        Expanded(
          child: Text(name),
          flex: 6,
        ),
        Spacer(),
        IconButton(
          onPressed: onAccept,
          icon: Icon(Icons.check),
          color: Colors.white,
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Colors.green), // Background color
          ),
        ),
        SizedBox(width: 8), // Add spacing between the buttons
        IconButton(
          onPressed: onDismiss,
          icon: Icon(Icons.schedule),
          color: Colors.white,
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Colors.amber), // Background color
          ),
        ),
        SizedBox(width: 8), // Add spacing between the buttons
        IconButton(
          onPressed: onReject,
          icon: Icon(Icons.close),
          color: Colors.white,
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Colors.red), // Background color
          ),
        ),
      ],
    ),
    onTap: onTap,
  );
}

}
