class ContactModel {
  final int? id;
  final String name;
  final String phone;
  final String email;
  // final List<String> tags;
  final String notes;
  final DateTime? latestContactDate;

  const ContactModel(
      {this.id,
      required this.name,
      required this.phone,
      required this.email,
      // required this.tags,
      required this.notes,
      this.latestContactDate});

  update(
      {String? name,
      String? phone,
      String? email,
      String? notes,
      DateTime? latestContactDate}) {
    return ContactModel(
      id: id, // id stays the same
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      notes: notes ?? this.notes,
      latestContactDate: latestContactDate,
    );
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['ContactId'] as int?,
      name: map['ContactName'] as String,
      phone: map['ContactPhone'] as String,
      email: map['ContactEmail'] as String,
      notes: map['ContactNotes'] as String,
      latestContactDate: map['LatestContactDate'] != null
          ? DateTime.parse(map['LatestContactDate'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ContactId': id, // This will be null for new records
      'ContactName': name,
      'ContactPhone': phone,
      'ContactEmail': email,
      'ContactNotes': notes,
      'LatestContactDate': latestContactDate?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ContactModel{ContactId: $id, ContactName: $name, ContactPhone: $phone, ContactEmail: $email, ContactNotes: $notes, Last contacted on: ${latestContactDate.toString()}}';
  }
}
