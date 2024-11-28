import 'package:flutter/material.dart';

class IconButtonWithTextRow extends StatelessWidget {
  final Icon icon;
  final String text;
  final VoidCallback onPressed;
  final Color buttonColour;

  const IconButtonWithTextRow({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.buttonColour,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16, // Horizontal padding
          vertical: 8,    // Vertical padding
        ),
        decoration: BoxDecoration(
          color: buttonColour, 
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 8), // Spacing between icon and text
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}