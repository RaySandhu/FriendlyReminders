class ReminderModel {
  final DateTime date;
  final String freq;

  const ReminderModel({
    required this.date,
    required this.freq,
  });

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      date: map['ReminderDate'] as DateTime,
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
      'ReminderDate': date,
      'ReminderFreq': freq,
    };
  }

  @override
  String toString() {
    return 'ReminderModel{ReminderDate: ${date.toLocal().toString()}, ReminderFreq: $freq}';
  }
}
