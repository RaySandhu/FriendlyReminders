import 'package:flutter/material.dart';
import 'package:friendlyreminder/utilities/Utils.dart';

class ContactCard extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const ContactCard({
    super.key,
    required this.name,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        child: utils.isAlpha(name[0])
            ? Text(name[0].toUpperCase())
            : const Icon(Icons.person),
      ),
      title: Row(
        children: [
          Text(name),
          if (onDelete != null) ...[
            const Spacer(),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.close),
            )
          ]
        ],
      ),
      onTap: onTap,
    );
  }
}
