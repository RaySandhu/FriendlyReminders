import 'package:flutter/material.dart';

class ContactInfoListTile extends StatelessWidget {
  final IconData prefixIcon;
  final String title;
  final String content;
  final void Function()? onTap;

  const ContactInfoListTile({
    super.key,
    required this.prefixIcon,
    required this.title,
    required this.content,
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
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            content,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
