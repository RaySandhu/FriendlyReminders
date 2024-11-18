class ContactModel {
  final int? id;
  final String name;
  final String phone;
  final String email;
  // final List<String> tags;
  // final int reminder;
  final String notes;

  const ContactModel({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    // required this.tags,
    // required this.reminder,
    required this.notes,
  });

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['ContactId'] as int?,
      name: map['ContactName'] as String,
      phone: map['ContactPhone'] as String,
      email: map['ContactEmail'] as String,
      notes: map['ContactNotes'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ContactId': id, // This will be null for new records
      'ContactName': name,
      'ContactPhone': phone,
      'ContactEmail': email,
      'ContactNotes': notes,
    };
  }

  @override
  String toString() {
    return 'Contact{ContactId: $id, ContactName: $name, ContactPhone: $phone, ContactEmail: $email, ContactNotes: $notes}';
  }
}
