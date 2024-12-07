import 'package:flutter/material.dart';
import 'package:friendlyreminder/models/ReminderModel.dart';
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

        // print("Past: ${past.toString()},\n Current: ${current.toString()}");

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
                    // Title on the left
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Reminders",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // Logo in the center
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
                    // Placeholder for future icons on the right
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 40, // Placeholder size
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                                    onAccept: () => {
                                      contactVM.updateContactDate(contactInfo),
                                      reminderVM.incrementReminder(
                                          past[index],
                                          past[index].id!,
                                          contactInfo.contact.id!)
                                    },
                                    onDismiss: () => {
                                      reminderVM.incrementReminder(
                                          past[index],
                                          past[index].id!,
                                          contactInfo.contact.id!),
                                      reminderVM.addReminder(
                                          ReminderModel(
                                              date: DateTime.now()
                                                  .add(const Duration(days: 1)),
                                              freq: "Single"),
                                          contactInfo.contact.id!),
                                    },
                                    onReject: () =>
                                        reminderVM.incrementReminder(
                                            past[index],
                                            past[index].id!,
                                            contactInfo.contact.id!),
                                    backgroundColor: Colors.red[200],
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
                                      print(current[index]);
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
                                    onAccept: () => {
                                      // update last contacted on for contact
                                      contactVM.updateContactDate(contactInfo),
                                      // increment all reminders to be past today's date
                                      reminderVM.incrementReminder(
                                          current[index],
                                          current[index].id!,
                                          contactInfo.contact.id!)
                                    },
                                    onDismiss: () => {
                                      reminderVM.incrementReminder(
                                          current[index],
                                          current[index].id!,
                                          contactInfo.contact.id!),
                                      ReminderModel(
                                          date: DateTime.now()
                                              .add(const Duration(days: 1)),
                                          freq: "Single"),
                                      contactInfo.contact.id!,
                                    },
                                    onReject: () =>
                                        // increment all reminders to be past tomorrow's date
                                        reminderVM.incrementReminder(
                                            current[index],
                                            current[index].id!,
                                            contactInfo.contact.id!),
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
