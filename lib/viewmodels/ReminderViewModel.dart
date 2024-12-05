import 'package:flutter/material.dart';
import 'package:friendlyreminder/models/ReminderModel.dart';
import 'package:friendlyreminder/services/ReminderService.dart';

class ReminderViewModel extends ChangeNotifier {
  final ReminderService _reminderService = ReminderService();

  List<ReminderModel> _reminders = [];
  List<ReminderModel> _currentReminders = [];
  List<ReminderModel> _pastReminders = [];
  List<int> _usersWithActiveReminders = [];

  bool _isLoading = false;
  String? _error;

  List<ReminderModel> get reminders => _reminders;
  List<ReminderModel> get currentReminders => _currentReminders;
  List<ReminderModel> get pastReminders => _pastReminders;
  List<int> get usersWithActiveReminders => _usersWithActiveReminders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all reminders for a specific contact
  Future<void> renderCurrentPastReminders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final allReminders = await _reminderService.getAllReminders();
      Set activeReminders = <int>{};

      _currentReminders = allReminders.where((reminder) {
        if (DateTime.now().isSameDate(reminder.date)) {
          activeReminders.add(reminder.reminderContactId);
          return true;
        }
        return false;
      }).toList();

      _pastReminders = allReminders.where((reminder) {
        if (DateTime.now().isAfter(reminder.date) &&
            !DateTime.now().isSameDate(reminder.date)) {
          activeReminders.add(reminder.reminderContactId);
          return true;
        }
        return false;
      }).toList();

      _usersWithActiveReminders = activeReminders.cast<int>().toList();
    } catch (e) {
      _error = "Failed to load reminders: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load all reminders for a specific contact
  Future<void> loadRemindersByContact(int contactId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _reminders = await _reminderService.getRemindersByContactId(contactId);
    } catch (e) {
      _error = "Failed to load reminders: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get time till next reminder
  Future<int> nextReminder(int contactId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await loadRemindersByContact(contactId);
      if (_reminders.isEmpty) {
        return -1;
      }
      // gives earliest reminder first
      _reminders.sort((a, b) => a.date.compareTo(b.date));

      final DateTime now = DateTime.now();
      for (final reminder in _reminders) {
        if (reminder.date.isAfter(now)) {
          return reminder.date.difference(now).inDays;
        }
      }
    } catch (e) {
      _error = "Failed to calculate time till next reminder";
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return -1;
  }

  /// Add a new reminder
  Future<void> addReminder(ReminderModel reminder, int contactId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _reminderService.createReminder(reminder, contactId);
      await loadRemindersByContact(contactId); // Refresh after adding
    } catch (e) {
      _error = "Failed to add reminder: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update an existing reminder
  Future<void> updateReminder(
      ReminderModel reminder, int reminderId, int contactId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _reminderService.updateReminder(reminder, reminderId);
      await loadRemindersByContact(contactId); // Refresh after updating
    } catch (e) {
      _error = "Failed to update reminder: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete a reminder
  Future<void> deleteReminder(int reminderId, int contactId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _reminderService.deleteReminder(reminderId);
      await loadRemindersByContact(contactId); // Refresh after deleting
    } catch (e) {
      _error = "Failed to delete reminder: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> incrementReminder(
      ReminderModel reminder, int reminderId, int contactId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // delete the reminder if its for single instance
      if (reminder.freq == "Once") {
        await deleteReminder(reminderId, contactId);
      } else {
        // Determine the new date based on frequency
        DateTime newDate = reminder.date;
        while (newDate.isBefore(DateTime.now())) {
          newDate = _getIncrementedDate(newDate, reminder.freq);
        }

        // Create a new ReminderModel with the updated date
        final updatedReminder = reminder.update(date: newDate);

        // Update the reminder in the database
        await _reminderService.updateReminder(updatedReminder, reminderId);
      }

      // Refresh reminders for the contact and reminders page
      await loadRemindersByContact(contactId);
      await renderCurrentPastReminders();
    } catch (e) {
      _error = "Failed to increment reminder: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

extension DateTimeComparison on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

/// Private helper method to calculate the next date based on frequency
DateTime _getIncrementedDate(DateTime currentDate, String frequency) {
  switch (frequency.toLowerCase()) {
    case "daily":
      return currentDate.add(const Duration(days: 1));
    case "weekly":
      return currentDate.add(const Duration(days: 7));
    case "monthly":
      return DateTime(
        currentDate.year,
        currentDate.month + 1,
        currentDate.day,
        currentDate.hour,
        currentDate.minute,
        currentDate.second,
      );
    case "yearly":
      return DateTime(
        currentDate.year + 1,
        currentDate.month,
        currentDate.day,
        currentDate.hour,
        currentDate.minute,
        currentDate.second,
      );
    default:
      throw Exception("Invalid frequency: $frequency");
  }
}
