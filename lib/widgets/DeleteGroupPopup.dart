import 'package:flutter/material.dart';

void showDeleteGroupAlert(BuildContext context, Function onDeleted) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Deleting Group',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to delete this group?',
                   style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black)),
              Text('This group will be deleted permanently.',
                   style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade700)),
            ],
          ),
        ),
        actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) { 
                  if (states.contains(MaterialState.hovered)) { 
                    return Colors.red.shade50; 
                  } 
                  return Colors.transparent;
                }),
              ),
              child: Text('Yes', 
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.red)),
              onPressed: () {
                onDeleted();
                Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}