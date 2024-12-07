import 'package:flutter/material.dart';

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
      elevation: 4, // Subtle shadow to give depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: const Color.fromARGB(255, 247, 135, 135),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0), // Adjusted padding for smaller screens
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title Text
            Center(
  child: Text(
    "Time to Reach Out!",
    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w700, // Bolder weight
          fontSize: 20, // Larger font size
          color: Colors.black, // Contrasting text color
          letterSpacing: 1.2, // Increase letter spacing for a clean look
          shadows: [
            Shadow(
              blurRadius: 3.0, // Blur the shadow
              color: Colors.black.withOpacity(0.4), // Subtle shadow color
              //offset: Offset(2, 2), // Slightly offset shadow
            ),
          ],
        ),
    textAlign: TextAlign.center,
  ),
)
,
            const SizedBox(height: 12), // Adjusted spacing for smaller screens

            // Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly space buttons
              children: [
                // Accept Button
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Material(
                      color: Colors.green, // Green background
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: onAccept,
                        child: Container(
                          width: 48, // Adjust width for button size
                          height: 32, // Adjust height for button size (smaller)
                          alignment: Alignment.center, // Center the icon
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8), // Rounded corners
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20, // Adjust the icon size to fit the smaller button
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Dismiss Button
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Material(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: onDismiss,
                        child: Container(
                          width: 48, // Adjust width for button size
                          height: 32, // Adjust height for button size (smaller)
                          alignment: Alignment.center, // Center the icon
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8), // Rounded corners
                          ),
                          child: Icon(
                            Icons.schedule,
                            color: Colors.white,
                            size: 20, // Adjust the icon size to fit the smaller button
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                
                // Reject Button
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Material(
                      color: Colors.red, 
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: onReject,
                        child: Container(
                          width: 48, // Adjust width for button size
                          height: 32, // Adjust height for button size (smaller)
                          alignment: Alignment.center, // Center the icon
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8), // Rounded corners
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20, // Adjust the icon size to fit the smaller button
                          ),
                        ),
                      ),
                    ),
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
