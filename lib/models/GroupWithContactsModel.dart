import 'package:friendlyreminder/models/ContactModel.dart';
import 'package:collection/collection.dart';

class GroupWithContactsModel {
  final String? group;
  final List<ContactModel> contacts;

  const GroupWithContactsModel({
    this.group = "",
    required this.contacts,
  });

  update({String? group, List<ContactModel>? contacts}) {
    return GroupWithContactsModel(
      group: group ?? this.group,
      contacts: contacts ?? this.contacts,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupWithContactsModel &&
        other.group == group &&
        const ListEquality().equals(other.contacts, contacts);
  }

  @override
  int get hashCode => group.hashCode ^ contacts.hashCode;

  @override
  String toString() {
    return 'GroupWithContactsModel{groups: $group, contacts: $contacts}';
  }
}
