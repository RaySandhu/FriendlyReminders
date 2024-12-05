import 'package:flutter/material.dart';
import 'package:friendlyreminder/utilities/Utils.dart';

class ContactCard extends StatelessWidget {
  final String name;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final void Function(bool?)? onCheck;
  final bool? isSelected;

  const ContactCard({
    super.key,
    required this.name,
    required this.onTap,
    this.onDelete,
    this.onCheck,
    this.isSelected,
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
      title: Text(name),
      trailing: onDelete != null
          ? IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.close),
            )
          : onCheck != null && isSelected != null
              ? Checkbox(
                  value: isSelected,
                  onChanged: onCheck,
                )
              : null,
      onTap: onTap,
    );
  }
}
