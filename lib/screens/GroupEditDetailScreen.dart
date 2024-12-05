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

class GroupEditDetailScreen extends StatefulWidget {
  final GroupModel? group;

  const GroupEditDetailScreen({
    Key? key,
    this.group,
  }) : super(key: key);

  @override
  State<GroupEditDetailScreen> createState() => _GroupEditDetailScreenState();
}

class _GroupEditDetailScreenState extends State<GroupEditDetailScreen> {
  late GroupModel? _group;
  late GroupViewModel groupVM;
  late TextEditingController _nameController = TextEditingController();

  late bool isEmpty;

  @override
  void initState() {
    super.initState();
    _group = widget.group;
    if (_group != null) {
      _nameController = TextEditingController(text: _group!.name);
    }
    Future.microtask(() {
      groupVM = Provider.of<GroupViewModel>(context, listen: false);
      if (_group != null) {
        groupVM.getContactsFromGroup(_group!..id);
      } else {
        groupVM.getContactsFromGroup(null);
      }
    });
  }

  @override
  void dispose() {
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
            title: Text(_group == null ? "Create Group" : "Edit Group",
                style: Theme.of(context).textTheme.headlineSmall),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    minimumSize: const Size(0, 0),
                  ),
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      if (_group == null) {
                        GroupModel newGroup = GroupModel(
                          name: _nameController.text,
                          size: groupVM.contactInGroup.length,
                        );
                        groupVM.createGroup(newGroup, groupVM.contactInGroup);
                      } else {
                        GroupModel newGroup = _group!.update(
                          name: _nameController.text,
                          size: groupVM.contactInGroup.length,
                        );
                        groupVM.updateGroup(newGroup, groupVM.contactInGroup);
                      }
                    }
                    Navigator.pop(context);
                  },
                  child: Text(_group == null ? "Done" : "Save"),
                ),
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
                    "GROUP NAME",
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "CONTACTS",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      FilledButton.icon(
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
                        icon: const Icon(Icons.person_add, size: 19),
                        label: Text(
                          "ADD",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 1),
                          minimumSize: const Size(0, 0),
                        ),
                      ),
                    ],
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
                if (_group != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilledButton.icon(
                        onPressed: () {
                          showDeleteGroupAlert(context, () {
                            groupVM.deleteGroup(_group?.id ?? -1);
                            Navigator.pop(context);
                          });
                        },
                        label: const Text("Delete Group"),
                        icon: const Icon(Icons.delete),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
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
