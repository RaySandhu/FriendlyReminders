import 'package:flutter/material.dart';
import 'package:friendlyreminder/screens/GroupEditDetailScreen.dart';
import 'package:friendlyreminder/screens/GroupViewDetailScreen.dart';
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
          appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(kToolbarHeight), // Standard AppBar height
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Theme.of(context).colorScheme.inversePrimary,
                    Theme.of(context).colorScheme.primary,
                  ],
                  center: Alignment.center,
                  radius: 5.0, // Adjust the radius for the spread
                ),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    // Title or Search bar on the left
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: _isSearching
                            ? SizedBox(
                                height: 40.0,
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.search),
                                    hintText: 'Search',
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        setState(() {
                                          _isSearching = !_isSearching;
                                          _searchController.clear();
                                          _searchQuery = '';
                                        });
                                      },
                                    ),
                                    contentPadding: const EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value;
                                    });
                                  },
                                ),
                              )
                            : Row(
                                children: [
                                  Text(
                                    "Groups",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    if (!_isSearching)
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Container(
                            height: 50, // Set a fixed height for the logo
                            child: Transform.scale(
                              scale: 4, // Adjust scale dynamically
                              child: Image.asset(
                                'assets/images/FriendlyRemindersLogo.png',
                                fit: BoxFit.contain,
                                height: 200,
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Search and Add icons on the right
                    if (!_isSearching)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.search,
                                    color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _isSearching = true;
                                  });
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.add, color: Colors.white),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const GroupEditDetailScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
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
                                                  GroupViewDetailScreen(
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
