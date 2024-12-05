//can delete group members
//can delete the group
//can edit the name of the group
//back button takes you back to the main group page

import 'package:flutter/material.dart';
import 'package:friendlyreminder/widgets/StyledTextField.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/models/GroupModel.dart';
import 'package:friendlyreminder/widgets/ContactCard.dart';
import 'package:friendlyreminder/screens/GroupAddContactScreen.dart';
import 'package:friendlyreminder/viewmodels/GroupViewModel.dart';
import 'package:friendlyreminder/widgets/DeleteGroupPopup.dart';

class GroupViewDetailScreen extends StatefulWidget {
  final GroupModel group;

  const GroupViewDetailScreen({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  State<GroupViewDetailScreen> createState() => _GroupViewDetailScreenState();
}

class _GroupViewDetailScreenState extends State<GroupViewDetailScreen> {
  late GroupModel _group;
  late GroupViewModel groupVM;
  late TextEditingController _nameController;

  late bool isEmpty;

  @override
  void initState() {
    super.initState();
    _group = widget.group;
    _nameController =
        TextEditingController(text: _group.name); //name of the group
    // isEmpty = _nameController.text.isEmpty;

    Future.microtask(() {
      groupVM = Provider.of<GroupViewModel>(context, listen: false);
      groupVM.getContactsFromGroup(_group..id);
    });

    // _nameController.addListener(() {
    //   setState(() {
    //     isEmpty = _nameController.text.isEmpty;
    //   });
    // });
  }

  @override
  void dispose() {
    // _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupViewModel>(builder: (context, groupVM, child) {
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: const Text("Edit Group"),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupAddContactScreen(
                        group: _group,
                      ),
                    ),
                  );
                },
              ),
            ],
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "NAME",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: StyledTextField(
                    controller: _nameController,
                    hintText: "Group name",
                    prefixIcon: Icons.group,
                    padding: false,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Text(
                    "CONTACTS",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: groupVM.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : groupVM.error != null
                          ? Center(child: Text('Error: ${groupVM.error}'))
                          : groupVM.contactInGroup.isEmpty
                              ? const Center(child: Text('Add contacts'))
                              : ListView.builder(
                                  itemCount: groupVM.contactInGroup.length,
                                  itemBuilder: (context, index) {
                                    final contact =
                                        groupVM.contactInGroup[index];
                                    return ContactCard(
                                      name: contact.name,
                                      onTap: () => (),
                                      onDelete: () => groupVM
                                          .removeContactFromGroup(contact),
                                    );
                                  },
                                ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilledButton.icon(
                      onPressed: () {
                        showDeleteGroupAlert(context, () {
                          groupVM.deleteGroup(_group.id ?? -1);
                          Navigator.pop(context);
                        });
                      },
                      label: const Text("Delete Group"),
                      icon: const Icon(Icons.delete),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Adjust this value to change the radius
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
    });
  }
}
