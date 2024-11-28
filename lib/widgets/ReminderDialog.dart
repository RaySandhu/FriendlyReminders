import 'package:flutter/material.dart';

Future<void> showReminderModal({
  required BuildContext context,
  required TextEditingController reminderController,
  required void Function(DateTime? date, String? frequency) onReminderSet,
}) async {
  DateTime? selectedDate;
  String? selectedFrequency = "Once";
  final List<String> frequencies = [
    "Once",
    "Daily",
    "Weekly",
    "Monthly",
    "Yearly"
  ];

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Set Reminder",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  selectedDate = pickedDate;
                  print("Selected Date: ${selectedDate?.toLocal()}");
                }
              },
              child: Text(
                selectedDate == null
                    ? "Select Date"
                    : "Selected Date: ${selectedDate!.toLocal()}".split(' ')[0],
              ),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedFrequency,
              isExpanded: true,
              onChanged: (String? newValue) {
                selectedFrequency = newValue;
                print("Selected Frequency: $selectedFrequency");
              },
              items: frequencies.map((String frequency) {
                return DropdownMenuItem<String>(
                  value: frequency,
                  child: Text(frequency),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (selectedDate != null && selectedFrequency != null) {
                  reminderController.text =
                      "${"Date:${selectedDate!.toLocal()}".split(' ')[0]}, Frequency: $selectedFrequency";
                  // Pass the selected values back to the parent widget
                  onReminderSet(selectedDate, selectedFrequency);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text("Please select both date and frequency."),
                      margin: EdgeInsets.only(bottom: 220.0),
                    ),
                  );
                }
              },
              child: const Text("Set Reminder"),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}
