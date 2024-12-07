import 'package:flutter/material.dart';
import 'package:friendlyreminder/screens/ContactViewDetailScreen.dart';
import 'package:friendlyreminder/screens/GroupEditDetailScreen.dart';
import 'package:friendlyreminder/viewmodels/AIPromptViewModel.dart';
import 'package:friendlyreminder/viewmodels/ContactViewModel.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/models/GroupModel.dart';
import 'package:friendlyreminder/widgets/ContactCard.dart';
import 'package:friendlyreminder/viewmodels/GroupViewModel.dart';

class GroupViewDetailScreen extends StatefulWidget {
  final GroupModel? group;

  const GroupViewDetailScreen({
    Key? key,
    this.group,
  }) : super(key: key);

  @override
  State<GroupViewDetailScreen> createState() => _GroupViewDetailScreenState();
}

class _GroupViewDetailScreenState extends State<GroupViewDetailScreen> {
  late GroupModel? _group;
  late GroupViewModel groupVM;

  @override
  void initState() {
    super.initState();
    _group = widget.group;
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
    final aiPromptVM = Provider.of<AIPromptViewModel>(context, listen: false);
    return Consumer2<GroupViewModel, ContactsViewModel>(
        builder: (context, groupVM, contactVM, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            _group!.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupEditDetailScreen(group: _group),
                  ),
                );
              },
            )
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Theme.of(context).colorScheme.inversePrimary,
                  Theme.of(context).colorScheme.primary,
                ],
                center: Alignment.center, // Center of the AppBar
                radius: 5.0, // Adjust the radius for the spread
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    8.0, 12.0, 8.0, 8.0), // Padding for the header text
                child: Center(
                  child: Text(
                    'Your contacts that enjoy ${_group!.name}', // Display group name
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context)
                          .colorScheme
                          .primary, // Adapt to theme
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 1),
                          blurRadius: 4.0,
                          color: Colors.black.withOpacity(0.2), // Subtle shadow
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ), // Horizontal line separator
              Expanded(
                child: groupVM.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : groupVM.error != null
                        ? Center(child: Text('Error: ${groupVM.error}'))
                        : groupVM.contactInGroup.isEmpty
                            ? const Center(child: Text('Add contacts'))
                            : Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0), // Add top padding to the list
                                child: ListView.builder(
                                  itemCount: groupVM.contactInGroup.length,
                                  itemBuilder: (context, index) {
                                    final contact =
                                        groupVM.contactInGroup[index];
                                    return ContactCard(
                                      name: contact.name,
                                      onTap: () {
                                        final contactInfo = contactVM
                                            .getContactById(contact.id!);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ContactViewDetailScreen(
                                              contactWithGroups: contactInfo!,
                                              aiPrompts: aiPromptVM.prompts,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
