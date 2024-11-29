import 'package:flutter/material.dart';
import 'package:friendlyreminder/widgets/IconButtonWithTextRow.dart';

class ContactReminderCard extends StatelessWidget {
  const ContactReminderCard({
    super.key,
    required this.onAccept,
    required this.onDismiss,
    required this.onReject,
  });

  final VoidCallback onAccept;
  final VoidCallback onDismiss;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Ensures the Column takes minimum height
        children: [
          // Title Text
          Center(
            child: Text(
              "Time to Reach Out!",
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24), // Spacing between text and buttons
          // Button Row
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Accept Button
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButtonWithTextRow(
                    onPressed: onAccept,
                    icon: const Icon(Icons.check, color: Colors.white),
                    text: 'On It!',
                    buttonColour: Colors.green,
                  ),
                ),
              ),

              // Dismiss Button
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButtonWithTextRow(
                    onPressed: onDismiss,
                    icon: const Icon(Icons.schedule, color: Colors.white),
                    text: 'Snooze',
                    buttonColour: Colors.amber,
                  ),
                ),
              ),

              // Reject Button
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButtonWithTextRow(
                    onPressed: onReject,
                    icon: const Icon(Icons.close, color: Colors.white),
                    text: 'Dismiss',
                    buttonColour: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
