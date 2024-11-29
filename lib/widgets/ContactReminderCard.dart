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
      title: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize:
                MainAxisSize.min, // Ensures the Column takes minimum height
            children: [
              // Title Text
              Center(
                child: Text(
                  "Time to Reach Out!",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8), // Spacing between text and buttons
              // Button Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Accept Button
                  FilledButton.icon(
                    onPressed: onAccept,
                    label: const Text("Accept"),
                    icon: const Icon(Icons.check),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      ),
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(0, 32)),
                    ),
                  ),

                  // Dismiss Button
                  FilledButton.icon(
                    onPressed: onDismiss,
                    label: const Text("Dismiss"),
                    icon: const Icon(Icons.schedule),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.amber),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      ),
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(0, 32)),
                    ),
                  ),
                  // Reject
                  FilledButton.icon(
                    onPressed: onAccept,
                    label: const Text("Reject"),
                    icon: const Icon(Icons.close),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      ),
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(0, 32)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
