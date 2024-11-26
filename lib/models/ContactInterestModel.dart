class ContactGroupModel {
  final int contactId;
  final int groupId;

  const ContactGroupModel({
    required this.contactId,
    required this.groupId,
  });

  factory ContactGroupModel.fromMap(Map<String, dynamic> map) {
    return ContactGroupModel(
      contactId: map['ContactId'] as int,
      groupId: map['GroupId'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ContactId': contactId,
      'GroupId': groupId,
    };
  }

  @override
  String toString() {
    return 'ContactGroupModel{ContactId: $contactId, GroupId: $groupId}';
  }
}
