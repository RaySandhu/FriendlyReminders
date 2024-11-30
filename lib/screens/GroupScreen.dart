import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/widgets/GroupCard.dart';
import 'package:friendlyreminder/viewmodels/GroupViewModel.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GroupViewModel>(builder: (context, groupVM, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:
              Text("Groups", style: Theme.of(context).textTheme.headlineSmall),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SafeArea(
            child: Column(
          children: [
            Expanded(
              child: groupVM.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : groupVM.error != null
                      ? Center(child: Text('Error: ${groupVM.error}'))
                      : groupVM.groups.isEmpty
                          ? Center(
                              child: Text('No groups found',
                                  style:
                                      Theme.of(context).textTheme.titleLarge))
                          : ListView.builder(
                              itemCount: groupVM.groups.length,
                              itemBuilder: (context, index) {
                                final group = groupVM.groups[index];
                                return GroupCard(
                                  name: group.name,
                                  numMembers: group.size ?? 0,
                                  onTap: () => print(group),
                                );
                              },
                            ),
            ),
          ],
        )),
      );
    });
  }
}
