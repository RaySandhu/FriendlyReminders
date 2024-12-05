class ContactModel implements Comparable<ContactModel> {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final String notes;

  const ContactModel({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.notes,
  });

  update({String? name, String? phone, String? email, String? notes}) {
    return ContactModel(
        id: id, // id stays the same
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        notes: notes ?? this.notes);
  }

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
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ContactModel &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            phone == other.phone &&
            email == other.email &&
            notes == other.notes;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      email.hashCode ^
      notes.hashCode;

  @override
  int compareTo(ContactModel other) {
    return name.compareTo(other.name);
  }

  @override
  String toString() {
    return 'ContactModel{ContactId: $id, ContactName: $name, ContactPhone: $phone, ContactEmail: $email, ContactNotes: $notes}';
  }
}
