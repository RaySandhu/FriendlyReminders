class ContactModel {
  final int id;
  final String name;
  final String phone;
  final String email;
  // final List<String> tags;
  // final int reminder;
  final String notes;

  const ContactModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    // required this.tags,
    // required this.reminder,
    required this.notes,
  });

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'] as int,
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      notes: map['notes'] as String,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'notes': notes,
    };
  }

  @override
  String toString() {
    return 'Contact{id: $id, name: $name, phone: $phone, email: $email, notes: $notes}';
  }
}
