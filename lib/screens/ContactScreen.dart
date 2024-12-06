import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:friendlyreminder/screens/ContactViewDetailScreen.dart';
import 'package:friendlyreminder/viewmodels/AIPromptViewModel.dart';
import 'package:friendlyreminder/widgets/ContactsAppBar.dart';
import 'package:provider/provider.dart';
import 'package:friendlyreminder/widgets/ContactCard.dart';
import 'package:friendlyreminder/viewmodels/ContactViewModel.dart';
import 'package:friendlyreminder/screens/ContactEditDetailScreen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  bool _isSearching = false;
  bool _isFilterOpen = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset > 0 && _isFilterOpen) {
      setState(() {
        _isFilterOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactsViewModel>(
      builder: (context, contactVM, child) {
        return Scaffold(
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 175.0,
                pinned: true,
                floating: false,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // Calculate the collapse ratio
                    final double collapseRatio =
                        (constraints.maxHeight - kToolbarHeight) /
                            (175.0 - kToolbarHeight);

                    return Stack(
                      children: [
                        // Radial gradient background
                        Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.9),
                                Theme.of(context).colorScheme.primary,
                              ],
                              center: Alignment.center,
                              radius: 5.0,
                            ),
                          ),
                        ),
                        // Scaling logo
// Fixed-size logo
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Container(
                              height: 50, // Set a fixed height for the logo
                              child: Transform.scale(
                                scale: 4, // Adjust scale dynamically
                                child: Image.asset(
                                  '/images/FriendlyRemindersLogo.png',
                                  fit: BoxFit.contain,
                                  height: 200,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Collapsed title

                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Opacity(
                              opacity: collapseRatio.clamp(
                                  0.6, 1.0), // Opacity based on collapse ratio
                              child: collapseRatio >= 0.6
                                  ? AnimatedTextKit(
                                      animatedTexts: [
                                        TyperAnimatedText(
                                          'Friendly Reminders',
                                          textStyle: const TextStyle(
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                          speed:
                                              const Duration(milliseconds: 100),
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                title: ContactsAppBar(
                    contactVM: Provider.of<ContactsViewModel>(context)),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            FilledButton.icon(
                              onPressed: () {
                                setState(() {
                                  _isFilterOpen = !_isFilterOpen;
                                });
                              },
                              icon: Icon(
                                _isFilterOpen
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                              ),
                              label: const Text("FILTER"),
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                minimumSize: const Size(0, 32),
                              ),
                            ),
                            const SizedBox(width: 5),
                            OutlinedButton(
                              onPressed: () {
                                contactVM.clearFilters();
                                setState(() {
                                  _isSearching = false;
                                  _searchController.clear();
                                });
                              },
                              child: const Text("CLEAR"),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                minimumSize: const Size(0, 32),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isFilterOpen)
                      Container(
                        width: double.infinity,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: contactVM
                                .getAllUniqueGroups(contactVM.contacts)
                                .map((group) {
                              return FilterChip(
                                label: Text(group),
                                side: BorderSide.none,
                                showCheckmark: false,
                                selected:
                                    contactVM.selectedGroups.contains(group),
                                onSelected: (bool selected) {
                                  contactVM.toggleGroupFilter(group);
                                },
                                selectedColor: Colors.blue.shade100,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: contactVM.selectedGroups.map((group) {
                            return Chip(
                              label: Text(group),
                              deleteIcon: const Icon(Icons.close),
                              onDeleted: () => contactVM.removeFilter(group),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final contactWithGroups = contactVM.contacts[index];
                    final aiPromptsList =
                        Provider.of<AIPromptViewModel>(context).prompts;
                    return ContactCard(
                      name: contactWithGroups.contact.name,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactViewDetailScreen(
                              contactWithGroups: contactWithGroups,
                              aiPrompts: aiPromptsList,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  childCount: contactVM.contacts.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
