//done button
//x button to discard changes
//group name
//add ppl to group --> brings up contacts page + multisect

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/models/GroupModel.dart';
import 'package:friendlyreminder/widgets/ContactCard.dart';
import 'package:friendlyreminder/screens/GroupViewDetailScreen.dart';
import 'package:friendlyreminder/viewmodels/GroupViewModel.dart';
import 'package:friendlyreminder/screens/GroupScreen.dart';


class GroupAddScreen extends StatefulWidget {
  const GroupAddScreen({Key? key,});

  @override
  State<GroupAddScreen> createState() => _GroupAddScreenState();
}

class _GroupAddScreenState extends State<GroupAddScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedColor;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveGroup() async {
    if (_nameController.text.isEmpty || _selectedColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      GroupModel newGroup = GroupModel(name: _nameController.text);
      int groupId = await Provider.of<GroupViewModel>(context,
                            listen: false)
                        .createGroup(newGroup);
      MaterialPageRoute(
        builder: (context) => GroupScreen()
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Create New Group'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
              onPressed: _saveGroup,
            style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                minimumSize: const Size(0, 0),
              ),
              child: const Text("Done"),

          )
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Name',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter group name',
                filled: true,
                fillColor: Color(0xFFF8F8F8), // Light background color
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Colour',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: _selectedColor,
              items: ['Red', 'Blue', 'Green', 'Yellow', 'Purple']
                  .map(
                    (color) => DropdownMenuItem(
                      value: color,
                      child: Text(color),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedColor = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFFF8F8F8), // Light background color
              ),
              hint: const Text('Select a color'),
            ),
          ],
        ),
      ),
    );
  }
}
