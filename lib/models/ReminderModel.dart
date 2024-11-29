class ReminderModel {
  final int? id;
  final int? reminderContactId;
  final DateTime date;
  final String freq;

  const ReminderModel({
    this.id,
    this.reminderContactId,
    required this.date,
    required this.freq,
  });

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['ReminderId'] as int?,
      reminderContactId: map['ReminderContactId'] as int?,
      date: DateTime.parse(map['ReminderDate']),
      freq: map['ReminderFreq'] as String,
    );
  }

  update({DateTime? date, String? freq}) {
    return ReminderModel(
      date: date ?? this.date,
      freq: freq ?? this.freq,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ReminderId': id,
      'ReminderContactId': reminderContactId,
      'ReminderDate': date,
      'ReminderFreq': freq,
    };
  }

  @override
  String toString() {
    return 'ReminderModel{Reminder ID: $id, Contact ID $reminderContactId, ReminderDate: ${date.toLocal().toString()}, ReminderFreq: $freq}';
  }
}
