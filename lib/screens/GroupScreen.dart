import 'package:flutter/material.dart';
import 'package:friendlyreminder/screens/GroupEditDetailScreen.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/widgets/GroupCard.dart';
import 'package:friendlyreminder/viewmodels/GroupViewModel.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupViewModel>(
      builder: (context, groupVM, child) {
        // Filter groups based on the search query
        final filteredGroups = _searchQuery.isEmpty
            ? groupVM.groups
            : groupVM.groups
                .where((group) => group.name
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
                .toList();

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _isSearching = !_isSearching;
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  )
                : Text(
                    "Groups",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
            actions: _isSearching
                ? []
                : [
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _isSearching = true;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GroupEditDetailScreen(),
                          ),
                        );
                      },
                    ),
                  ],
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
                          : filteredGroups.isEmpty
                              ? Center(
                                  child: Text(
                                    'No groups found',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: filteredGroups.length,
                                  itemBuilder: (context, index) {
                                    final group = filteredGroups[index];
                                    return GroupCard(
                                        name: group.name,
                                        numMembers: group.size ?? 0,
                                        //idk why the group.size is 0 (need to check if it's incrementing properly when a tag is added to a contact)
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  GroupEditDetailScreen(
                                                group: group,
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
