import 'package:flutter/material.dart';
import 'package:friendlyreminder/screens/ContactViewDetailScreen.dart';
import 'package:friendlyreminder/viewmodels/AIPromptViewModel.dart';
import 'package:friendlyreminder/viewmodels/ContactViewModel.dart';
import 'package:friendlyreminder/viewmodels/ReminderViewModel.dart';
import 'package:friendlyreminder/widgets/ReminderCard.dart';
import 'package:provider/provider.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReminderViewModel>(
      builder: (context, reminderVM, child) {
        final past = reminderVM.pastReminders;
        final current = reminderVM.currentReminders;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Reminders",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: reminderVM.isLoading
              ? const Center(child: CircularProgressIndicator())
              : reminderVM.error != null
                  ? Center(child: Text('Error: ${reminderVM.error}'))
                  : (past.isEmpty && current.isEmpty)
                      ? const Center(child: Text('No reminders found'))
                      : ListView(
                          children: [
                            if (past.isNotEmpty) ...[
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Past Reminders",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: past.length,
                                itemBuilder: (context, index) {
                                  // Check if reminderContactId is null
                                  if (past[index].reminderContactId == null) {
                                    print("Contact not found ${past[index]}");
                                    return const SizedBox.shrink();
                                  }

                                  // Access the existing ContactsViewModel via Provider
                                  final contactVM =
                                      Provider.of<ContactsViewModel>(context,
                                          listen: false);
                                  final contactInfo = contactVM.getContactById(
                                      past[index].reminderContactId!);

                                  if (contactInfo == null) {
                                    print("Null contact info");
                                    return const ListTile(
                                      title: Text('Unknown Contact'),
                                      subtitle: Text(
                                          'Could not retrieve contact information.'),
                                    );
                                  }

                                  final aiPromptsList =
                                      Provider.of<AIPromptViewModel>(context,
                                              listen: false)
                                          .prompts;

                                  return ReminderCard(
                                    name: contactInfo.contact.name,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ContactViewDetailScreen(
                                            contactWithGroups: contactInfo,
                                            aiPrompts: aiPromptsList,
                                          ),
                                        ),
                                      );
                                    },
                                    onAccept: () => print("Accept"),
                                    onDismiss: () => print("Dismiss"),
                                    onReject: () => print("Reject"),
                                  );
                                },
                              ),
                            ],
                            if (current.isNotEmpty) ...[
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Current Reminders",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: current.length,
                                itemBuilder: (context, index) {
                                  // Access the existing ContactsViewModel via Provider
                                  if (current[index].reminderContactId ==
                                      null) {
                                    print(
                                        "Contact not found ${current[index]}");
                                    return const SizedBox.shrink();
                                  }

                                  final contactVM =
                                      Provider.of<ContactsViewModel>(context,
                                          listen: false);
                                  final contactInfo = contactVM.getContactById(
                                      current[index].reminderContactId!);

                                  if (contactInfo == null) {
                                    print("Null contact info");
                                    return const ListTile(
                                      title: Text('Unknown Contact'),
                                      subtitle: Text(
                                          'Could not retrieve contact information.'),
                                    );
                                  }

                                  final aiPromptsList =
                                      Provider.of<AIPromptViewModel>(context,
                                              listen: false)
                                          .prompts;

                                  return ReminderCard(
                                    name: contactInfo.contact.name,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ContactViewDetailScreen(
                                            contactWithGroups: contactInfo,
                                            aiPrompts: aiPromptsList,
                                          ),
                                        ),
                                      );
                                    },
                                    onAccept: () => print("Accept"),
                                    onDismiss: () => print("Dismiss"),
                                    onReject: () => print("Reject"),
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
        );
      },
    );
  }
}
