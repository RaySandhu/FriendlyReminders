//can delete group members
//can delete the group
//can edit the name of the group
//back button takes you back to the main group page

import 'package:flutter/material.dart';
import 'package:friendlyreminder/models/ContactWithGroupsModel.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/models/GroupModel.dart';
import 'package:friendlyreminder/models/ContactGroupModel.dart';
import 'package:friendlyreminder/models/ContactModel.dart';
import 'package:friendlyreminder/widgets/ContactCard.dart';
import 'package:friendlyreminder/screens/GroupAddContactScreen.dart';
import 'package:friendlyreminder/viewmodels/GroupViewModel.dart';
import 'package:friendlyreminder/services/GroupService.dart';
import 'package:friendlyreminder/widgets/DeleteGroupPopup.dart';
import 'package:friendlyreminder/screens/GroupScreen.dart';

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

  // final ContactModel _groupContact =
  //     ContactModel(name: '', phone: '', email: '', notes: '');
  late TextEditingController _noteController;
  late bool isEmpty;

  @override
  void initState() {
    super.initState();
    _group = widget.group;
    _noteController =
        TextEditingController(text: _group.name); //name of the group
    isEmpty = _noteController.text.isEmpty;

    Future.microtask(() {
      groupVM = Provider.of<GroupViewModel>(context, listen: false);
      groupVM.getContactsFromGroup(_group..id);
    });

    _noteController.addListener(() {
      setState(() {
        isEmpty = _noteController.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

//the plus sign to add new contacts to the group
  // Future<void> addPersonToGroup() async {
  //   final updatedGroup = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => GroupAddContactScreen(
  //         groupContact: _groupContact,
  //       ),
  //     ),
  //   );

  //   if (updatedGroup != null) {
  //     setState(() {
  //       _group = updatedGroup;
  //     });
  //   }
  // }

  //fix the following delete operations
  void deleteContact(int index) {
    setState(() {
      //_group.contacts.removeAt(index); //fix this delete part
    });
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
            title: Text(_group.name), //name of group
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // addPersonToGroup();
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: groupVM.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : groupVM.error != null
                          ? Center(child: Text('Error: ${groupVM.error}'))
                          : ListView.builder(
                              itemCount: groupVM.viewGroup.length,
                              itemBuilder: (context, index) {
                                final contact = groupVM.viewGroup[index];
                                return ContactCard(
                                  name: contact.name,
                                  onTap: () => (),
                                  onDelete: () => (),
                                );
                              },
                            ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton.icon(
                    onPressed: () {
                      print(groupVM.viewGroup);
                      // showDeleteGroupAlert(context, () {R
                      //   //fix the below code
                      //   //_group
                      //   //    .deleteGroup(_group.hashCode ?? -1); //id of group needed
                      //   // Navigator.pop(context);
                      //   // Navigator.pop(context);
                      // });
                      // MaterialPageRoute(builder: (context) => GroupScreen());
                    },
                    label: const Text("Delete Group"),
                    icon: const Icon(Icons.delete),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Adjust this value to change the radius
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
