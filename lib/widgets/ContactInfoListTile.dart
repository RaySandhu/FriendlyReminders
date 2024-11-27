import 'package:flutter/material.dart';

class ContactInfoListTile extends StatelessWidget {
  final IconData prefixIcon;
  final String title;
  final void Function()? onTap;

  const ContactInfoListTile({
    super.key,
    required this.prefixIcon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        prefixIcon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EMAIL',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
